import { relationalStore } from "@kit.ArkData";
import { Card } from "../../model/Card";
import { Rdb } from "../Rdb";

/**
 * This table is designed to hold only one card
 * */
export class CardTable {
  private static tableName = 'cards';

  static add(card: Card) {
    Rdb.instance.insert(CardTable.tableName, { id: 1, cardData: JSON.stringify(card) });
  }

  static delete() {
    let pre = new relationalStore.RdbPredicates(CardTable.tableName).equalTo('id', 1);
    Rdb.instance.delete(CardTable.tableName, pre);
  }

  static get(): Card | null {
    let pre = new relationalStore.RdbPredicates(CardTable.tableName).equalTo('id', 1)
    const res = Rdb.instance.query(CardTable.tableName, pre)

    if (!res) {
      throw new Error('An error occurred during db call.')
    }

    let card: Card | null = null
    if (res.rowCount === 1) {
      res.goToFirstRow();
      card = JSON.parse(res.getString(res.getColumnIndex('cardData'))) as Card
    }
    res.close()
    return card
  }
}