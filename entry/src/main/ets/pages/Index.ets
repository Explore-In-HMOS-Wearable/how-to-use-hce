import CardTransferSuccess from '../components/CardTransferSuccess';
import NoSuk from '../components/NoSuk';
import { SUKTable } from '../rdb/tables/SukTable';
import HceHandler from '../util/HceHandler';
import CardVM from '../viewmodel/CardVM';

@Entry
@Component
struct Index {
  @Provide('mainStack') pageStack: NavPathStack = new NavPathStack();
  @State cardVM: CardVM = CardVM.getInstance();

  onPageShow(): void {
    HceHandler.enable(this.getUIContext().getHostContext()!, 'foreground', this.pageStack);
  }

  build() {
    Navigation(this.pageStack) {
      Stack() {
        Column() {
          Blank().layoutWeight(1);

          Column() {
            Text('Contactless Payment')
              .fontSize(12);

            Text(this.cardVM.card?.name ?? 'Card Not Found')
              .fontSize(10);
          }
          .alignItems(HorizontalAlign.Start)
          .padding(6)
          .backgroundColor(Color.Gray)
          .width('100%')
          .borderRadius(8);

          Blank().layoutWeight(1);

          Row() {
            Button('Add Card')
              .layoutWeight(1)
              .height(30)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Green)
              .onClick(() => {
                CardVM.getInstance().add({ name: 'My Lucky Card' });
                SUKTable.add([{}, {}, {}, {}, {}]);
              });
            Button('Remove')
              .layoutWeight(1)
              .height(30)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Red)
              .onClick(() => {
                CardVM.getInstance().delete();
                SUKTable.deleteAll();
              });
          };
        }
        .height('70%')
        .width('70%');
      }
      .backgroundColor(Color.Black)
      .height('100%')
      .width('100%');
    }
    .navDestination(this.pageMap)
    .hideToolBar(true);
  }

  @Builder
  pageMap(name: string) {
    if (name === 'CardTransferSuccess') {
      CardTransferSuccess();
    } else if (name === 'NoSuk') {
      NoSuk();
    }
  }
}