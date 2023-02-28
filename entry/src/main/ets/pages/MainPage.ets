import { TvTabContent } from '../view/widget/TvTabContent';
import { TabId } from '../model/HomeTabModel';
import { MeTabContent } from '../view/widget/MeTabContent';
import { WeChatTabContent } from '../view/widget/WeChatTabContent';
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
      Image(this.currentIndex == index ? NavList[index].icon_selected : NavList[index].icon)
        .width('30vp')
        .height('30vp')
        .objectFit(ImageFit.Contain)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .scale({x:this.currentIndex === index ? 1.1 : 1.0,
          y:this.currentIndex === index ? 1.1 : 1.0})
      Text(NavList[index].text)
        .margin({top:'4vp'})
        .fontSize(this.currentIndex == index ? '16fp' : '15fp')
        .fontColor(this.currentIndex == index ? $r('app.color.color_primary') : $r('app.color.color_999999'))
    }.justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          HomeTabContent()
        }.tabBar(this.TabBuilder(TabId.HOME))

        TabContent() {
          WeChatTabContent()
        }.tabBar(this.TabBuilder(TabId.WeChat))

        TabContent() {
          TvTabContent()
        }.tabBar(this.TabBuilder(TabId.TV))

        TabContent() {
          MeTabContent()
        }.tabBar(this.TabBuilder(TabId.ME))
      }
      .vertical(false)
      .barWidth('100%')
      .barHeight('80vp')
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .backgroundColor($r('app.color.white'))
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}