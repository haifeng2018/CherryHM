import router from '@ohos.router';
import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PrivacyPolicyDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */

@CustomDialog
export default struct PrivacyPolicyDialog {
  controller: CustomDialogController;
  cancel: () => void;
  confirm: () => void;

  build() {
    Column() {
      Text($r('app.string.MainAbility_kind_tip'))
        .width(Constants.DIALOG_COMPONENT_WIDTH_PERCENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize($r('app.float.dialog_text_privacy_size'))
        .textAlign(TextAlign.Center)
        .fontWeight(Constants.DIALOG_TITLE_FONT_WEIGHT)
        .margin({
          top: $r('app.float.dialog_text_privacy_top'),
          bottom: $r('app.float.dialog_text_privacy_bottom')
        })
      Text($r('app.string.privacy_policy_content'))
        .fontSize($r('app.float.dialog_common_text_size'))
        .width(Constants.DIALOG_COMPONENT_WIDTH_PERCENT)
      Row(){
        Text($r('app.string.user_services_agreement'))
          .fontColor($r('app.color.color_0091FF'))
          .fontSize($r('app.float.dialog_common_text_size'))
          .onClick(() => {
            this.controller.close();
            router.pushUrl({
              url: Constants.WEB_PAGE_URL,
              params: {
                title: $r('app.string.user_services_agreement'),
                url: Constants.USER_SERVICES_AGREEMENT,
              },
            })
          })

        Text($r('app.string.and'))
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.dialog_common_text_size'))

        Text($r('app.string.privacy_policy'))
          .fontColor($r('app.color.color_0091FF'))
          .fontSize($r('app.float.dialog_common_text_size'))
          .onClick(() => {
            this.controller.close();
            router.pushUrl({
              url: Constants.WEB_PAGE_URL,
              params: {
                title: $r('app.string.privacy_policy'),
                url: Constants.PRIVACY_POLICY,
              },
            })
          })
      }.width('100%').justifyContent(FlexAlign.Center)
      Row() {
        Text($r('app.string.disagree'))
          .fancy()
          .fontColor($r("app.color.color_666666"))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })
        Blank()
          .backgroundColor($r('app.color.color_F5F5F5'))
          .width($r('app.float.dialog_blank_width'))
          .height($r('app.float.dialog_blank_height'))
        Text($r('app.string.agree'))
          .fancy()
          .fontColor($r("app.color.color_0091FF"))
          .onClick(() => {
            this.controller.close();
            this.confirm();
          })
      }
      .margin({ bottom: Constants.DIALOG_ROW_MARGIN_BOTTOM })
    }
    .width(Constants.DIALOG_WIDTH_PERCENT)
    .borderRadius(Constants.DIALOG_BORDER_RADIUS)
    .backgroundColor(Color.White)
  }
}

// Common text styles.
@Extend(Text) function fancy () {
  .fontSize($r("app.float.dialog_fancy_text_size"))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .layoutWeight(Constants.COMMON_LAYOUT_WEIGHT)
}