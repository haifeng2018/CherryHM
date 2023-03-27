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
  @State shareId: string = router.getParams()?.['shareId'];
  @State topicId: number = router.getParams()?.['topicId'];
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
        src: this.data.brief
      })
        .width(Constants.MATCH_PARENT)
        .height('56vp')
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
        .width('30vp')
        .height('30vp')
        .align(Alignment.End)
        .margin({right:'24vp'})
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
        .height('256vp')
        .sharedTransition(this.shareId, {
          duration: Constants.TRANSITION_ANIMATION_DURATION,
          curve: Curve.Smooth,
          delay: Constants.SHARE_ITEM_ANIMATION_DELAY
        })

      Column(){
        Text(this.data.brief)
          .width('90%')
          .height('80vp')
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.color_333333'))
          .fontSize('22fp')
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .padding('10vp')
          .margin({top:'226vp'})
          .border({ radius:'8vp' })
          .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })

        Text(this.data.text).width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize('18fp')
          .padding('10vp')
      }
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignContent(Alignment.Top)
  }

  @Builder authorLayout(info: LightTopicsInfo) {
    Row(){
      Image(info.data.content.data.author.icon)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.content.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.content.data.author.description)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({left:'10vp'})
    }
    .width(Constants.MATCH_PARENT)
    .padding({top:'10vp',bottom:'10vp',left:'20vp',right:'20vp'})
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
          .fontSize('16fp')
          .backgroundColor($r('app.color.color_4DFFFFFF'))
          .margin({top:'5vp',right:'5vp'})
          .padding({top:'5vp',bottom:'5vp',left:'10vp',right:'10vp'})
          .borderRadius('5vp')
      }
      .width(Constants.MATCH_PARENT)
      .height('256vp')
      .alignContent(Alignment.TopEnd)

      Text(info.data.content.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize('16fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(info.data.content.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'30vp'})
        Text(info.data.content.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'30vp'})
        Text(info.data.content.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})
      }
      .width(Constants.MATCH_PARENT)
      .justifyContent(FlexAlign.End)
      .padding({left:'10vp',right:'10vp'})

      Text()
        .width(Constants.MATCH_PARENT)
        .height('1vp')
        .margin({top:'10vp'})
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