import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../constants/CommonConstants';
import AppDatabase from '../AppDatabase';
import TargetCheckInData from '../data/TargetCheckInData';

export default class TargetCheckInTable {
  private static instance: TargetCheckInTable | null = null;
  // private targetCheckInTable: AppDatabase;
  private targetCheckInTable = new AppDatabase(CommonConstants.TARGET_CHECK_IN_TABLE.tableName, CommonConstants.TARGET_CHECK_IN_TABLE.sqlCreate, CommonConstants.TARGET_CHECK_IN_TABLE.columns);

  private constructor(callback: Function = () => {}) {
    this.targetCheckInTable.getRdbStore(callback);
  }

  public static getInstance(callback: Function = () => {}): TargetCheckInTable {
    if (!TargetCheckInTable.instance) {
      TargetCheckInTable.instance = new TargetCheckInTable(callback);
    }
    return TargetCheckInTable.instance;
  }

  getRdbStore(callback: Function = () => {}) {
    this.targetCheckInTable.getRdbStore(callback);
  }

  insertData(targetCheckInData: TargetCheckInData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateCheckInBucket(targetCheckInData);
    this.targetCheckInTable.insertDataWithResolution(valueBucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE, callback);
  }

  updateData(targetCheckInData: TargetCheckInData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateCheckInBucket(targetCheckInData);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_CHECK_IN_TABLE.tableName);
    predicates.equalTo('id', targetCheckInData.id);
    this.targetCheckInTable.updateData(predicates, valueBucket, callback);
  }

  queryByTargetId(targetId: number, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TARGET_CHECK_IN_TABLE.tableName);
    predicates.equalTo('targetId', targetId);
    this.targetCheckInTable.query(predicates, callback);
  }
}

function generateCheckInBucket(targetCheckInData: TargetCheckInData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.targetId = targetCheckInData.targetId;
  obj.targetCheckIn = targetCheckInData.targetCheckIn;
  obj.targetCheckInTime = targetCheckInData.targetCheckInTime;
  return obj;
}
