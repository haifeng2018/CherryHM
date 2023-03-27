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
      .padding({left:'10vp',right:'10vp'})
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
          .borderRadius('10vp')
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
    .height('198vp')
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
      .height('56vp').fontSize('28fp')
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
          .width('110vp')
          .height('90vp')
        })
      }
      .layoutDirection(GridDirection.Row)
      .rowsTemplate('1fr 1fr')
      .columnsGap('10vp')
      .rowsGap('10vp')
      .backgroundColor($r('app.color.color_F9F9F9'))
      .width(Constants.MATCH_PARENT)
      .height('220vp')
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
        .borderRadius('10vp')

      Text(info.data.title)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize('22fp')
        .fontColor($r('app.color.white'))

    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius('10vp')
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
          .width('168vp')
        })
      }
      .listDirection(Axis.Horizontal)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .width(Constants.MATCH_PARENT)
      .height('110vp')
    }
  }

  @Builder topicCellLayout (data: VideoCellContentInfo) {
    Stack(){
      Image(data.data.image)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
        .borderRadius('10vp')

      Text(data.data.title)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize('18fp')
        .fontColor($r('app.color.white'))

    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
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
          .width('168vp')
          .height(Constants.MATCH_PARENT)
          .borderRadius({topLeft:'10vp',bottomLeft:'10vp'})

        Column() {
          Text(info.data.category)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.End)
            .fontColor($r('app.color.color_666666'))
            .fontSize('18fp')
            .padding({ right:'10vp' })

          Text(info.data.title)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize('16fp')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ bottom:'10vp',left:'30vp',right: '10vp' })
            .align(Alignment.Bottom)

        }
        .height(Constants.MATCH_PARENT)
        .layoutWeight(1)

      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)

      if (info.data.author != null && info.data.author.icon != null) {
        Image(info.data.author.icon)
          .width('40vp')
          .height('40vp')
          .margin({left:'148vp'})
          .clip(new Circle({ width: '40vp', height: '40vp' }))
      }
    }
    .width(Constants.MATCH_PARENT)
    .height('118vp')
    .margin({top:'5vp',bottom:'5vp'})
    .backgroundColor($r('app.color.white'))
    .borderRadius('10vp')
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
        .width('60vp')
        .height('60vp')
        .clip(new Circle({ width: '60vp', height: '60vp' }))

      Column() {
        Text(info.data.title)
          .width(Constants.MATCH_PARENT)
          .margin({left:'10vp'})
          .fontColor($r('app.color.color_333333'))
          .fontSize('20fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.description)
          .width(Constants.MATCH_PARENT)
          .margin({left:'10vp'})
          .fontColor($r('app.color.color_666666'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)

      Text('+关注')
        .margin({left:'5vp'})
        .padding({top:'4vp',bottom:'4vp',left:'10vp',right:'10vp'})
        .fontColor($r('app.color.color_666666'))
        .fontSize('18fp')
        .border({ width: '1vp',color:$r('app.color.color_666666'),radius:'5vp',style:BorderStyle.Solid })
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .margin({top:'5vp',bottom:'5vp'})
    .padding('10vp')
    .borderRadius('10vp')
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