import RouterPath from '../util/RouterPath';
import RefreshComponent from '../view/widget/refresh/RefreshComponent';
import { RefreshConfig } from '../view/widget/refresh/RefreshConfig';
import { VideoCellContentData } from '../bean/VideoCellContentData';
import router from '@ohos.router';
import { VideoInfo } from '../bean/VideoInfo';
import { VideoRelatedInfo } from '../bean/VideoRelatedInfo';
import promptAction from '@ohos.promptAction';
import { VideoApi } from '../api/VideoApi';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';
import { PageState } from '../view/widget/refresh/PageState';
import DateUtil from '../util/DateUtil';

@Entry
@Component
struct VideoDetailPage {
  @State shareId: string = router.getParams()?.['shareId'];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  // 滑动的y偏移量
  private yTotalOffset = 0
  // 标题栏透明度
  @State titleBarOpacity: number = 1

  @State data: VideoCellContentData = router.getParams()?.[Constants.DATA];

  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @State isAutoPlay: boolean = true
  @State showControls: boolean = false
  videoController: VideoController = new VideoController()

  private scroller: Scroller = new Scroller()

  @State datas: Array<VideoRelatedInfo> = [];

  aboutToAppear() {
    this.sendVideoRelatedRequest()
  }

  sendVideoRelatedRequest () {
    HttpRequest.url = VideoApi.VIDEO_RELATED + this.data.id
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        this.datas = value.itemList
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail;
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    RelativeContainer() {
      RefreshComponent({
        itemLayout: () => this.itemLayout(),
        onRefresh: () => {
          this.sendVideoRelatedRequest()
        }
      })
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .id('mRefreshContent')

      this.titleBar()
      this.smallPlay()
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
    .sharedTransition(this.shareId, {
      duration: Constants.TRANSITION_ANIMATION_DURATION,
      curve: Curve.Smooth,
      delay: Constants.SHARE_ITEM_ANIMATION_DELAY
    })
  }

  @Builder itemLayout () {
    Scroll(this.scroller) {
      Column() {
        Video({
          src: this.data.playUrl,
          previewUri: this.data.cover.feed,
          currentProgressRate: this.curRate,
          controller: this.videoController
        })
          .width(Constants.MATCH_PARENT)
          .height($r('app.float.vp_256'))
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
            this.titleBarOpacity = 0
            animateTo({ duration: 1000 }, () => {
            })
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

        Text(this.data.title)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_24'))
          .padding($r('app.float.vp_10'))

        Text(`${this.data.category}\t${DateUtil.formatReleaseDate(this.data.releaseTime)}`)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_20'))
          .padding($r('app.float.vp_10'))

        Text(this.data.description)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_18'))
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding($r('app.float.vp_10'))

        Row(){
          Image($r('app.media.ic_video_likes'))
            .width($r('app.float.vp_20'))
            .height($r('app.float.vp_20'))

          Text(this.data.consumption.collectionCount.toString())
            .fontColor($r('app.color.color_999999'))
            .fontSize($r('app.float.fp_16'))
            .margin({left:$r('app.float.vp_5')})

          Image($r('app.media.ic_video_comment'))
            .width($r('app.float.vp_20'))
            .height($r('app.float.vp_20'))
            .margin({left:$r('app.float.vp_30')})

          Text(this.data.consumption.replyCount.toString())
            .fontColor($r('app.color.color_999999'))
            .fontSize($r('app.float.fp_16'))
            .margin({left:$r('app.float.vp_5')})

          Image($r('app.media.ic_video_share'))
            .width($r('app.float.vp_20'))
            .height($r('app.float.vp_20'))
            .margin({left:$r('app.float.vp_30')})

          Text(this.data.consumption.shareCount.toString())
            .fontColor($r('app.color.color_999999'))
            .fontSize($r('app.float.fp_16'))
            .margin({left:$r('app.float.vp_5')})
        }
        .width(Constants.MATCH_PARENT)
        .padding($r('app.float.vp_10'))

        Divider().color($r('app.color.color_80DDDDDD'))
        this.authorLayout(this.data)
        Divider().color($r('app.color.color_80DDDDDD'))

        //这个地方不能用list容器会和scroll滑动冲突
        ForEach(this.datas, (item) => {
          if (item.type === 'textCard') {
            this.textCardCell(item)
          } else if (item.type === 'videoSmallCard') {
            this.videoSmallCardCell(item)
          }
        })
      }
      .width(Constants.MATCH_PARENT)
    }
    .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
    .scrollBar(BarState.Off)  // 滚动条常驻显示
    .scrollBarColor(Color.Gray)  // 滚动条颜色
    .scrollBarWidth(30) // 滚动条宽度
    .edgeEffect(EdgeEffect.None)
    .onScroll((xOffset: number, yOffset: number) => {
      console.error('onScroll-xOffset =' + xOffset)
      console.error('onScroll-yOffset =' + yOffset)
      this.yTotalOffset += yOffset
      const yTotalOffsetVP = px2vp(this.yTotalOffset)
      // 轮播图高度 350
      const scale = yTotalOffsetVP / 100
      this.titleBarOpacity = scale
      if (scale < 0) {
        this.titleBarOpacity = 0
        this.listScrollTop = true
      }
      if (scale > 1) {
        this.titleBarOpacity = 1
        this.listScrollTop = false
      }
    })
    .onScrollEdge((side: Edge) => {
      console.info('To the edge')
    })
    .onScrollEnd(() => {
      console.info('Scroll Stop')
    })
  }

  @Builder smallPlay() {
    if (!this.listScrollTop) {
      Video({
        src: this.data.playUrl,
        currentProgressRate: this.curRate,
        controller: this.videoController
      })
      .width($r('app.float.vp_180'))
      .height($r('app.float.vp_120'))
      .autoPlay(this.isAutoPlay)
      .controls(this.showControls)
      .margin({bottom:$r('app.float.vp_100')})
        .alignRules({
          bottom: {anchor: "__container__", align: VerticalAlign.Bottom},
          right: {anchor: "__container__", align: HorizontalAlign.End},
        })
        .id('mVideo')
    }
  }

  @Builder titleBar() {
    Row(){
      Image($r('app.media.ic_back'))
        .width($r('app.float.vp_30'))
        .height($r('app.float.vp_30'))
        .objectFit(ImageFit.Contain)
        .margin({left:$r('app.float.vp_14')})
        .onClick(() =>{
          router.back()
        })

      Marquee({
        start: true,
        step: 20,
        loop: Infinity,
        fromStart: true,
        src: this.data.title
      })
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_56'))
        .layoutWeight(1)
        .fontSize($r('app.float.fp_24'))
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
        .width($r('app.float.vp_30'))
        .height($r('app.float.vp_30'))
        .align(Alignment.End)
        .margin({right:$r('app.float.vp_24')})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({top:$r('app.float.status_bar_height')})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .opacity(this.titleBarOpacity)
    .alignRules({
      top: {anchor: "__container__", align: VerticalAlign.Top},
    })
    .id('mTitleBar')
  }

  @Builder textCardCell(info: VideoInfo) {
    Text(info.data.text)
      .width(Constants.MATCH_PARENT)
      .padding({left:$r('app.float.vp_10')})
      .fontSize($r('app.float.fp_22'))
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .padding($r('app.float.vp_10'))
  }

  @Builder authorLayout(info: VideoCellContentData) {
    if (info.author != null) {
      Row(){
        if (info.author.icon != null) {
          Image(info.author.icon)
            .width($r('app.float.vp_40'))
            .height($r('app.float.vp_40'))
            .clip(new Circle({ width: '40vp', height: '40vp' }))
        }

        Column() {
          Text(info.author.name)
            .width(Constants.MATCH_PARENT)
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_18'))
            .padding($r('app.float.vp_2'))
            .textAlign(TextAlign.Start)

          Text(info.author.description)
            .width(Constants.MATCH_PARENT)
            .fontColor($r('app.color.color_666666'))
            .fontSize($r('app.float.vp_12'))
            .padding($r('app.float.vp_2'))
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .padding({left:$r('app.float.vp_10')})

        Text($r('app.string.add_follow'))
          .padding({
            top:$r('app.float.vp_4'),
            bottom:$r('app.float.vp_4'),
            left:$r('app.float.vp_10'),
            right:$r('app.float.vp_10')
          })
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_18'))
          .border({
            width: $r('app.float.vp_2'),
            color:$r('app.color.color_666666'),
            radius:$r('app.float.vp_5'),
            style:BorderStyle.Solid
          })
      }
      .width(Constants.MATCH_PARENT)
      .padding($r('app.float.vp_10'))
      .onClick(() => {
        router.pushUrl({
          url: RouterPath.USER_PAGE,
          params: {
            userId:info.author.id,
          }
        })
      })
    }
  }

  @Builder videoSmallCardCell(info: VideoInfo) {
    Stack(){
      Row() {
        Image(info.data.cover.detail)
          .width($r('app.float.vp_168'))
          .height(Constants.MATCH_PARENT)

        Column() {
          Text(info.data.category)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.End)
            .fontColor($r('app.color.color_666666'))
            .fontSize($r('app.float.fp_18'))
            .padding({ right:$r('app.float.vp_10') })

          Text(info.data.title)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_16'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({
              bottom:$r('app.float.vp_10'),
              left:$r('app.float.vp_30'),
              right: $r('app.float.vp_10')
            })
            .align(Alignment.Bottom)

        }
        .height(Constants.MATCH_PARENT)
        .layoutWeight(1)

      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)

      if (info.data.author != null && info.data.author.icon != null) {
        Image(info.data.author.icon)
          .width($r('app.float.vp_40'))
          .height($r('app.float.vp_40'))
          .margin({left:$r('app.float.vp_148')})
          .clip(new Circle({ width: '40vp', height: '40vp' }))
      }
    }
    .width(Constants.MATCH_PARENT)
    .height($r('app.float.vp_118'))
    .backgroundColor($r('app.color.white'))
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .alignContent(Alignment.Start)
    .margin({top:$r('app.float.vp_5'),bottom:$r('app.float.vp_5')})
    .onClick(() => {
      this.data = info.data
      this.sendVideoRelatedRequest()
    })
  }
}