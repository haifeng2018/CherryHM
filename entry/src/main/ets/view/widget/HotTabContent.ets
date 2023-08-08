import { hotPageTabTitles } from '../../model/HotTabModel';
import ShareDialog from '../dialog/ShareDialog';
import { HotApi } from '../../api/HotApi';
import { RankingTabContent } from './RankingTabContent';
import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HotTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-热门
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct HotTabContent {
  shareDlgCtr: CustomDialogController = new CustomDialogController({
    builder: ShareDialog(
      {
        cancel: this.onCancel.bind(this),
        shareType: $shareType,
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  @State shareType: number = 0
  @State currentIndex: number = 0

  onCancel () {

  }

  @Builder TabBuilder(index: number) {
    Stack() {
      Text(hotPageTabTitles[index].name)
        .height(Constants.MATCH_PARENT)
        .padding($r('app.float.vp_12'))
        .fontSize(this.currentIndex === index ? $r('app.float.fp_18') : $r('app.float.fp_16'))
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))

      Divider()
        .strokeWidth('3vp')
        .width($r('app.float.vp_20'))
        .margin({bottom:$r('app.float.vp_10')})
        .color($r('app.color.color_333333'))
        .opacity(this.currentIndex === index ? 1 : 0)

    }.alignContent(Alignment.Bottom)
  }

  build() {
    Column() {
      Stack(){
        Text($r('app.string.tab_hot'))
          .width(Constants.MATCH_PARENT)
          .height($r('app.float.vp_56'))
          .fontSize($r('app.float.fp_20'))
          .fontColor($r('app.color.color_333333'))
          .fontWeight(500)
          .textAlign(TextAlign.Center)

        Image($r('app.media.ic_share'))
          .width($r('app.float.vp_30'))
          .height($r('app.float.vp_30'))
          .align(Alignment.End)
          .margin({right:$r('app.float.vp_24')})
          .onClick(() => {
            this.shareDlgCtr.open()
          })
      }
      .width(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.white'))
      .alignContent(Alignment.End)
      .padding({top:$r('app.float.status_bar_height')})

      Tabs() {
        TabContent() {
          RankingTabContent({url: HotApi.WEEKLY_RANKING})
        }.tabBar(this.TabBuilder(0))

        TabContent() {
          RankingTabContent({url: HotApi.MONTHLY_RANKING})
        }.tabBar(this.TabBuilder(1))

        TabContent() {
          RankingTabContent({url: HotApi.TOTAL_RANKING})
        }.tabBar(this.TabBuilder(2))
      }
      .vertical(false)
      .barWidth(Constants.MATCH_PARENT)
      .barHeight($r('app.float.vp_56'))
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width(Constants.MATCH_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
  }

}