import { DailyPaperTabContent } from './DailyPaperTabContent';
import { FollowTabContent } from './FollowTabContent';
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
  private controller: TabsController = new TabsController()
  @State currentIndex: number = 0

  private tabTitles = [{ id: 0, name: '关注' }, { id: 1, name: '日报' }]
  private contentColors = [Color.Pink,Color.Brown,Color.Yellow]

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
    RelativeContainer() {
      Tabs() {
        TabContent() {
          FollowTabContent()
        }.tabBar(this.TabBuilder(0))

        TabContent() {
          DailyPaperTabContent()
        }.tabBar(this.TabBuilder(1))
      }
      .vertical(false)
      .barWidth('100%')
      .barHeight('56vp')
      .barMode(BarMode.Scrollable)
      .margin({top:'36vp'})
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .backgroundColor($r('app.color.white'))
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        left: {anchor: "__container__", align: HorizontalAlign.Start}
      }).id('mHomeTab')

      Image($r('app.media.ic_home_search'))
        .width('30vp')
        .height('30vp')
        .margin({top:'40vp',right:'24vp'})
        .padding('10vp')
        .alignRules({
          top: {anchor: "mHomeTab", align: VerticalAlign.Top},
          right: {anchor: "mHomeTab", align: HorizontalAlign.End}
        })
        .id("mIvSearch")
        .onClick(() => {
          router.pushUrl({ url: 'pages/SearchPage' })
        })
    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
    .backgroundColor($r('app.color.white'))
  }

}