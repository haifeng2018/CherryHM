import Constants from '../util/Constants';
import { HotTabContent } from '../view/widget/HotTabContent';
import { CommunityTabContent } from '../view/widget/CommunityTabContent';
import { TabId } from '../model/HomeTabModel';
import { MeTabContent } from '../view/widget/MeTabContent';
import { HomeTabContent } from '../view/widget/HomeTabContent';
import { NavList } from '../model/HomeTabModel';
@Entry
@Component
struct MainPage {
  @State fontColor: string = 'rgba(0, 0, 0, 0.4)'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder TabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? NavList[index].icon_selected : NavList[index].icon)
        .width('30vp')
        .height('30vp')
        .objectFit(ImageFit.Contain)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .scale({x:this.currentIndex === index ? 1.1 : 1.0,
          y:this.currentIndex === index ? 1.1 : 1.0})
      Text(NavList[index].text)
        .margin({top:'4vp'})
        .fontSize(this.currentIndex === index ? '16fp' : '15fp')
        .fontColor(this.currentIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))
    }.justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          HomeTabContent()
        }.tabBar(this.TabBuilder(TabId.HOME))

        TabContent() {
          CommunityTabContent()
        }.tabBar(this.TabBuilder(TabId.COMMUNITY))

        TabContent() {
          HotTabContent()
        }.tabBar(this.TabBuilder(TabId.HOT))

        TabContent() {
          MeTabContent()
        }.tabBar(this.TabBuilder(TabId.ME))
      }
      .vertical(false)
      .barWidth(Constants.MATCH_PARENT)
      .barHeight('80vp')
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.white'))
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
  }
}