import { SUKTable } from '../rdb/tables/SukTable';

@Component
export default struct CardTransferSuccess {
  @Consume('mainStack') pageStack: NavPathStack;
  sukCount: number = SUKTable.getCount();

  build() {
    NavDestination() {
      Column() {
        Column() {
          SymbolGlyph($r('sys.symbol.checkmark_circle_fill'))
            .fontColor([Color.Green])
            .fontSize(24)
            .margin({ bottom: 8 });
          Text(`Card Transfer Success, Remaining: ${this.sukCount}`);
        }
        .size({ width: '70%', height: '70%' })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center);
      }
      .size({ width: '100%', height: '100%' })
      .backgroundColor(Color.Black)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center);
    }
    .hideTitleBar(true);
  }
}