import { CategoryInfo } from '../bean/CategoryInfo';
import LMList from '../view/widget/refresh/LMList';
import { RefreshConfig } from '../view/widget/refresh/RefreshConfig';
import RouterPath from '../util/RouterPath';
import promptAction from '@ohos.promptAction';
import { VideoInfo } from '../bean/VideoInfo';
import { CommunityApi } from '../api/CommunityApi';
import { AuthApi } from '../api/AuthApi';
import router from '@ohos.router';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';
import { PageState } from '../view/widget/refresh/PageState';

@Entry
@Component
struct CategoryDetailPage {

  @State data: CategoryInfo = router.getParams()?.[Constants.DATA];

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
        this.nextPageUrl = value.nextPageUrl + AuthApi.AUTH
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
        src: this.data.name
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

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.author.icon)
        .width($r('app.float.vp_40'))
        .height($r('app.float.vp_40'))
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)

        Text(info.data.author.description)
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
      top:$r('app.float.vp_10'),bottom:$r('app.float.vp_20'),
      left:$r('app.float.vp_20'),right:$r('app.float.vp_20')
    })
  }

  @Builder itemLayout (info: VideoInfo) {
    Column(){
      Image(info.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_256'))

      Text(info.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.fp_16'))
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding($r('app.float.vp_10'))

      this.authorLayout(info)
    }
    .width(Constants.MATCH_PARENT)
    .layoutWeight(1)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
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