import { LightTopicsInfo } from '../bean/LightTopicsInfo';
import { LightTopicsData } from '../bean/LightTopicsData';
import { RouterPath } from '../util/RouterPath';
import promptAction from '@ohos.promptAction';
import { DiscoveryApi } from '../api/DiscoveryApi';
import router from '@ohos.router';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';

@Entry
@Component
struct LightTopicsPage {
  @State isRefreshing: boolean = false

  @State topicId: number = router.getParams()?.['topicId'];

  @State data: LightTopicsData = new LightTopicsData();

  aboutToAppear() {
    this.sendLightTopicsRequest()
  }

  sendLightTopicsRequest () {
    HttpRequest.url = DiscoveryApi.LIGHT_TOPICS + this.topicId
    HttpRequest.request({
      onSuccess: (value) => {
        this.data = value
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    Column(){
      this.titleBar()

      Refresh({ refreshing: $$this.isRefreshing, offset: 56, friction: 66 }) {
        Column(){
          List() {
            ForEach(this.data.itemList, (item) => {
              ListItem() {
                this.listCell(item)
              }
            })
          }
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)
        }
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        refreshStatus
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
          this.sendLightTopicsRequest()
        }, 1000)
        console.log('onRefreshing test')
      })
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
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
        .fontSize($r('app.float.fp_22'))
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
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }

  @Builder listCell (info: LightTopicsInfo) {
    Stack(){
      Image(info.data.content.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('256vp')

      Text(info.data.content.data.title)
        .fontColor($r('app.color.white'))
        .fontSize('22fp')
        .padding('10vp')
      }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          playUrl: info.data.content.data.playUrl,
          id: info.data.content.data.id,
          title: info.data.content.data.title,
          description: info.data.content.data.description,
          category: info.data.content.data.category,
          collectionCount: info.data.content.data.consumption.collectionCount,
          shareCount: info.data.content.data.consumption.shareCount,
          replyCount: info.data.content.data.consumption.replyCount,
        }
      })
    })
  }
}