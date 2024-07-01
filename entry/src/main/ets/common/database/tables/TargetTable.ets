import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../constants/CommonConstants';
import { logger } from '../../utils/logger';
import AppDatabase from '../AppDatabase';
import TargetCheckInData from '../data/TargetCheckInData';
import TargetData from '../data/TargetData';
import TargetDataWithCheckIn from '../data/TargetDataWithCheckIn';
import TargetCheckInTable from './TargetCheckInTable';

export default class TargetTable {
  private static instance: TargetTable | null = null;
  private targetTable: AppDatabase = new AppDatabase(
    CommonConstants.TARGET_TABLE.tableName,
    CommonConstants.TARGET_TABLE.sqlCreate,
    CommonConstants.TARGET_TABLE.columns
  );
  private targetCheckInTable: TargetCheckInTable = TargetCheckInTable.getInstance(() => {
    logger.info(CommonConstants.TARGET_TABLE_TAG, 'TargetCheckInTable initialized');
  });

  private constructor(callback: Function = () => {}) {
    this.targetTable.getRdbStore(() => {
      logger.info(CommonConstants.TARGET_TABLE_TAG, 'TargetTable initialized');
      callback();
    });
  }

  public static getInstance(callback: Function = () => {}): TargetTable {
    if (!TargetTable.instance) {
      TargetTable.instance = new TargetTable(callback);
    }
    return TargetTable.instance;
  }

  getRdbStore(callback: Function = () => {}) {
    this.targetTable.getRdbStore(callback);
  }

  insertData(target: TargetData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(target);
    this.targetTable.insertData(valueBucket, callback);
  }

  deleteData(target: TargetData, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_TABLE.tableName);
    predicates.equalTo('id', target.id);
    this.targetTable.deleteData(predicates, callback);
  }

  updateData(target: TargetData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(target);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_TABLE.tableName);
    predicates.equalTo('id', target.id);
    this.targetTable.updateData(predicates, valueBucket, callback);
  }

  query(amount: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.targetTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        logger.info(CommonConstants.TARGET_TABLE_TAG, 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: TargetData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: TargetData = {
            id: -1, targetImg: '', targetTitle: '', targetContent: '', targetStatus: 0,
            targetStartTime: 0, targetEndTime: 0, targetIsRemind: false
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.targetImg = resultSet.getString(resultSet.getColumnIndex('targetImg'));
          tmp.targetTitle = resultSet.getString(resultSet.getColumnIndex('targetTitle'));
          tmp.targetContent = resultSet.getString(resultSet.getColumnIndex('targetContent'));
          tmp.targetStatus = resultSet.getLong(resultSet.getColumnIndex('targetStatus'));
          tmp.targetStartTime = resultSet.getLong(resultSet.getColumnIndex('targetStartTime'));
          tmp.targetEndTime = resultSet.getLong(resultSet.getColumnIndex('targetEndTime'));
          tmp.targetIsRemind = resultSet.getDouble(resultSet.getColumnIndex('targetIsRemind')) == 1;
          result.push(tmp);
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  queryWithCheckInStatus(amount: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.targetTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        logger.info(CommonConstants.TARGET_TABLE_TAG, 'Query no results!');
        callback([]);
      } else {
        try {
          resultSet.goToFirstRow();
          const result: TargetDataWithCheckIn[] = [];
          for (let i = 0; i < count; i++) {
            let tmp: TargetData = {
              id: -1, targetImg: '', targetTitle: '', targetContent: '', targetStatus: 0,
              targetStartTime: 0, targetEndTime: 0, targetIsRemind: false
            };
            tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
            tmp.targetImg = resultSet.getString(resultSet.getColumnIndex('targetImg'));
            tmp.targetTitle = resultSet.getString(resultSet.getColumnIndex('targetTitle'));
            tmp.targetContent = resultSet.getString(resultSet.getColumnIndex('targetContent'));
            tmp.targetStatus = resultSet.getLong(resultSet.getColumnIndex('targetStatus'));
            tmp.targetStartTime = resultSet.getLong(resultSet.getColumnIndex('targetStartTime'));
            tmp.targetEndTime = resultSet.getLong(resultSet.getColumnIndex('targetEndTime'));
            tmp.targetIsRemind = resultSet.getDouble(resultSet.getColumnIndex('targetIsRemind')) == 1;

            if (this.targetCheckInTable) {
              this.targetCheckInTable.queryByTargetId(tmp.id, (checkInResultSet: relationalStore.ResultSet) => {
                let checkInResults: TargetCheckInData[] = [];
                if (checkInResultSet && checkInResultSet.rowCount > 0) {
                  logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG, `Check-in data: ${checkInResultSet.rowCount}`);
                  checkInResultSet.goToFirstRow();
                  do {
                    let checkInData: TargetCheckInData = {
                      id: checkInResultSet.getDouble(checkInResultSet.getColumnIndex('id')),
                      targetId: checkInResultSet.getDouble(checkInResultSet.getColumnIndex('targetId')),
                      targetCheckIn: checkInResultSet.getDouble(checkInResultSet.getColumnIndex('targetCheckIn')) == 1,
                      targetCheckInTime: checkInResultSet.getLong(checkInResultSet.getColumnIndex('targetCheckInTime')),
                      targetCancelCheckInTime: checkInResultSet.getLong(checkInResultSet.getColumnIndex('targetCancelCheckInTime'))
                    };
                    checkInResults.push(checkInData);
                  } while (checkInResultSet.goToNextRow());
                } else {
                  logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG, `Check-in data: null`);
                }

                let targetCheckInStatus = false;
                if (checkInResults.length > 0) {
                  const today = new Date().setHours(0, 0, 0, 0);
                  const todayCheckIn = checkInResults.find(ci => {
                    const targetCheckInDate = new Date(ci.targetCheckInTime);
                    targetCheckInDate.setHours(0, 0, 0, 0);
                    return targetCheckInDate.getTime() === today;
                  });
                  targetCheckInStatus = !!todayCheckIn;
                }

                result.push(new TargetDataWithCheckIn(tmp, targetCheckInStatus));
                if (i === count - 1) {
                  callback(result);
                }
              });
            }
            resultSet.goToNextRow();
          }
        } catch (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `queryWithCheckInStatus() failed, err: ${err}`);
        }
      }
    });
  }
}

function generateBucket(target: TargetData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.targetImg = target.targetImg;
  obj.targetTitle = target.targetTitle;
  obj.targetContent = target.targetContent;
  obj.targetStatus = target.targetStatus;
  obj.targetStartTime = target.targetStartTime;
  obj.targetEndTime = target.targetEndTime;
  obj.targetIsRemind = target.targetIsRemind;
  return obj;
}
