import { homePageTabTitles } from '../../model/HomeTabModel';
import { HomeRecommendTabContent } from './HomeRecommendTabContent';
import { DailyPaperTabContent } from './DailyPaperTabContent';
import { HomeFollowTabContent } from './HomeFollowTabContent';
import router from '@ohos.router';
import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct HomeTabContent {
  @State currentIndex: number = 0

  @Builder TabBuilder(index: number) {
    Stack() {
      Text(homePageTabTitles[index].name)
        .height(Constants.MATCH_PARENT)
        .padding({left:$r('app.float.vp_20'),right:$r('app.float.vp_20')})
        .fontSize(this.currentIndex === index ? $r('app.float.fp_22') : $r('app.float.fp_20'))
        .fontWeight(this.currentIndex === index ? 700 : 500)
        .fontColor(this.currentIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))

      Divider()
        .strokeWidth('5vp')
        .width($r('app.float.vp_20'))
        .margin({bottom:$r('app.float.vp_5')})
        .color($r('app.color.color_333333'))
        .opacity(this.currentIndex === index ? 1 : 0)

    }.alignContent(Alignment.Bottom)
  }

  build() {
    RelativeContainer() {
      Tabs() {
        TabContent() {
          HomeRecommendTabContent()
        }.tabBar(this.TabBuilder(0))

        TabContent() {
          HomeFollowTabContent()
        }.tabBar(this.TabBuilder(1))

        TabContent() {
          DailyPaperTabContent()
        }.tabBar(this.TabBuilder(2))
      }
      .vertical(false)
      .barWidth(Constants.MATCH_PARENT)
      .barHeight($r('app.float.vp_56'))
      .barMode(BarMode.Scrollable)
      .margin({top:$r('app.float.status_bar_height')})
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.white'))
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        left: {anchor: "__container__", align: HorizontalAlign.Start}
      }).id('mHomeTab')

      Image($r('app.media.ic_home_search'))
        .width($r('app.float.vp_50'))
        .height($r('app.float.vp_50'))
        .margin({top:$r('app.float.vp_5'),right:$r('app.float.vp_24')})
        .padding($r('app.float.vp_10'))
        .alignRules({
          top: {anchor: "mHomeTab", align: VerticalAlign.Top},
          right: {anchor: "mHomeTab", align: HorizontalAlign.End}
        })
        .id("mIvSearch")
        .onClick(() => {
          router.pushUrl({ url: 'pages/SearchPage' })
        })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
  }
}