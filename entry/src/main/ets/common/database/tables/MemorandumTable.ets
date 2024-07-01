import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../constants/CommonConstants';
import { logger } from '../../utils/logger';
import AppDatabase from '../AppDatabase';
import MemorandumData from '../data/MemorandumData';
import MemorandumDataWithImg from '../data/MemorandumDataWithImg';
import MemorandumImgData from '../data/MemorandumImgData';
import MemorandumImgTable from './MemorandumImgTable';

export default class MemorandumTable {
  private static instance: MemorandumTable;
  private memorandumTable: AppDatabase = new AppDatabase(
    CommonConstants.MEMORANDUM_TABLE.tableName,
    CommonConstants.MEMORANDUM_TABLE.sqlCreate,
    CommonConstants.MEMORANDUM_TABLE.columns
  );
  private memorandumImgTable: MemorandumImgTable  = MemorandumImgTable.getInstance(()=>{})

  private constructor(callback: Function = () => {}) {
    this.memorandumTable.getRdbStore(() => {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'MemorandumTable initialized');
      callback()
    });
  }

  public static getInstance(callback: Function = () => {}): MemorandumTable {
    if (!MemorandumTable.instance) {
      MemorandumTable.instance = new MemorandumTable(callback);
    } else {
      callback();
    }
    return MemorandumTable.instance;
  }

  getRdbStore(callback: Function = () => {}) {
    this.memorandumTable.getRdbStore(callback);
  }

  insertData(memorandum: MemorandumData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(memorandum);
    this.memorandumTable.insertData(valueBucket, callback);
  }

  deleteData(memorandum: MemorandumData, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_TABLE.tableName);
    predicates.equalTo('id', memorandum.id);
    this.memorandumTable.deleteData(predicates, callback);
  }

  updateData(memorandum: MemorandumData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(memorandum);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_TABLE.tableName);
    predicates.equalTo('id', memorandum.id);
    this.memorandumTable.updateData(predicates, valueBucket, callback);
  }

  query(amount: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.memorandumTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        logger.info(`${CommonConstants.MEMORANDUM_TABLE_TAG} Query no results!`);
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: MemorandumDataWithImg[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: MemorandumData = {
            id: 0, memorandumIcon: '', memorandumTitle: '', memorandumContent: '', memorandumCreateTime: 0,
            memorandumUpdateTime: 0
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.memorandumIcon = resultSet.getString(resultSet.getColumnIndex('memorandumIcon'));
          tmp.memorandumTitle = resultSet.getString(resultSet.getColumnIndex('memorandumTitle'));
          tmp.memorandumContent = resultSet.getString(resultSet.getColumnIndex('memorandumContent'));
          tmp.memorandumCreateTime = resultSet.getLong(resultSet.getColumnIndex('memorandumCreateTime'));
          tmp.memorandumUpdateTime = resultSet.getLong(resultSet.getColumnIndex('memorandumUpdateTime'));

          if (this.memorandumImgTable) {
            this.memorandumImgTable.query(tmp.id, (checkInResultSet: relationalStore.ResultSet) => {
              let checkInResults: string[] = [];
              if (checkInResultSet != null && checkInResultSet.rowCount > 0) {
                logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG, `图片数据：${checkInResultSet.rowCount}}`);
                checkInResultSet.goToFirstRow();
                do {
                  let checkInData: MemorandumImgData = {
                    id: checkInResultSet.getDouble(checkInResultSet.getColumnIndex('id')),
                    memorandumId: checkInResultSet.getDouble(checkInResultSet.getColumnIndex('memorandumId')),
                    memorandumImgFilePath: checkInResultSet.getString(checkInResultSet.getColumnIndex('memorandumImgFilePath'))
                  };
                  checkInResults.push(checkInData.memorandumImgFilePath);
                } while (checkInResultSet.goToNextRow());
              } else {
                logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG, `图片数据：null}`);
              }

              result[i] = new MemorandumDataWithImg(tmp, checkInResults);
              if (i === count - 1) {
                callback(result);
              }
            });
          }
          resultSet.goToNextRow();
        }
      }
    });
  }
}

function generateBucket(memorandum: MemorandumData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.memorandumIcon = memorandum.memorandumIcon;
  obj.memorandumTitle = memorandum.memorandumTitle;
  obj.memorandumContent = memorandum.memorandumContent;
  obj.memorandumCreateTime = memorandum.memorandumCreateTime;
  obj.memorandumUpdateTime = memorandum.memorandumUpdateTime;
  return obj;
}
