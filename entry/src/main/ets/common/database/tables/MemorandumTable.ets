
import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../contants/CommonConstants';
import AppDatabase from '../AppDatabase';
import MemorandumData from '../data/MemorandumData';
export default class MemorandumTable{
  private memorandumTable = new AppDatabase(CommonConstants.MEMORANDUM_TABLE.tableName, CommonConstants.MEMORANDUM_TABLE.sqlCreate,
    CommonConstants.MEMORANDUM_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.memorandumTable.getRdbStore(callback);
  }


  getRdbStore(callback: Function = () => {
  }) {
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
    // 创建查询条件对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_TABLE.tableName);
    // 根据是否查询所有数据设置查询条件
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.memorandumTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.MEMORANDUM_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: MemorandumData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: MemorandumData = {
            id: 0, memorandumIcon:'', memorandumTitle:'', memorandumContent:'', memorandumCreateTime:0,
            memorandumUpdateTime:0};
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.memorandumIcon = resultSet.getString(resultSet.getColumnIndex('memorandumIcon'));
          tmp.memorandumTitle = resultSet.getString(resultSet.getColumnIndex('memorandumTitle'));
          tmp.memorandumContent = resultSet.getString(resultSet.getColumnIndex('memorandumContent'));
          tmp.memorandumCreateTime = resultSet.getLong(resultSet.getColumnIndex('memorandumCreateTime'));
          tmp.memorandumUpdateTime = resultSet.getLong(resultSet.getColumnIndex('memorandumUpdateTime'));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
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