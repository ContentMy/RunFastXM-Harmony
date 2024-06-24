import relationalStore from '@ohos.data.relationalStore';
import { DatabaseTable } from './ConstantsInterface';
export class CommonConstants {
  static readonly SPACE_SM = 4
  static readonly SPACE_MD = 10
  static readonly SPACE_LG = 16

  /**
   * String that empty.
   */
  static readonly EMPTY_STRING: string = '';

  /**
   * Log tag.
   */
  static readonly RUN_FAST_XM_DB_TAG = '[Debug.run.fast.xm]';
  static readonly REMIND_TABLE_TAG = '[Debug.RemindTable]';
  static readonly TARGET_TABLE_TAG = '[Debug.TargetTable]';
  static readonly MEMORANDUM_TABLE_TAG = '[Debug.MemorandumTable]';
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

  /**
   * target table config.
   */
  static readonly TARGET_TABLE: DatabaseTable = {
    tableName: 'target_table',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS target_table(id INTEGER PRIMARY KEY AUTOINCREMENT, targetImg TEXT, ' +
    'targetTitle TEXT, targetContent TEXT, targetStatus INTEGER, targetStartTime INTEGER, targetEndTime INTEGER, ' +
    'targetIsRemind INTEGER)',
    columns: ['id', 'targetImg', 'targetTitle', 'targetContent','targetStatus', 'targetStartTime', 'targetEndTime', 'targetIsRemind']
  };

  static readonly TARGET_CHICK_IN_TABLE: DatabaseTable = {
    tableName: 'target_check_in_table',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS target_check_in_table(id INTEGER PRIMARY KEY AUTOINCREMENT, targetId INTEGER, ' +
    'targetCheckIn INTEGER, targetCheckInTime INTEGER, targetCancelCheckInTime INTEGER)',
    columns: ['id', 'targetId', 'targetCheckIn', 'targetCheckInTime','targetCancelCheckInTime']
  };

  /**
   * memorandum table config.
   */
  static readonly MEMORANDUM_TABLE: DatabaseTable = {
    tableName: 'memorandum_table',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS memorandum_table(id INTEGER PRIMARY KEY AUTOINCREMENT, memorandumIcon TEXT, ' +
    'memorandumTitle TEXT, memorandumContent TEXT, memorandumCreateTime INTEGER, memorandumUpdateTime INTEGER)',
    columns: ['id', 'memorandumIcon', 'memorandumTitle', 'memorandumContent','memorandumCreateTime', 'memorandumUpdateTime']
  };
}