import RefreshComponent from '../view/widget/refresh/RefreshComponent';
import { RefreshConfig } from '../view/widget/refresh/RefreshConfig';
import { LightTopicsInfo } from '../bean/LightTopicsInfo';
import { LightTopicsData } from '../bean/LightTopicsData';
import RouterPath from '../util/RouterPath';
import promptAction from '@ohos.promptAction';
import { CommunityApi } from '../api/CommunityApi';
import router from '@ohos.router';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';
import { PageState } from '../view/widget/refresh/PageState';

@Entry
@Component
struct LightTopicsPage {
  @State shareId: string = router.getParams()?.[Constants.SHARE_ID];
  @State topicId: number = router.getParams()?.[Constants.TOPIC_ID];
  @State isRefreshing: boolean = false
  @State data: LightTopicsData = new LightTopicsData();

  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  aboutToAppear() {
    this.sendLightTopicsRequest()
  }

  sendLightTopicsRequest () {
    HttpRequest.url = CommunityApi.LIGHT_TOPICS + this.topicId
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        this.data = value
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    Column(){
      this.titleBar()

      RefreshComponent({
        itemLayout: () => this.itemLayout(),
        onRefresh: () => {
          this.sendLightTopicsRequest()
        }
      })
      .width(Constants.MATCH_PARENT)
      .layoutWeight(1)
      .zIndex(0)

    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder itemLayout () {
    List() {
      ListItem(){
        this.headerLayout()
      }
      ForEach(this.data.itemList, (item) => {
        ListItem() {
          this.cellLayout(item)
        }
      })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    // 去掉回弹效果
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      this.listScrollTop = start === 0
    })
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
        src: this.data.brief
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
    .zIndex(1)
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }

  @Builder headerLayout () {
    Stack(){
      Image(this.data.headerImage)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_256'))
        .sharedTransition(this.shareId, {
          duration: Constants.TRANSITION_ANIMATION_DURATION,
          curve: Curve.Smooth,
          delay: Constants.SHARE_ITEM_ANIMATION_DELAY
        })

      Column(){
        Text(this.data.brief)
          .width('90%')
          .height($r('app.float.vp_80'))
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_22'))
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .padding($r('app.float.vp_10'))
          .margin({top:$r('app.float.vp_226')})
          .border({ radius:$r('app.float.vp_8') })
          .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })

        Text(this.data.text).width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_10'))
      }
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignContent(Alignment.Top)
  }

  @Builder authorLayout(info: LightTopicsInfo) {
    Row(){
      Image(info.data.content.data.author.icon)
        .width($r('app.float.vp_40'))
        .height($r('app.float.vp_40'))
        .border({
          width: $r('app.float.vp_2'),color:$r('app.color.white'),
          radius:$r('app.float.vp_20'),style:BorderStyle.Solid })

      Column() {
        Text(info.data.content.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)

        Text(info.data.content.data.author.description)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_12'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({left:$r('app.float.vp_10')})
    }
    .width(Constants.MATCH_PARENT)
    .padding({
      top:$r('app.float.vp_10'),bottom:$r('app.float.vp_10'),
      left:$r('app.float.vp_20'),right:$r('app.float.vp_20')
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.USER_PAGE,
        params: {
          userId:info.data.content.data.author.id,
        }
      })
    })
  }

  @Builder cellLayout (info: LightTopicsInfo) {
    Column(){
      this.authorLayout(info)
      Stack() {
        Image(info.data.content.data.cover.feed)
          .objectFit(ImageFit.Cover)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)
          .sharedTransition(`${info.data.content.data.id}`, {
            duration: Constants.TRANSITION_ANIMATION_DURATION,
            curve: Curve.Smooth,
            delay: Constants.SHARE_ITEM_ANIMATION_DELAY
          })

        Text(info.data.content.data.category)
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_16'))
          .backgroundColor($r('app.color.color_4DFFFFFF'))
          .margin({top:$r('app.float.vp_5'),right:$r('app.float.vp_5')})
          .padding({
            top:$r('app.float.vp_5'),bottom:$r('app.float.vp_5'),
            left:$r('app.float.vp_10'),right:$r('app.float.vp_10')
          })
          .borderRadius($r('app.float.vp_5'))
      }
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_256'))
      .alignContent(Alignment.TopEnd)

      Text(info.data.content.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.fp_16'))
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding($r('app.float.vp_10'))

      Row() {
        Image($r('app.media.ic_video_likes'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))

        Text(info.data.content.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_16'))
          .margin({left:$r('app.float.vp_5')})

        Image($r('app.media.ic_video_comment'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))
          .margin({left:$r('app.float.vp_30')
          })

        Text(info.data.content.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_16'))
          .margin({left:$r('app.float.vp_5')})

        Image($r('app.media.ic_video_share'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))
          .margin({left:$r('app.float.vp_30')})

        Text(info.data.content.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_16'))
          .margin({left:$r('app.float.vp_5')})
      }
      .width(Constants.MATCH_PARENT)
      .justifyContent(FlexAlign.End)
      .padding({
        left:$r('app.float.vp_10'),
        right:$r('app.float.vp_10')
      })

      Text()
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_1'))
        .margin({top:$r('app.float.vp_10')})
        .backgroundColor($r('app.color.color_80DDDDDD'))
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          data: info.data.content.data,
          shareId: `${info.data.content.data.id}`
        }
      })
    })
  }
}