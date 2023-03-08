import promptAction from '@ohos.promptAction';
import { RouterPath } from '../util/RouterPath';
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
struct LauncherPage {
  private TAG = 'LauncherPage';
  private context: common.UIAbilityContext;
  private timerId: number = 0;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyPolicyDialog(
      {
        cancel: this.onCancel.bind(this),
        confirm: this.onConfirm.bind(this),
        dismiss: this.onDismiss.bind(this)
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -66 },
    customStyle: true,
    autoCancel: false
  });

  onCancel() {
    // Exit the application.
    this.context.terminateSelf();
  }

  onConfirm() {
    // Save privacy agreement status.
    this.saveIsPrivacy()
    this.jumpToSplashPage()
  }

  onDismiss() {
    promptAction.showToast({ message: 'onDismiss 666'});
    // Exit the application.
    this.getDataPreferences().then((preferences: preferences.Preferences) => {
      preferences.get(Constants.PREFERENCES_KEY_PRIVACY, true).then((value: preferences.ValueType) => {
        Logger.info(this.TAG, 'AboutToAppear value: ' + value);
        if (!value) {
          this.context.terminateSelf();
        }
      });
    });
  }

  onPageHide() {
    clearTimeout(this.timerId)
  }

  jumpToSplashPage() {
    router.pushUrl({ url: RouterPath.SPLASH_PAGE })
  }
  /**
   * Jump to advertising page.
   */
  jumpToAdvertisingPage() {
    this.timerId = setTimeout(() => {
      router.pushUrl({
        url: RouterPath.AD_PAGE
      }).catch((error) => {
        Logger.error(RouterPath.LAUNCHER_PAGE, 'LauncherPage pushUrl error ' + JSON.stringify(error));
      });
    }, Constants.LAUNCHER_DELAY_TIME);
  }

  saveIsPrivacy() {
    let preferences: Promise<preferences.Preferences> = this.getDataPreferences();
    preferences.then((result: preferences.Preferences) => {
      let privacyPut = result.put(Constants.PREFERENCES_KEY_PRIVACY, false);
      result.flush();
      privacyPut.then(() => {
        Logger.info(this.TAG, 'Put the value of startup Successfully.');
      }).catch((err) => {
        Logger.error(this.TAG, 'Put the value of startup Failed, err: ' + err);
      });
    }).catch((err) => {
      Logger.error(this.TAG, 'Get the preferences Failed, err: ' + err);
    });
  }

  onPageShow() {
    this.context = getContext(this) as common.UIAbilityContext;
    // Get the operation class for saving data.
    this.getDataPreferences().then((preferences: preferences.Preferences) => {
      preferences.get(Constants.PREFERENCES_KEY_PRIVACY, true).then((value: preferences.ValueType) => {
        Logger.info(this.TAG, 'AboutToAppear value: ' + value);
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
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
  }

}
