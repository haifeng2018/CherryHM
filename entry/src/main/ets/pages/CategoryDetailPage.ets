import { RouterPath } from '../util/RouterPath';
import promptAction from '@ohos.promptAction';
import { VideoInfo } from '../bean/VideoInfo';
import { DiscoveryApi } from '../api/DiscoveryApi';
import router from '@ohos.router';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';

@Entry
@Component
struct CategoryDetailPage {
  @State isRefreshing: boolean = false

  @State categoryId: number = router.getParams()?.['categoryId'];
  @State categoryName: string = router.getParams()?.['categoryName'];

  @State datas: Array<VideoInfo> = [];

  aboutToAppear() {
    this.sendCategoryDetailRequest()
  }

  sendCategoryDetailRequest () {
    HttpRequest.url = DiscoveryApi.CATEGORY_DETAIL + this.categoryId
    HttpRequest.request({
      onSuccess: (value) => {
        this.datas = value.itemList
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
        List() {
          ForEach(this.datas, (item) => {
            ListItem() {
              this.listCell(item)
            }
          })
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
          this.sendCategoryDetailRequest()
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
        src: this.categoryName
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
  }

  @Builder listCell (info: VideoInfo) {
    Stack(){
      Image(info.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('256vp')

      Text(info.data.title)
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
          playUrl: info.data.playUrl,
          id: info.data.id,
          title: info.data.title,
          description: info.data.description,
          category: info.data.category,
          collectionCount: info.data.consumption.collectionCount,
          shareCount: info.data.consumption.shareCount,
          replyCount: info.data.consumption.replyCount,
        }
      })
    })
  }
}