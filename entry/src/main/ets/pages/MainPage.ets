import { TabId } from '../model/HomeTabModel';
import { MeTabContent } from '../view/widget/MeTabContent';
import { WorkBenchTabContent } from '../view/widget/WorkBenchTabContent';
import { ScheduleTabContent } from '../view/widget/ScheduleTabContent';
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
        .width('28vp')
        .height('28vp')
        .objectFit(ImageFit.Contain)
        .opacity(this.currentIndex === index ? 1 : 0.4)
      Text(NavList[index].text)
        .fontSize('12vp')
        .fontColor(this.currentIndex == index ? $r('app.color.color_0091FF') : $r('app.color.color_999999'))
    }.justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          HomeTabContent()
        }.tabBar(this.TabBuilder(TabId.HOME))

        TabContent() {
          ScheduleTabContent()
        }.tabBar(this.TabBuilder(TabId.SCHEDULE))

        TabContent() {
          WorkBenchTabContent()
        }.tabBar(this.TabBuilder(TabId.WORKBENCH))

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