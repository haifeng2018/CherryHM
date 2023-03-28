import RouterPath from '../../util/RouterPath';
import router from '@ohos.router';
import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import { VideoInfo } from '../../bean/VideoInfo';
import { CommunityApi } from '../../api/CommunityApi';
import promptAction from '@ohos.promptAction';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
import UrlUtil from '../../util/UrlUtil';
import { PageState } from './refresh/PageState';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: NewsTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-发现-资讯
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct NewsTabContent {

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = CommunityApi.NEWS

  sendNewsRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === CommunityApi.NEWS) {
          this.datas = value.itemList
        } else {
          this.datas = this.datas.concat(value.itemList);
        }
        this.nextPageUrl = value.nextPageUrl + CommunityApi.NEWS_AUTH
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  aboutToAppear() {
    this.sendNewsRequest()
  }

  refreshData () {
    this.nextPageUrl = CommunityApi.NEWS
    this.sendNewsRequest()
  }

  loadMoreData () {
    this.sendNewsRequest()
  }

  build() {
    LMList({
      itemLayout: (data) => this.itemLayout(data),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder itemLayout (data: VideoInfo) {
    if (data.type === 'textCard') {
      this.headCell(data)
    } else {
      this.contentCell(data)
    }
  }

  @Builder headCell(dailyPagerInfo: VideoInfo) {
    Text(dailyPagerInfo.data.text)
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_56'))
      .fontSize($r('app.float.fp_28'))
      .textAlign(TextAlign.Center)
      .fontColor($r('app.color.color_666666'))
  }

  @Builder contentCell (info: VideoInfo) {
    Row(){
      Swiper() {
        ForEach(info.data.bannerList, item => {
          Image(item.poster_image)
            .width(Constants.MATCH_PARENT)
            .height(Constants.MATCH_PARENT)
        })
      }
      .width($r('app.float.vp_128'))
      .height(Constants.MATCH_PARENT)
      .cachedCount(info.data.bannerList.length)
      .index(0)
      .autoPlay(info.data.bannerList.length > 1)
      .interval(3000)
      .indicator(info.data.bannerList.length > 1)
      .indicatorStyle({
        bottom:10,size: 20, mask: true,
        color:$r('app.color.color_80FFFFFF'),
        selectedColor:$r('app.color.white')})
      .loop(true)
      .duration(1000)
      .itemSpace(0)
      .curve(Curve.Linear)

      Text(info.data.titleList.toString())
        .height(Constants.MATCH_PARENT)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.fp_16'))
        .fontColor($r('app.color.color_999999'))
        .lineHeight($r('app.float.vp_28'))
        .maxLines(5)
        .margin({
          left:$r('app.float.vp_10'),
          right:$r('app.float.vp_10')
        })
    }
    .width(Constants.MATCH_PARENT)
    .height($r('app.float.vp_168'))
    .backgroundColor($r('app.color.white'))
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.WEB_PAGE,
        params: {
          title: UrlUtil.getTitle(info.data.actionUrl),
          url: UrlUtil.getUrl(info.data.actionUrl),
        },
      })
    })
  }
}