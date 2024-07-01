import relationalStore from '@ohos.data.relationalStore';
import { CommonConstants } from '../constants/CommonConstants';
import { logger } from '../utils/logger';

export default class AppDatabase {
  private static instance: AppDatabase | null = null;
  private rdbStore: relationalStore.RdbStore | null = null;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  public static getInstance(tableName: string, sqlCreateTable: string, columns: Array<string>): AppDatabase {
    if (!AppDatabase.instance) {
      AppDatabase.instance = new AppDatabase(tableName, sqlCreateTable, columns);
    }
    return AppDatabase.instance;
  }

  private handleCallback(callback: Function | undefined) {
    if (!callback || typeof callback !== 'function') {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'Callback is not a function!');
      return false;
    }
    return true;
  }

  getRdbStore(callback: Function = () => {}) {
    if (!this.handleCallback(callback)) return;

    if (this.rdbStore) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'The rdbStore exists.');
      callback();
      return;
    }

    const context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG, (err, rdb) => {
      if (err) {
        logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `getRdbStore() failed, err: ${err}`);
        return;
      }
      this.rdbStore = rdb;
      this.rdbStore.executeSql(this.sqlCreateTable);
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'getRdbStore() finished.');
      callback();
    });
  }

  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {}) {
    if (!this.handleCallback(callback)) return;

    if (this.rdbStore) {
      this.rdbStore.insert(this.tableName, data, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `insertData() failed, err: ${err}`);
          callback(false);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `insertData() finished: ${ret}`);
        callback(ret);
      });
    }
  }

  insertDataWithResolution(
    data: relationalStore.ValuesBucket,
    resolutionMode: relationalStore.ConflictResolution,
    callback: Function = () => {}
  ) {
    if (!this.handleCallback(callback)) return;

    if (this.rdbStore) {
      this.rdbStore.insert(this.tableName, data, resolutionMode, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `insertData() failed, err: ${err}`);
          callback(false);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `insertData() finished: ${ret}`);
        callback(ret);
      });
    }
  }

  deleteData(predicates: relationalStore.RdbPredicates, callback: Function = () => {}) {
    if (!this.handleCallback(callback)) return;

    if (this.rdbStore) {
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `deleteData() failed, err: ${err}`);
          callback(false);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `deleteData() finished: ${ret}`);
        callback(true);
      });
    }
  }

  updateData(
    predicates: relationalStore.RdbPredicates,
    data: relationalStore.ValuesBucket,
    callback: Function = () => {}
  ) {
    if (!this.handleCallback(callback)) return;

    if (this.rdbStore) {
      this.rdbStore.update(data, predicates, (err, ret) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `updateData() failed, err: ${err}`);
          callback(false);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `updateData() finished: ${ret}`);
        callback(true);
      });
    }
  }

  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {}) {
    if (!this.handleCallback(callback)) return;

    if (this.rdbStore) {
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          logger.error(CommonConstants.RUN_FAST_XM_DB_TAG, `query() failed, err: ${err}`);
          return;
        }
        logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, 'query() finished.');
        callback(resultSet);
        resultSet.close();
      });
    }
  }
}
