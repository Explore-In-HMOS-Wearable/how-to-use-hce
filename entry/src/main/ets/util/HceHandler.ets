import { cardEmulation } from '@kit.ConnectivityKit';
import { bundleManager } from '@kit.AbilityKit';
import { Rdb } from '../rdb/Rdb';
import { CardTable } from '../rdb/tables/CardTable';
import { SUKTable } from '../rdb/tables/SukTable';

type rt = 'foreground' | 'background';

export default class HceHandler {
  private constructor() {
  }

  private static hceService: cardEmulation.HceService | undefined | null = undefined;
  private static runType: rt = 'background';

  static runInBackground() {
    HceHandler.runType = 'background';
  }

  static enable(context: Context, _runType: rt, pageStack?: NavPathStack) {
    console.info('start enable');
    HceHandler.runType = _runType;
    // first check availability
    if (canIUse('SystemCapability.Communication.NFC.Core') && cardEmulation.hasHceCapability()) {
      try {
        const hceElementName: bundleManager.ElementName = {
          bundleName: 'com.hmosdemos.hcepayment', // TODO: this must match with the app's bundle
          abilityName: 'EntryAbility',
          moduleName: 'entry'
        };

        // TODO: this must match with module.json5
        const paymentAid = [
          '325041592E5359532E4444463031',
          'A0000000031010',
          'A0000000041010'
        ];

        HceHandler.hceService?.stop(hceElementName);
        HceHandler.hceService = new cardEmulation.HceService();
        HceHandler.hceService.start(hceElementName, paymentAid);

        HceHandler.hceService.on('hceCmd', async (err, data) => {
          console.info(`hceCmd ${data}`);
          if (err) {
            console.error(`HceHandler callback Error: ${err}`);
            return;
          }

          // get card data from db
          await Rdb.instance.init(context);
          const card = CardTable.get();
          const suk = SUKTable.getLast();

          if (card && suk) {
            // TODO: make payment
            // Basically payment is just a communication with the POS machine.
            // You just need to know what to send.
            // GOOD LUCK :)

            // send a dummy response
            const response = [0x47, 0x4F, 0x4F, 0x44, 0x20, 0x4C, 0x55, 0x43, 0x4B, 0x20, 0x3A, 0x29, 0x90, 0x00];
            await HceHandler.hceService!.transmit(response);

            // simulate success
            // delete last suk
            SUKTable.delete(suk);
            console.info(`payment success remaining suk: ${SUKTable.getCount()}`);

            // route to success page
            if (HceHandler.runType === 'foreground' && pageStack) {
              const lastPage = pageStack.getAllPathName().pop();
              if (lastPage === 'CardTransferSuccess' || lastPage === 'NoSuk') {
                pageStack.replacePath({ name: 'CardTransferSuccess' });
              } else {
                pageStack.pushPath({ name: 'CardTransferSuccess' });
              }
            }

          } else if (card && SUKTable.getCount() === 0) {
            // route to no suk page
            if (HceHandler.runType === 'foreground' && pageStack) {
              const lastPage = pageStack.getAllPathName().pop();
              if (lastPage === 'CardTransferSuccess') {
                pageStack.replacePath({ name: 'NoSuk' });
              } else if (lastPage !== 'NoSuk') {
                pageStack.pushPath({ name: 'NoSuk' });
              }
            }
          }
        });
      } catch (error) {
        console.error(`HceHandler errCode: ${error.code} errMessage: ${error.message}`);
      }
    }
  }
};