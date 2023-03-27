import { CategoryInfo } from '../bean/CategoryInfo';
import LMList from '../view/widget/refresh/LMList';
import { RefreshConfig } from '../view/widget/refresh/RefreshConfig';
import RouterPath from '../util/RouterPath';
import promptAction from '@ohos.promptAction';
import { VideoInfo } from '../bean/VideoInfo';
import { CommunityApi } from '../api/CommunityApi';
import router from '@ohos.router';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';
import { PageState } from '../view/widget/refresh/PageState';

@Entry
@Component
struct CategoryDetailPage {

  @State data: CategoryInfo = router.getParams()?.['data'];

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = CommunityApi.CATEGORY_DETAIL + this.data.id

  sendCategoryDetailRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === CommunityApi.CATEGORY_DETAIL + this.data.id) {
          this.datas = value.itemList
        } else {
          this.datas = this.datas.concat(value.itemList);
        }
        this.nextPageUrl = value.nextPageUrl + CommunityApi.CATEGORY_DETAIL_AUTH
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  aboutToAppear() {
    this.sendCategoryDetailRequest()
  }

  refreshData () {
    this.nextPageUrl = CommunityApi.CATEGORY_DETAIL + this.data.id
    this.sendCategoryDetailRequest()
  }

  loadMoreData () {
    this.sendCategoryDetailRequest()
  }

  build() {
    Column() {
      this.titleBar()
      LMList({
        itemLayout: (data) => this.itemLayout(data),
        onRefresh: () => {
          this.refreshData()
        },
        onLoadMore: () => {
          this.loadMoreData()
        }
      })
        .layoutWeight(1)
        .zIndex(0)
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
        src: this.data.name
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

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.author.icon)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.author.description)
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
    .padding({top:'10vp',bottom:'20vp',left:'20vp',right:'20vp'})
  }

  @Builder itemLayout (info: VideoInfo) {
    Column(){
      Image(info.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('256vp')

      Text(info.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize('16fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      this.authorLayout(info)
    }
    .width(Constants.MATCH_PARENT)
    .layoutWeight(1)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .sharedTransition(`${this.datas.indexOf(info)}${info.data.id}`, {
      duration: Constants.TRANSITION_ANIMATION_DURATION,
      curve: Curve.Smooth,
      delay: Constants.SHARE_ITEM_ANIMATION_DELAY
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          data: info.data,
          shareId: `${this.datas.indexOf(info)}${info.data.id}`
        }
      })
    })
  }
}