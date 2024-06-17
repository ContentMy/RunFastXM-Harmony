import relationalStore from '@ohos.data.relationalStore';
import { DatabaseTable } from './ConstantsInterface';
export class CommonConstants {
  static readonly SPACE_SM = 4
  static readonly SPACE_MD = 10
  static readonly SPACE_LG = 16

  /**
   * Log tag.
   */
  static readonly RUN_FAST_XM_DB_TAG = '[Debug.run.fast.xm]';
  static readonly REMIND_TABLE_TAG = '[Debug.RemindTable]';
  static readonly INDEX_TAG = '[Debug.Index]';

  /**
   * runfastxmdb database config.
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };

  /**
   * remind table config.
   */
  static readonly REMIND_TABLE: DatabaseTable = {
    tableName: 'remind_table',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS remind_table(id INTEGER PRIMARY KEY AUTOINCREMENT, remindImg TEXT, ' +
    'remindTitle TEXT, remindContent TEXT, remindTime INTEGER, remindStartTime INTEGER, remindEndTime INTEGER, ' +
    'remindCompleteStatus INTEGER)',
    columns: ['id', 'remindImg', 'remindTitle', 'remindContent','remindTime', 'remindStartTime', 'remindEndTime', 'remindCompleteStatus']
  };
}