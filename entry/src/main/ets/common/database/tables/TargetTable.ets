
import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../contants/CommonConstants';
import AppDatabase from '../AppDatabase';
import TargetData from '../data/TargetData';
export default class TargetTable{
  private targetTable = new AppDatabase(CommonConstants.TARGET_TABLE.tableName, CommonConstants.TARGET_TABLE.sqlCreate,
    CommonConstants.TARGET_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.targetTable.getRdbStore(callback);
  }


  getRdbStore(callback: Function = () => {
  }) {
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
    // 创建查询条件对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_TABLE.tableName);
    // 根据是否查询所有数据设置查询条件
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.targetTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.TARGET_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: TargetData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: TargetData = {
            id: 0, targetImg:'', targetTitle:'', targetContent:'', targetStatus:0,
            targetStartTime:0, targetEndTime:0, targetIsRemind:false
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.targetImg = resultSet.getString(resultSet.getColumnIndex('targetImg'));
          tmp.targetTitle = resultSet.getString(resultSet.getColumnIndex('targetTitle'));
          tmp.targetContent = resultSet.getString(resultSet.getColumnIndex('targetContent'));
          tmp.targetStatus = resultSet.getLong(resultSet.getColumnIndex('targetStatus'));
          tmp.targetStartTime = resultSet.getLong(resultSet.getColumnIndex('targetStartTime'));
          tmp.targetEndTime = resultSet.getLong(resultSet.getColumnIndex('targetEndTime'));
          tmp.targetIsRemind = resultSet.getDouble(resultSet.getColumnIndex('targetIsRemind')) == 1 ? true : false;
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
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