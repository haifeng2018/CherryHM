import router from '@ohos.router';
import { VideoInfo } from '../bean/VideoInfo';
import { VideoRelatedInfo } from '../bean/VideoRelatedInfo';
import promptAction from '@ohos.promptAction';
import { HomeApi } from '../api/HomeApi';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';

@Entry
@Component
struct VideoDetailPage {
  @State isRefreshing: boolean = false

  // 滑动的y偏移量
  private yTotalOffset = 0
  // 标题栏透明度
  @State titleBarOpacity: number = 0.3

  @State playUrl: string = router.getParams()?.['playUrl'];
  @State videoId: number = router.getParams()?.['id'];
  @State title: string = router.getParams()?.['title'];
  @State description: string = router.getParams()?.['description'];
  @State category: string = router.getParams()?.['category'];
  @State collectionCount: number = router.getParams()?.['collectionCount'];
  @State shareCount: number = router.getParams()?.['shareCount'];
  @State replyCount: number = router.getParams()?.['replyCount'];

  @State previewUri: Resource = $r('app.media.default_img')
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @State isAutoPlay: boolean = true
  @State showControls: boolean = false
  videoController: VideoController = new VideoController()

  private scroller: Scroller = new Scroller()

  @State videoRelatedList: Array<VideoRelatedInfo> = [];

  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  aboutToAppear() {
    this.sendVideoRelatedRequest()
  }

  sendVideoRelatedRequest () {
    HttpRequest.url = HomeApi.VIDEO_RELATED + this.videoId
    HttpRequest.request({
      onSuccess: (value) => {
        this.videoRelatedList = value.itemList
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
      Stack(){
        Refresh({ refreshing: $$this.isRefreshing, offset: 56, friction: 66 }) {
          Scroll(this.scroller) {
            Column() {
              Video({
                src: this.playUrl,
                previewUri: this.previewUri,
                currentProgressRate: this.curRate,
                controller: this.videoController
              }).width(Constants.MATCH_PARENT).aspectRatio(1.3)
                .autoPlay(this.isAutoPlay)
                .controls(this.showControls)
                .onStart(() => {
                  console.info('onStart')
                })
                .onPause(() => {
                  console.info('onPause')
                })
                .onFinish(() => {
                  console.info('onFinish')
                })
                .onError(() => {
                  console.info('onFinish')
                })
                .onPrepared((e) => {
                  console.info('onPrepared is ' + e.duration)
                })
                .onSeeking((e) => {
                  console.info('onSeeking is ' + e.time)
                })
                .onSeeked((e) => {
                  console.info('onSeeked is ' + e.time)
                })
                .onUpdate((e) => {
                  console.info('onUpdate is ' + e.time)
                })
                .onClick(() => {
                  this.videoController.start()
                })

              Text(this.title)
                .width(Constants.MATCH_PARENT)
                .fontColor($r('app.color.color_333333'))
                .fontSize('22fp')
                .padding('10vp')

              Text(this.category)
                .width(Constants.MATCH_PARENT)
                .fontColor($r('app.color.color_666666'))
                .fontSize('18fp')
                .padding('10vp')

              Text(this.description)
                .width(Constants.MATCH_PARENT)
                .fontColor($r('app.color.color_333333'))
                .fontSize('12fp')
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .padding('10vp')

              Row(){
                Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
                Text(this.collectionCount.toString())
                  .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

                Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
                Text(this.replyCount.toString())
                  .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

                Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
                Text(this.shareCount.toString())
                  .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})
              }
              .width(Constants.MATCH_PARENT)
              .padding('10vp')

              List({ space: 20 }) {
                ForEach(this.videoRelatedList, (item) => {
                  ListItem() {
                    if (item.type === 'textCard') {
                      this.textCardCell(item)
                    } else if (item.type === 'videoSmallCard') {
                      this.videoSmallCardCell(item)
                    }
                  }
                  .padding('10vp')
                })
              }
              .width(Constants.MATCH_PARENT)
              .height(Constants.MATCH_PARENT)
            }
            .width(Constants.MATCH_PARENT)
          }
          .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
          .scrollBar(BarState.On)  // 滚动条常驻显示
          .scrollBarColor(Color.Gray)  // 滚动条颜色
          .scrollBarWidth(30) // 滚动条宽度
          .edgeEffect(EdgeEffect.None)
          .onScroll((xOffset: number, yOffset: number) => {
            console.info(xOffset + ' ' + yOffset)
            this.yTotalOffset += yOffset
            const yTotalOffsetVP = px2vp(this.yTotalOffset)
            // 轮播图高度 350
            const scale = yTotalOffsetVP / 100
            this.titleBarOpacity = scale
            if (scale < 0) {
              this.titleBarOpacity = 0
            }
            if (scale > 1) {
              this.titleBarOpacity = 1
            }

          })
          .onScrollEdge((side: Edge) => {
            console.info('To the edge')
          })
          .onScrollEnd(() => {
            console.info('Scroll Stop')
          })
        }
        .onStateChange((refreshStatus: RefreshStatus) => {
          refreshStatus
          console.info('Refresh onStatueChange state is ' + refreshStatus)
        })
        .onRefreshing(() => {
          setTimeout(() => {
            this.isRefreshing = false
            this.sendVideoRelatedRequest()
          }, 1000)
          console.log('onRefreshing test')
        })
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)

        this.titleBar()
      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .alignContent(Alignment.Top)
  }

  @Builder titleBar() {
    Row(){
      Image($r('app.media.ic_back'))
        .width('30vp')
        .height('30vp')
        .objectFit(ImageFit.Contain)
        .margin({left:'14vp'})
        .onClick(() =>{
          router.back()
        })

      Marquee({
        start: true,
        step: 20,
        loop: Infinity,
        fromStart: true,
        src: this.title
      })
        .width(Constants.MATCH_PARENT)
        .height('56vp')
        .layoutWeight(1)
        .fontSize($r('app.float.fp_28'))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(500)
        .onStart(() => {
          console.info('Marquee animation complete onStart')
        })
        .onBounce(() => {
          console.info('Marquee animation complete onBounce')
        })
        .onFinish(() => {
          console.info('Marquee animation complete onFinish')
        })

      Image($r('app.media.ic_share'))
        .width('30vp')
        .height('30vp')
        .align(Alignment.End)
        .margin({right:'24vp'})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({top:'36vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .opacity(this.titleBarOpacity)
  }

  @Builder textCardCell(info: VideoInfo) {
    Text(info.data.text)
      .width(Constants.MATCH_PARENT)
      .fontSize('22fp')
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }

  @Builder videoSmallCardCell(info: VideoInfo) {
    Stack(){
      Row() {
        Image(info.data.cover.detail)
          .width('168vp')
          .height(Constants.MATCH_PARENT)
          .borderRadius({ topLeft:'10vp',bottomLeft:'10vp' })

        Column() {
          Text(info.data.category)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.End)
            .fontColor($r('app.color.color_666666'))
            .fontSize('18fp')
            .padding('5vp')

          Text(info.data.title)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize('16fp')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding('5vp')
            .margin({left:'30vp'})
            .align(Alignment.Bottom)

        }
        .height(Constants.MATCH_PARENT)
        .layoutWeight(1)

      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)

      if (info.data.author != null && info.data.author.icon != null) {
        Image(info.data.author.icon).width('40vp').height('40vp')
          .borderRadius('40vp').borderStyle(BorderStyle.Dashed)
          .margin({left:'148vp'})
      }
    }
    .width(Constants.MATCH_PARENT)
    .height('118vp')
    .backgroundColor($r('app.color.white'))
    .borderRadius('10vp')
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .alignContent(Alignment.Start)
    .onClick(() => {
      this.playUrl = info.data.playUrl
      this.videoId = info.data.id
      this.title = info.data.title
      this.description = info.data.description
      this.category = info.data.category
      this.collectionCount = info.data.consumption.collectionCount
      this.shareCount = info.data.consumption.shareCount
      this.replyCount = info.data.consumption.replyCount
      this.sendVideoRelatedRequest()
    })
  }
}