
import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../contants/CommonConstants';
import AppDatabase from '../AppDatabase';
import RemindData from '../data/RemindData';
export default class RemindTable{
  private remindTable = new AppDatabase(CommonConstants.REMIND_TABLE.tableName, CommonConstants.REMIND_TABLE.sqlCreate,
    CommonConstants.REMIND_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.remindTable.getRdbStore(callback);
  }


  getRdbStore(callback: Function = () => {
  }) {
    this.remindTable.getRdbStore(callback);
  }
  insertData(remind: RemindData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(remind);
    this.remindTable.insertData(valueBucket, callback);
  }

  deleteData(remind: RemindData, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.REMIND_TABLE.tableName);
    predicates.equalTo('id', remind.id);
    this.remindTable.deleteData(predicates, callback);
  }

  updateData(remind: RemindData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(remind);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.REMIND_TABLE.tableName);
    predicates.equalTo('id', remind.id);
    this.remindTable.updateData(predicates, valueBucket, callback);
  }

  private query(predicates:relationalStore.RdbPredicates, callback: Function) {

    this.remindTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.REMIND_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: RemindData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: RemindData = new RemindData();
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.remindImg = resultSet.getString(resultSet.getColumnIndex('remindImg'));
          tmp.remindTitle = resultSet.getString(resultSet.getColumnIndex('remindTitle'));
          tmp.remindContent = resultSet.getString(resultSet.getColumnIndex('remindContent'));
          tmp.remindTime = resultSet.getLong(resultSet.getColumnIndex('remindTime'));
          tmp.remindStartTime = resultSet.getLong(resultSet.getColumnIndex('remindStartTime'));
          tmp.remindEndTime = resultSet.getLong(resultSet.getColumnIndex('remindEndTime'));
          tmp.remindCompleteStatus = resultSet.getDouble(resultSet.getColumnIndex('remindCompleteStatus')) == 1 ? true : false;
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }


  queryAllInProgressRemind(amount: number, callback: Function, isAll: boolean = true) {
    // 创建查询条件对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.REMIND_TABLE.tableName);
    // 添加条件：查询 remindCompleteStatus == 0 的数据
    predicates.equalTo('remindCompleteStatus', 0);
    // 根据是否查询所有数据设置查询条件
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.query(predicates,callback)
  }

  queryAllCompletedRemind(amount: number, callback: Function, isAll: boolean = true) {
    // 创建查询条件对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.REMIND_TABLE.tableName);
    // 添加条件：查询 remindCompleteStatus == 0 的数据
    predicates.equalTo('remindCompleteStatus', 1);
    // 根据是否查询所有数据设置查询条件
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.query(predicates,callback)
  }
}

function generateBucket(remind: RemindData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.remindImg = remind.remindImg;
  obj.remindTitle = remind.remindTitle;
  obj.remindContent = remind.remindContent;
  obj.remindTime = remind.remindTime;
  obj.remindStartTime = remind.remindStartTime;
  obj.remindEndTime = remind.remindEndTime;
  obj.remindCompleteStatus = remind.remindCompleteStatus;
  return obj;
}