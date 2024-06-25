
import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../../contants/CommonConstants';
import AppDatabase from '../AppDatabase';
import MemorandumData from '../data/MemorandumData';
import MemorandumImgData from '../data/MemorandumImgData';

export default class MemorandumImgTable{
  private memorandumImgTable = new AppDatabase(CommonConstants.MEMORANDUM_IMG_TABLE.tableName, CommonConstants.MEMORANDUM_IMG_TABLE.sqlCreate,
    CommonConstants.MEMORANDUM_IMG_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.memorandumImgTable.getRdbStore(callback);
  }


  getRdbStore(callback: Function = () => {
  }) {
    this.memorandumImgTable.getRdbStore(callback);
  }

  insertData(memorandumImg: MemorandumImgData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(memorandumImg);
    this.memorandumImgTable.insertData(valueBucket, callback);
  }

  deleteData(memorandumImg: MemorandumImgData, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_IMG_TABLE.tableName);
    predicates.equalTo('id', memorandumImg.id);
    this.memorandumImgTable.deleteData(predicates, callback);
  }

  updateData(memorandumImg: MemorandumImgData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(memorandumImg);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_IMG_TABLE.tableName);
    predicates.equalTo('id', memorandumImg.id);
    this.memorandumImgTable.updateData(predicates, valueBucket, callback);
  }

  query(memorandumId: number, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.MEMORANDUM_IMG_TABLE.tableName);
    predicates.equalTo('memorandumId', memorandumId);
    this.memorandumImgTable.query(predicates, callback);
  }

}

function generateBucket(memorandumImg: MemorandumImgData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.memorandumId = memorandumImg.memorandumId;
  obj.memorandumImgFilePath = memorandumImg.memorandumImgFilePath;
  return obj;
}