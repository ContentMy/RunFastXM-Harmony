import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../contants/CommonConstants';
import { logger } from '../utils/logger';

export default class AppDatabase{

  private rdbStore: relationalStore.RdbStore | null = null;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'getRdbStore() has no callback!');
      return;
    }
    if (this.rdbStore !== null) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'The rdbStore exists.');
      callback();
      return
    }
    let context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG, (err, rdb) => {
      if (err) {
        logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `gerRdbStore() failed, err: ${err}`);
        return;
      }
      this.rdbStore = rdb;
      this.rdbStore.executeSql(this.sqlCreateTable);
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'getRdbStore() finished.');
      callback();
    });
  }

  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'insertData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `insertData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `insertData() finished: ${ret}`);
        callback(ret);
      });
    }
  }

  deleteData(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'deleteData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    if (this.rdbStore) {
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `deleteData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `deleteData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'updateDate() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.update(valueBucket, predicates, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `updateData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `updateData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'query() has no callback!');
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `query() failed, err:  ${err}`);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'query() finished.');
        callback(resultSet);
        resultSet.close();
      });
    }
  }
}