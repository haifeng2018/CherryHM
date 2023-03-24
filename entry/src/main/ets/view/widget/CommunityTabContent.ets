import { FollowTabContent } from './FollowTabContent';
import { RecommendTabContent } from './RecommendTabContent';
import { TopicsTabContent } from './TopicsTabContent';
import { NewsTabContent } from './NewsTabContent';
import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommunityTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-社区
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct CommunityTabContent {
  @State currentIndex: number = 0
  private tabTitles = [{ id: 0, name: '关注' }, { id: 1, name: '专题' },
    { id: 2, name: '资讯' }, { id: 3, name: '推荐' }]

  @Builder TabBuilder(index: number) {
    Stack() {
      Text(this.tabTitles[index].name)
        .height(Constants.MATCH_PARENT)
        .padding('12vp')
        .fontSize(this.currentIndex === index ? '22fp' : '20fp')
        .fontWeight(this.currentIndex === index ? 700 : 500)
        .fontColor(this.currentIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))

      Divider()
        .strokeWidth('5vp')
        .width('20vp')
        .margin({bottom:'5vp'})
        .color($r('app.color.color_333333'))
        .opacity(this.currentIndex === index ? 1 : 0)

    }.alignContent(Alignment.Bottom)
  }

  build() {
    Column() {
      Tabs() {
        TabContent() {
          FollowTabContent()
        }.tabBar(this.TabBuilder(0))

        TabContent() {
          TopicsTabContent()
        }.tabBar(this.TabBuilder(1))

        TabContent() {
          NewsTabContent()
        }.tabBar(this.TabBuilder(2))

        TabContent() {
          RecommendTabContent()
        }.tabBar(this.TabBuilder(3))
      }
      .vertical(false)
      .barWidth(Constants.MATCH_PARENT)
      .barHeight('56vp')
      .barMode(BarMode.Fixed)
      .margin({top:$r('app.float.status_bar_height')})
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.white'))
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
  }
}