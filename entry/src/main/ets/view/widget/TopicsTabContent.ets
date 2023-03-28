import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import RouterPath from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import { CommunityApi } from '../../api/CommunityApi';
import promptAction from '@ohos.promptAction';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
import { PageState } from './refresh/PageState';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DailyPaperTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-发现-专题
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct TopicsTabContent {

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = CommunityApi.TOPICS

  sendTopicsRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === CommunityApi.TOPICS) {
          this.datas = value.itemList
        } else {
          this.datas = this.datas.concat(value.itemList);
        }
        this.nextPageUrl = value.nextPageUrl
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  aboutToAppear() {
    this.sendTopicsRequest()
  }

  refreshData () {
    this.nextPageUrl = CommunityApi.TOPICS
    this.sendTopicsRequest()
  }

  loadMoreData () {
    this.sendTopicsRequest()
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

  @Builder itemLayout (info: VideoInfo) {
    Image(info.data.image)
      .objectFit(ImageFit.Cover)
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_256'))
      .sharedTransition(`${this.datas.indexOf(info)}${info.data.id}`, {
        duration: Constants.TRANSITION_ANIMATION_DURATION,
        curve: Curve.Smooth,
        delay: Constants.SHARE_ITEM_ANIMATION_DELAY
      })
      .onClick(() => {
        router.pushUrl({
          url: RouterPath.LIGHT_TOPICS_PAGE,
          params: {
            topicId: info.data.id,
            shareId: `${this.datas.indexOf(info)}${info.data.id}`
          }
        })
      })
  }
}