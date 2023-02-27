import Logger from '../util/Logger';
import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import PrivacyPolicyDialog from '../view/dialog/PrivacyPolicyDialog';
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
  private context: common.UIAbilityContext;
  private timerId: number = 0;
  private jumpToAdvertisingFlag: boolean = false;

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
    this.context.terminateSelf();
  }

  onConfirm() {
    // Save privacy agreement status.
    this.saveIsPrivacy();
    this.jumpToSplashPage()
  }

  onPageHide() {
    if (this.jumpToAdvertisingFlag) {
      router.clear();
    }
    clearTimeout(this.timerId);
  }

  jumpToSplashPage() {
    router.pushUrl({ url: 'pages/SplashPage' })
  }
  /**
   * Jump to advertising page.
   */
  jumpToAdvertisingPage() {
    this.timerId = setTimeout(() => {
      this.jumpToAdvertisingFlag = true;
      router.pushUrl({
        url: Constants.ADVERTISING_PAGE_URL
      }).catch((error) => {
        Logger.error(Constants.LAUNCHER_PAGE_TAG, 'LauncherPage pushUrl error ' + JSON.stringify(error));
      });
    }, Constants.LAUNCHER_DELAY_TIME);
  }

  saveIsPrivacy() {
    let preferences: Promise<preferences.Preferences> = this.getDataPreferences();
    preferences.then((result: preferences.Preferences) => {
      let privacyPut = result.put(Constants.PREFERENCES_KEY_PRIVACY, false);
      result.flush();
      privacyPut.then(() => {
        Logger.info(Constants.LAUNCHER_PAGE_TAG, 'Put the value of startup Successfully.');
      }).catch((err) => {
        Logger.error(Constants.LAUNCHER_PAGE_TAG, 'Put the value of startup Failed, err: ' + err);
      });
    }).catch((err) => {
      Logger.error(Constants.LAUNCHER_PAGE_TAG, 'Get the preferences Failed, err: ' + err);
    });
  }

  onPageShow() {
    this.context = getContext(this) as common.UIAbilityContext;
    // Get the operation class for saving data.
    this.getDataPreferences().then((preferences: preferences.Preferences) => {
      preferences.get(Constants.PREFERENCES_KEY_PRIVACY, true).then((value: preferences.ValueType) => {
        Logger.info(Constants.LAUNCHER_PAGE_TAG, 'AboutToAppear value: ' + value);
        if (value) {
          this.dialogController.open();
        } else {
          this.jumpToAdvertisingPage();
        }
      });
    });
  }

  /**
   * Get data preferences action.
   */
  getDataPreferences() {
    return preferences.getPreferences(this.context, Constants.PREFERENCES_FILE_NAME);
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
