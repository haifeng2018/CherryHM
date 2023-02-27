@Entry
@Component
struct MainPage {
  @State fontColor: string = 'rgba(0, 0, 0, 0.4)'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  // 列表数据
  @State array: Array<string> = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
  // key:索引,value:y轴位置
  private mapOffsetY: Map<number, number> = new Map()
  // 移动的index
  @State moveIndex: number = -2
  // 移动的偏移量
  @State moveOffsetY: number = 0
  // 按下时自身顶点y轴位置
  private downSelfY = 0
  // 按下时距屏幕的y轴位置
  private downScreenY = 0

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
            ForEach(this.array, (item, index) => {
              Text('内容' + item)
                .width('100%')
                .height(50)
                .fontSize(18)
                .fontColor(Color.White)
                .borderRadius(10)
                .margin({ bottom: 10 })
                .textAlign(TextAlign.Center)
                .zIndex(this.moveIndex === index ? 1 : 0)
                .position({
                  x: this.moveIndex === index ? 5 : 0,
                  y: this.moveIndex === index ? this.moveOffsetY : this.mapOffsetY.get(index)
                })
                .animation({ duration: this.moveIndex === index ? 0 : 100 })
                .backgroundColor(this.moveIndex === index ? '#14a063' : '#18BF74')
                .onTouch((event: TouchEvent) => this.onTouchEvent(event, index))
                .onAreaChange((oldValue: Area, newValue: Area) => {
                  if (this.mapOffsetY.size !== this.array.length) {
                    // 记录每个item的y坐标
                    console.info(`index = ${index} ${JSON.stringify(newValue)}`)
                    const height = Number.parseInt(newValue.height.toString())
                    this.mapOffsetY.set(index, 10 + (index * 10) + index * height)
                    // 更新页面，才能让position起作用
                    this.moveIndex = -1
                  }
                })
            }, item => item)
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

  onTouchEvent(event: TouchEvent, index: number) {
    switch (event.type) {
      case TouchType.Down: // 手指按下
        {
          // 更新当前移动的index
          this.moveIndex = index
          // 按下时自身顶点y轴位置
          this.downSelfY = event.touches[0].y
          // 按下时距屏幕的y轴位置
          this.downScreenY = event.touches[0].screenY
          // 更改偏移量
          this.moveOffsetY = this.downScreenY - this.downSelfY - 5
        }
        break
      case TouchType.Move: // 手指移动
        {
          // 距离屏幕y坐标
          const screenY = event.touches[0].screenY
          // 更改偏移量
          this.moveOffsetY = screenY - this.downSelfY - 5
          // 第一位，不能上移
          if (this.moveIndex === 0 && this.moveOffsetY < 0) {
            this.moveOffsetY = 0
            return
          }
          // 最后一位，不能下移
          if (this.moveIndex === this.array.length - 1 && this.moveOffsetY > this.mapOffsetY.get(this.moveIndex)) {
            this.moveOffsetY = this.mapOffsetY.get(this.moveIndex)
            return
          }
          // 向下拖动
          if (screenY - this.downScreenY > 25) {
            // 交换满足条件的两个item内容
            const tempOffsetY = this.array[this.moveIndex+1]
            this.array[this.moveIndex+1] = this.array[this.moveIndex]
            this.array[this.moveIndex] = tempOffsetY
            // 更新按下的y坐标
            this.downScreenY += 60
            // 更新移动的索引，触发页面的更新
            this.moveIndex++
          }
          // 向上拖动
          if (screenY - this.downScreenY < -35) {
            const tempOffsetY = this.array[this.moveIndex-1]
            this.array[this.moveIndex-1] = this.array[this.moveIndex]
            this.array[this.moveIndex] = tempOffsetY
            this.downScreenY -= 60
            this.moveIndex--
          }
        }
        break
      case TouchType.Up: // 手指抬起
        this.moveIndex = -1
        break
      default:
        break;
    }
  }
}