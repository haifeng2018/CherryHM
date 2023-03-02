import { TotalRankingTabContent } from './TotalRankingTabContent';
import { MonthlyRankingTabContent } from './MonthlyRankingTabContent';
import { WeeklyRankingTabContent } from './WeeklyRankingTabContent';
import { DailyPaperTabContent } from './DailyPaperTabContent';
import { FollowTabContent } from './FollowTabContent';
import router from '@ohos.router';
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
  @State currentIndex: number = 0

  private tabTitles = [{ id: 0, name: '周排行' }, { id: 1, name: '月排行' }, { id: 2, name: '总排行' }]

  @Builder TabBuilder(index: number) {
    Column() {
      Text(this.tabTitles[index].name)
        .height(Constants.FULL_HEIGHT)
        .padding('12vp')
        .fontSize(this.currentIndex === index ? '22fp' : '20fp')
        .fontWeight(this.currentIndex === index ? 700 : 500)
        .fontColor(this.currentIndex == index ? $r('app.color.color_333333') : $r('app.color.color_999999'))
    }.justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Stack(){
        Text($r('app.string.tab_hot'))
          .width(Constants.FULL_WIDTH)
          .height('56vp')
          .fontSize($r('app.float.fp_28'))
          .fontColor($r('app.color.color_333333'))
          .fontWeight(500)
          .textAlign(TextAlign.Center)
        Image($r('app.media.ic_share'))
          .width('30vp')
          .height('30vp')
          .align(Alignment.End)
          .margin({right:'24vp'})
      }
      .width(Constants.FULL_WIDTH)
      .backgroundColor($r('app.color.white'))
      .alignContent(Alignment.End)
      .padding({top:'36vp'})

      Tabs() {
        TabContent() {
          WeeklyRankingTabContent()
        }.tabBar(this.TabBuilder(0))

        TabContent() {
          MonthlyRankingTabContent()
        }.tabBar(this.TabBuilder(1))

        TabContent() {
          TotalRankingTabContent()
        }.tabBar(this.TabBuilder(2))
      }
      .vertical(false)
      .barWidth('100%')
      .barHeight('56vp')
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .backgroundColor($r('app.color.white'))
    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
    .backgroundColor($r('app.color.white'))
  }

}