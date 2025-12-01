import { relationalStore } from '@kit.ArkData';
import { DbSUK, SUK } from '../../model/SUK';
import { Rdb } from '../Rdb';

export class SUKTable {
  private static tableName = 'suks';

  static add(suks: SUK[]) {
    Rdb.instance.insert(SUKTable.tableName, suks.map((s) => {
      return { sukData: JSON.stringify(s) } as relationalStore.ValuesBucket;
    }));
  }

  static delete(dbSUK: DbSUK) {
    let pre = new relationalStore.RdbPredicates(SUKTable.tableName).equalTo('id', dbSUK.id);
    Rdb.instance.delete(SUKTable.tableName, pre);
  }

  static deleteAll() {
    let pre = new relationalStore.RdbPredicates(SUKTable.tableName);
    Rdb.instance.delete(SUKTable.tableName, pre);
  }

  static getCount() {
    const res = Rdb.instance.querySql(SUKTable.tableName, `select count(*) from ${SUKTable.tableName}`);
    if (res && res.goToFirstRow()) {
      const count = res.getDouble(0);
      return count;
    }
    return 0;
  }

  static getLast(): DbSUK | null {
    const res =
      Rdb.instance.query(SUKTable.tableName, new relationalStore.RdbPredicates(SUKTable.tableName).limitAs(1));
    let dbSUK: DbSUK | null = null;

    if (res && res.goToFirstRow()) {
      const id = res.getDouble(res.getColumnIndex('id'));
      const suk = JSON.parse(res.getString(res.getColumnIndex('sukData'))) as SUK;
      dbSUK = { id, suk };
      res.close();
    }

    return dbSUK;
  }
}