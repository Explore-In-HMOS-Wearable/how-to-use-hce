@Component
export default struct NoSuk {
  @Consume('mainStack') pageStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Column() {
          SymbolGlyph($r('sys.symbol.xmark_circle_fill'))
            .fontColor([Color.Red])
            .fontSize(24)
            .margin({ bottom: 8 });
          Text('No suk left.');
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