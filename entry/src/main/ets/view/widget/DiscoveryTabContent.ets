import { CategoryInfo } from '../../bean/CategoryInfo';
import { VideoCellContentInfo } from '../../bean/VideoCellContentInfo';
import { VideoInfo } from '../../bean/VideoInfo';
import RefreshComponent from './refresh/RefreshComponent';
import router from '@ohos.router';
import RouterPath from '../../util/RouterPath';
import { RefreshConfig } from './refresh/RefreshConfig';
import { HomeApi } from '../../api/HomeApi';
import promptAction from '@ohos.promptAction';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
import UrlUtil from '../../util/UrlUtil';
import { PageState } from './refresh/PageState';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DiscoveryTabContent
 * Author: Victor
 * Date: 2023/3/23 18:47
 * Description: 首页-发现
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct DiscoveryTabContent {
  @State datas: Array<any> = [];

  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  private scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendDiscoveryRequest()
  }

  sendDiscoveryRequest () {
    HttpRequest.url = HomeApi.DISCOVERY
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        this.datas = value.itemList
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    RefreshComponent({
      itemLayout: () => this.itemLayout(),
      onRefresh: () => {
        this.sendDiscoveryRequest()
      }
    })
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder itemLayout() {
    Scroll() {
      Column() {
        ForEach(this.datas, (data) => {
          if (data.type === 'horizontalScrollCard') {
            this.bannerLayout(data)
          } else if (data.type === 'specialSquareCardCollection') {
            this.categoryLayout(data)
          } else if (data.type === 'columnCardList') {
            this.topicLayout(data)
          } else if (data.type === 'textCard') {
            this.headCell(data.data.text)
          } else if (data.type === 'videoSmallCard') {
            this.videoSmallCardCell(data)
          } else if (data.type === 'briefCard') {
            this.briefCardCell(data)
          }
          else {
            this.headCell(data.type)
          }
        })
      }
      .padding({left:$r('app.float.vp_10'),right:$r('app.float.vp_10')})
    }
    .onScroll((xOffset: number, yOffset: number) => {
      this.listScrollTop = yOffset <= 0
    })
  }

  @Builder bannerLayout(info: VideoInfo) {
    Swiper() {
      ForEach(info.data.itemList, item => {
        Image(item.data.image)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)
          .borderRadius($r('app.float.vp_10'))
          .onClick(() => {
            router.pushUrl({
              url: RouterPath.WEB_PAGE,
              params: {
                title: item.data.title,
                url: UrlUtil.getUrl(item.data.actionUrl),
              },
            })
          })
      })
    }
    .width(Constants.MATCH_PARENT)
    .height($r('app.float.vp_198'))
    .cachedCount(info.data.itemList.length)
    .index(0)
    .autoPlay(info.data.itemList.length > 1)
    .interval(3000)
    .indicator(info.data.itemList.length > 1)
    .indicatorStyle({
      bottom:10,size: 20, mask: true,
      color:$r('app.color.color_80FFFFFF'),
      selectedColor:$r('app.color.white')})
    .loop(true)
    .duration(1000)
    .itemSpace(0)
    .curve(Curve.Linear)
  }

  @Builder headCell(title: string) {
    Text(title)
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_56'))
      .fontSize($r('app.float.fp_28'))
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
  }

  @Builder categoryLayout(info: VideoInfo) {
    Column(){
      this.headCell(info.data.header.title)
      Grid(this.scroller) {
        ForEach(info.data.itemList, (data) => {
          GridItem() {
            this.categoryCellLayout(data)
          }
          .width($r('app.float.vp_110'))
          .height($r('app.float.vp_90'))
        })
      }
      .layoutDirection(GridDirection.Row)
      .rowsTemplate('1fr 1fr')
      .columnsGap($r('app.float.vp_10'))
      .rowsGap($r('app.float.vp_10'))
      .backgroundColor($r('app.color.color_F9F9F9'))
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_220'))
      .onScrollIndex((first: number) => {
        this.listScrollTop = first === 0
      })
    }
  }

  @Builder categoryCellLayout (info: VideoCellContentInfo) {
    Stack(){
      Image(info.data.image)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
        .borderRadius($r('app.float.vp_10'))

      Text(info.data.title)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.fp_22'))
        .fontColor($r('app.color.white'))

    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.vp_10'))
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .sharedTransition(`${info.data.dataType}${info.data.id}`, {
      duration: Constants.TRANSITION_ANIMATION_DURATION,
      curve: Curve.Smooth,
      delay: Constants.SHARE_ITEM_ANIMATION_DELAY
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.CATEGORY_DETAIL_PAGE,
        params: {
          data: this.getCategoryInfo(info),
          shareId: `${info.data.dataType}${info.data.id}`
        }
      })
    })
  }

  @Builder topicLayout(info: VideoInfo) {
    Column() {
      this.headCell(info.data.header.title)

      List({ space: 10 }) {
        ForEach(info.data.itemList, (data) => {
          ListItem() {
            this.topicCellLayout(data)
          }
          .width($r('app.float.vp_168'))
        })
      }
      .listDirection(Axis.Horizontal)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_110'))
    }
  }

  @Builder topicCellLayout (data: VideoCellContentInfo) {
    Stack(){
      Image(data.data.image)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
        .borderRadius($r('app.float.vp_10'))

      Text(data.data.title)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.fp_18'))
        .fontColor($r('app.color.white'))

    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({bottomLeft:$r('app.float.vp_10'),bottomRight:$r('app.float.vp_10')})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.WEB_PAGE,
        params: {
          title: data.data.title,
          url: UrlUtil.getUrl(data.data.actionUrl),
        },
      })
    })
  }

  @Builder videoSmallCardCell(info: VideoInfo) {
    Stack(){
      Row() {
        Image(info.data.cover.detail)
          .width($r('app.float.vp_168'))
          .height(Constants.MATCH_PARENT)
          .borderRadius({topLeft:$r('app.float.vp_10'),bottomLeft:$r('app.float.vp_10')})

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
    .margin({top:$r('app.float.vp_5'),bottom:$r('app.float.vp_5')})
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.vp_10'))
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .alignContent(Alignment.Start)
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          data:info.data,
          shareId: `${this.datas.indexOf(info)}${info.data.id}`
        }
      })
    })
  }

  @Builder briefCardCell(info: VideoInfo) {
    Row(){
      Image(info.data.icon)
        .width($r('app.float.vp_60'))
        .height($r('app.float.vp_60'))
        .clip(new Circle({ width: '60vp', height: '60vp' }))

      Column() {
        Text(info.data.title)
          .width(Constants.MATCH_PARENT)
          .margin({left:$r('app.float.vp_10')})
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_20'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)

        Text(info.data.description)
          .width(Constants.MATCH_PARENT)
          .margin({left:$r('app.float.vp_10')})
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)

      Text($r('app.string.add_follow'))
        .margin({left:$r('app.float.vp_5')})
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
    .backgroundColor($r('app.color.white'))
    .margin({top:$r('app.float.vp_5'),bottom:$r('app.float.vp_5')})
    .padding($r('app.float.vp_10'))
    .borderRadius($r('app.float.vp_10'))
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.WEB_PAGE,
        params: {
          title: info.data.title.replace('#',''),
          url: UrlUtil.getUrl(info.data.actionUrl),
        },
      })
    })
  }

  getCategoryInfo (info: VideoCellContentInfo):CategoryInfo {
    let data = new CategoryInfo()
    data.id = info.data.id
    data.name = info.data.title?.replace('#','')
    return data
  }
}