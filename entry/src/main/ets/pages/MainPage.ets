@Entry
@Component
struct MainPage {
  @State fontColor: string = 'rgba(0, 0, 0, 0.4)'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder homeTabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.ic_home_checked') : $r('app.media.ic_home_normal'))
        .width(28)
        .height(28)
        .margin(6)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .objectFit(ImageFit.Contain)
      Text('首页')
        .fontColor(this.currentIndex === index ? $r('app.color.color_0091FF') : $r('app.color.color_999999'))
        .fontSize(12)
    }.width('100%')
  }

  @Builder scheduleTabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.ic_schedule_checked') : $r('app.media.ic_schedule_normal'))
        .width(28)
        .height(28)
        .margin(6)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .objectFit(ImageFit.Contain)
      Text('排期表')
        .fontColor(this.currentIndex === index ? $r('app.color.color_0091FF') : $r('app.color.color_999999'))
        .fontSize(12)
    }.width('100%')
  }

  @Builder workbenchTabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.ic_work_bench_checked') : $r('app.media.ic_work_bench_normal'))
        .width(28)
        .height(28)
        .margin(6)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .objectFit(ImageFit.Contain)
      Text('工作台')
        .fontColor(this.currentIndex === index ? $r('app.color.color_0091FF') : $r('app.color.color_999999'))
        .fontSize(12)
    }.width('100%')
  }

  @Builder meTabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.ic_me_checked') : $r('app.media.ic_me_normal'))
        .width(28)
        .height(28)
        .margin(6)
        .opacity(this.currentIndex === index ? 1 : 0.4)
        .objectFit(ImageFit.Contain)
      Text('我的')
        .fontColor(this.currentIndex === index ? $r('app.color.color_0091FF') : $r('app.color.color_999999'))
        .fontSize(12)
    }.width('100%')
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          Column() {
            Text('首页').fontSize('32fp').width('100%').height('100%').textAlign(TextAlign.Center)
          }.width('100%').height('100%').justifyContent(FlexAlign.Center)
        }.tabBar(this.homeTabBuilder(0))

        TabContent() {
          Column() {
            Text('排期表').fontSize('32fp').width('100%').height('100%').textAlign(TextAlign.Center)
          }.width('100%').height('100%').justifyContent(FlexAlign.Center)
        }.tabBar(this.scheduleTabBuilder(1))

        TabContent() {
          Column() {
            Text('工作台').fontSize('32fp').width('100%').height('100%').textAlign(TextAlign.Center)
          }.width('100%').height('100%').justifyContent(FlexAlign.Center)
        }.tabBar(this.workbenchTabBuilder(2))

        TabContent() {
          Stack() {
            Image($r('app.media.img_me_header')).width('100%').height('40%').align(Alignment.Top)

            Column() {
              Text('我的').fontSize('18fp').fontColor($r('app.color.white')).width('100%').height('10%')
                .textAlign(TextAlign.Center).margin({ top: '20vp' })

              Row(){
                Image($r('app.media.default_img')).width('80vp').height('80vp')
                  .border({ width: '2vp' }).borderColor($r('app.color.white'))
                  .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

                Column(){
                  Text('王大锤').fontSize('22fp').fontColor($r('app.color.white')).width('100%')
                    .textAlign(TextAlign.Start).margin({ left: '10vp',top:'10vp' })

                  Text('I\'m the master of my fate, the captain of my soul.')
                    .fontSize('18fp').fontColor($r('app.color.white')).width('100%')
                    .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                    .textAlign(TextAlign.Start).margin({ left: '10vp',top:'10vp' })

                }.width('80%').height('80vp')

                Image($r('app.media.ic_right_white')).width('50vp').height('50vp')

              }.width('100%').height('10%').alignItems(VerticalAlign.Center).margin({ left: '20vp',top:'20vp' })

            }.width('100%').height('100%').alignItems(HorizontalAlign.Start)

          }.width('100%').height('100%').alignContent(Alignment.Top)
        }.tabBar(this.meTabBuilder(3))
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