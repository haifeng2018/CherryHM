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
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder TabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? NavList[index].icon_selected : NavList[index].icon)
        .width($r('app.float.vp_20'))
        .height($r('app.float.vp_20'))
        .objectFit(ImageFit.Contain)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .scale({x:this.currentIndex === index ? 1.1 : 1.0,
          y:this.currentIndex === index ? 1.1 : 1.0})
      Text(NavList[index].text)
        .margin({top:$r('app.float.vp_4')})
        .fontSize(this.currentIndex === index ? $r('app.float.fp_14') : $r('app.float.fp_12'))
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
      .barHeight($r('app.float.vp_80'))
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