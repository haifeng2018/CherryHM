import { ShareType } from '../../bean/ShareType';
import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShareDialog
 * Author: Victor
 * Date: 2023/3/8 19:08
 * Description: 
 * -----------------------------------------------------------------
 */
@Preview
@CustomDialog
export default struct ShareDialog {
  @State title: string = '我命由我不由天'
  @Link shareType: number
  controller: CustomDialogController;
  cancel: () => void;

  build() {
    Column() {
      Text($r('app.string.share'))
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_50'))
        .fontColor($r('app.color.color_333333'))
        .fontSize($r('app.float.fp_22'))
        .textAlign(TextAlign.Center)

      Text(this.title)
        .width(Constants.MATCH_PARENT)
        .fontSize($r('app.float.fp_18'))
        .textAlign(TextAlign.Center)

      Divider().color($r('app.color.color_666666'))
        .opacity(0.6)
        .margin({top:$r('app.float.vp_10')})

      Row(){
        Image($r('app.media.ic_action_share_wechat_grey'))
          .shareStyle()
          .onClick(() => this.shareAction(ShareType.WECHAT))

        Image($r('app.media.ic_action_share_moment_grey'))
          .shareStyle()
          .onClick(() => this.shareAction(ShareType.MOMENT))

        Image($r('app.media.ic_action_share_qq_grey'))
          .shareStyle()
          .onClick(() => this.shareAction(ShareType.QQ))

        Image($r('app.media.ic_action_share_qqzone_grey'))
          .shareStyle()
          .onClick(() => this.shareAction(ShareType.QQ_ZONE))

        Image($r('app.media.ic_action_share_weibo_grey'))
          .shareStyle()
          .onClick(() => this.shareAction(ShareType.WEIBO))

      }
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_70'))
      .justifyContent(FlexAlign.Center)
      .padding({left:$r('app.float.vp_24'),right:$r('app.float.vp_24')})

      Divider().color($r('app.color.color_666666')).opacity(0.6)

      Text($r('app.string.cancel'))
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_50'))
        .fontColor($r('app.color.color_666666'))
        .fontSize($r('app.float.fp_22'))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.controller.close()
        })

      Divider().color($r('app.color.color_666666')).opacity(0.6)
    }
    .width(Constants.MATCH_PARENT)
    .borderRadius({ topLeft:$r('app.float.vp_10'),topRight:$r('app.float.vp_10') })
    .backgroundColor(Color.White)
  }

  shareAction(action:number) {
    this.shareType = action
    this.controller.close();
  }
}

// Common text styles.
@Extend(Image) function shareStyle () {
    .height($r('app.float.vp_60'))
    .layoutWeight(1)
    .objectFit(ImageFit.Contain)
    .padding($r('app.float.vp_5'))
}