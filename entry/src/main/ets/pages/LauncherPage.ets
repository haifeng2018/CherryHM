import router from '@ohos.router';
import PrivacyPolicyDialog from '../dialog/PrivacyPolicyDialog';
import Constants from '../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LauncherPage
 * Author: Victor
 * Date: 2023/2/24 15:28
 * Description: 
 * -----------------------------------------------------------------
 */

@Entry
@Component
struct Index {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyPolicyDialog(
      {
        cancel: this.onCancel.bind(this),
        confirm: this.onConfirm.bind(this)
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: Constants.DIALOG_CONTROLLER_DY_OFFSET },
    customStyle: true,
    autoCancel: false
  });

  onCancel() {
    // Exit the application.
//    this.context.terminateSelf();
    router.clear()
  }

  onConfirm() {
    // Save privacy agreement status.
    //    this.saveIsPrivacy();
    //    this.jumpToAdvertisingPage();
    router.pushUrl({
      url: 'pages/SplashPage',
      params: {
        data1: 'message',
        data2: {
          data3: [123, 456, 789]
        },
      },
    });
  }

  aboutToAppear() {
    this.dialogController.open()
  }

  build() {
    Stack() {
      Image($r('app.media.img_splash'))
        .width(Constants.FULL_WIDTH)
        .height(Constants.FULL_HEIGHT)
    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
  }
}
