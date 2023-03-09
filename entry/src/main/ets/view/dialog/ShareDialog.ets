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
        .height('50vp')
        .fontColor($r('app.color.color_333333'))
        .fontSize('22fp')
        .textAlign(TextAlign.Center)

      Text(this.title)
        .width(Constants.MATCH_PARENT)
        .fontSize('18fp')
        .textAlign(TextAlign.Center)

      Divider().color($r('app.color.color_666666')).opacity(0.6).margin({top:'10vp'})

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
      .height('70vp')
      .justifyContent(FlexAlign.Center)
      .padding({left:'24vp',right:'24vp'})

      Divider().color($r('app.color.color_666666')).opacity(0.6)

      Text($r('app.string.cancel'))
        .width(Constants.MATCH_PARENT)
        .height('50vp')
        .fontColor($r('app.color.color_666666'))
        .fontSize('22fp')
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.controller.close()
        })

      Divider().color($r('app.color.color_666666')).opacity(0.6)
    }
    .width(Constants.MATCH_PARENT)
    .borderRadius({ topLeft:'10vp',topRight:'10vp' })
    .backgroundColor(Color.White)
  }

  shareAction(action:number) {
    this.shareType = action
    this.controller.close();
  }
}

// Common text styles.
@Extend(Image) function shareStyle () {
    .height('60vp')
    .layoutWeight(1)
    .objectFit(ImageFit.Contain)
    .padding('5vp')
}