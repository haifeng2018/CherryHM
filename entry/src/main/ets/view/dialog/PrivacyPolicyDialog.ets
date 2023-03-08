import { RouterPath } from '../../util/RouterPath';
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
  dismiss: () => void;

  build() {
    Column() {
      Text($r('app.string.MainAbility_kind_tip'))
        .width(Constants.MATCH_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize($r('app.float.dialog_text_privacy_size'))
        .textAlign(TextAlign.Center)
        .fontWeight(1)
        .margin({
          top: $r('app.float.dialog_text_privacy_top'),
          bottom: $r('app.float.dialog_text_privacy_bottom')
        })

      Text($r('app.string.privacy_policy_content'))
        .fontSize($r('app.float.dialog_common_text_size'))
        .lineHeight('28vp')
        .width(Constants.MATCH_PARENT)
      .padding({left:'24vp',right:'24vp'})

      Row(){
        Text($r('app.string.user_services_agreement'))
          .fontColor($r('app.color.color_0091FF'))
          .fontSize($r('app.float.dialog_common_text_size'))
          .onClick(() => {
            this.controller.close();
            router.pushUrl({
              url: RouterPath.WEB_PAGE,
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
              url: RouterPath.WEB_PAGE,
              params: {
                title: $r('app.string.privacy_policy'),
                url: Constants.PRIVACY_POLICY,
              },
            })
          })
      }.width(Constants.MATCH_PARENT)
      .margin({top:'10vp'})
      .justifyContent(FlexAlign.Center)

      Divider()
        .vertical(false)
        .width(Constants.MATCH_PARENT)
        .color($r('app.color.color_666666'))
        .opacity(0.6)
        .margin({top:'10vp'})

      Row() {
        Text($r('app.string.disagree'))
          .fancy()
          .fontColor($r("app.color.color_666666"))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })
        Divider().vertical(true).height(Constants.MATCH_PARENT).opacity(0.6).color($r('app.color.color_666666'))
        Text($r('app.string.agree'))
          .fancy()
          .fontColor($r("app.color.color_0091FF"))
          .onClick(() => {
            this.controller.close();
            this.confirm();
          })
      }
      .width(Constants.MATCH_PARENT)
      .height('45vp')
    }
    .width('92%')
    .borderRadius('10vp')
    .backgroundColor(Color.White)
  }
}

// Common text styles.
@Extend(Text) function fancy () {
  .height(Constants.MATCH_PARENT)
  .layoutWeight(1)
  .fontSize($r("app.float.dialog_fancy_text_size"))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
}