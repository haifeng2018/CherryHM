import router from '@ohos.router';
import Constants from '../util/Constants';
import { initializeOnStartup } from '../bean/SplashInfo';
import { SplashInfo } from '../bean/SplashInfo';

class MyDataSource implements IDataSource {
  private list: number[] = []
  private listener: DataChangeListener

  constructor(list: number[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): any {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  unregisterDataChangeListener() {
  }
}

@Entry
@Component
struct SplashPage {
  private swiperController: SwiperController = new SwiperController()
  private imageArray: Array<SplashInfo> = [] // 数据源
  @State enterAppBtnVisible: boolean = false//进入app按钮是否可见
  @State enterAppBtnOpacity: number = 0//进入app按钮透明度

  aboutToAppear(): void {
    this.imageArray = initializeOnStartup()
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Swiper(this.swiperController) {
        ForEach(this.imageArray, item => { // ForEach循环渲染 item即是imageArray数组的每一项
          Image(item.image)
            .objectFit(ImageFit.Fill) // 图片铺满
            .width(Constants.FULL_WIDTH)
            .height(Constants.FULL_HEIGHT) // 固定高度
        }, item => item.id.toString())
      }
      .cachedCount(2)
      .index(0)
      .autoPlay(false)
      .interval(1000)
      .indicator(true)
      .indicatorStyle({bottom:128,size: 25, mask: true,color:$r('app.color.color_80FFFFFF'),selectedColor:$r('app.color.white')})
      .loop(false)
      .duration(300)
      .itemSpace(0)
      .curve(Curve.Linear)
      .displayMode(SwiperDisplayMode.Stretch)
      .onChange((index: number) => {
        this.enterAppBtnVisible = index == 1
        if (index == 1) {
          this.enterAppBtnOpacity = 1
        } else {
          this.enterAppBtnOpacity = 0
        }
      })
      Button($r('app.string.enter_app'))
        .visibility(this.enterAppBtnVisible ? Visibility.Visible : Visibility.Hidden)
        .align(Alignment.Center)
        .width('50%')
        .margin({bottom:80})
        .opacity(this.enterAppBtnOpacity)
        .animation({
          duration: 1000, // 动画时长
          curve: Curve.FastOutSlowIn, // 动画曲线
          delay: 0, // 动画延迟
          iterations: 1, // 播放次数
          playMode: PlayMode.Normal // 动画模式
        }) // 对Button组件的宽高属性进行动画配置
        .onClick(() => {
          router.pushUrl({
            url: 'pages/MainPage',
            params: {
              data1: 'message',
              data2: {
                data3: [123, 456, 789]
              },
            },
          });
        })
    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
  }
  pageTransition() {
    PageTransitionEnter({ duration: 500 })
      .slide(SlideEffect.Left)
    PageTransitionExit({ delay: 100 })
      .translate({ x: 100.0, y: 100.0 })
      .opacity(0)
  }
}

