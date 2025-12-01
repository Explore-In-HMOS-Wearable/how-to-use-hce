import { Card } from '../model/Card';
import { CardTable } from '../rdb/tables/CardTable';

@Observed
export default class CardVM {
  private static instance: CardVM;

  private constructor() {
  }

  public static getInstance(): CardVM {
    if (!CardVM.instance) {
      CardVM.instance = new CardVM();
    }
    return CardVM.instance;
  }

  card: Card | null = CardTable.get();

  add(card: Card) {
    this.delete()
    CardTable.add(card);
    this.card = card;
  }

  delete() {
    CardTable.delete()
    this.card = null;
  }
}