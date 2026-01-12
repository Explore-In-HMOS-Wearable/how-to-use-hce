import { relationalStore } from '@kit.ArkData';

export class Rdb {
  private static _instance: Rdb;

  private constructor() {
  }

  public static get instance(): Rdb {
    if (!this._instance) {
      this._instance = new Rdb();
    }

    return this._instance;
  }

  private _database: relationalStore.RdbStore | null = null;

  async init(context: Context) {
    if (this._database) {
      return;
    }

    try {
      const DB_CONFIG: relationalStore.StoreConfig = {
        name: 'main.db',
        securityLevel: relationalStore.SecurityLevel.S4,
        encrypt: true
      };

      this._database = await relationalStore.getRdbStore(context, DB_CONFIG);
      console.info('RDB created');
      // create initial tables and set initial data
      if (this._database.version === 0) {
        await this._database.executeSql('create table if not EXISTS cards(id integer PRIMARY KEY, cardData string);');
        await this._database.executeSql('create table if not EXISTS suks(id integer PRIMARY KEY AUTOINCREMENT, sukData string);');
        this._database.version = 1;
        console.info('RDB initialized');
      } else {
        console.info('RDB already initialized');
      }
    } catch (e) {
      console.error(`RDB init error, e: ${e.code} ${e}`);
    }
  }

  private _checkDatabase() {
    if (this._database === null) {
      console.error('Database is not initialized. Use \'init()\' to initialize the database.');
      return false;
    }
    return true;
  }

  /**
   * insert data
   */
  insert(table: string, data: relationalStore.ValuesBucket | relationalStore.ValuesBucket[]) {
    if (!this._checkDatabase()) {
      return;
    }

    try {
      if (data instanceof Array) {
        this._database!.batchInsertSync(table, data);
      } else {
        this._database!.insertSync(table, data);
      }
    } catch (e) {
      console.error(`${table} insert error, e: ${e.code} ${e}`);
    }
  }

  /**
   * query data
   */
  query(table: string, predicates: relationalStore.RdbPredicates,
    columns?: string[]): relationalStore.ResultSet | undefined {
    if (!this._checkDatabase()) {
      return undefined;
    }

    try {
      const results = this._database!.querySync(predicates, columns);
      return results;
    } catch (e) {
      console.error(`${table} query error, e: ${e.code} ${e}`);
      return undefined;
    }
  }

  /**
   * query data with sql
   */
  querySql(table: string, sql: string): relationalStore.ResultSet | undefined {
    if (!this._checkDatabase()) {
      return undefined;
    }

    try {
      const results = this._database!.querySqlSync(sql);
      return results;
    } catch (e) {
      console.error(`${table} querySql error, e: ${e.code} ${e}`);
      return undefined;
    }
  }

  /**
   * update data
   */
  update(table: string, predicates: relationalStore.RdbPredicates, values: relationalStore.ValuesBucket) {
    if (!this._checkDatabase()) {
      return;
    }

    try {
      this._database!.updateSync(values, predicates);
    } catch (e) {
      console.error(`${table} update error, e: ${e.code} ${e}`);
    }
  }

  /**
   * this will delete data
   */
  delete(table: string, predicates: relationalStore.RdbPredicates) {
    if (!this._checkDatabase()) {
      return;
    }

    try {
      this._database!.deleteSync(predicates);
    } catch (e) {
      console.error(`${table} delete error, e: ${e.code} ${e}`);
    }
  }
}