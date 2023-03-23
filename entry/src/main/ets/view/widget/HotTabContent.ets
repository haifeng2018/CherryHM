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
  private tabTitles = [{ id: 0, name: '周排行' }, { id: 1, name: '月排行' }, { id: 2, name: '总排行' }]

  onCancel () {

  }

  @Builder TabBuilder(index: number) {
    Column() {
      Text(this.tabTitles[index].name)
        .height(Constants.MATCH_PARENT)
        .padding('12vp')
        .fontSize(this.currentIndex === index ? '22fp' : '20fp')
        .fontWeight(this.currentIndex === index ? 700 : 500)
        .fontColor(this.currentIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))
    }.justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Stack(){
        Text($r('app.string.tab_hot'))
          .width(Constants.MATCH_PARENT)
          .height('56vp')
          .fontSize($r('app.float.fp_24'))
          .fontColor($r('app.color.color_333333'))
          .fontWeight(500)
          .textAlign(TextAlign.Center)

        Image($r('app.media.ic_share'))
          .width('30vp')
          .height('30vp')
          .align(Alignment.End)
          .margin({right:'24vp'})
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
      .barHeight('56vp')
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