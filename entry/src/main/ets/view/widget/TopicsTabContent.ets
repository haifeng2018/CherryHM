import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import { DiscoveryApi } from '../../api/DiscoveryApi';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
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

  // @ts-ignore
  @State datas: Array<VideoInfo> = [];
  @State isRefreshing: boolean = false

  aboutToAppear() {
    this.sendTopicsRequest()
  }

  sendTopicsRequest () {
    HttpRequest.url = DiscoveryApi.TOPICS
    HttpRequest.setMethod(http.RequestMethod.GET)
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
    Column() {
      Refresh({ refreshing: $$this.isRefreshing, offset: 56, friction: 66 }) {
        List() {
          ForEach(this.datas, (item) => {
            ListItem() {
                this.contentCell(item)
            }
          })
        }
        .backgroundColor($r('app.color.color_F9F9F9'))
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        refreshStatus
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
          this.sendTopicsRequest()
        }, 1000)
        console.log('onRefreshing test')
      })
      .width(Constants.MATCH_PARENT)
      .layoutWeight(1)
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder contentCell (info: VideoInfo) {
    Image(info.data.image)
      .objectFit(ImageFit.Cover)
      .width(Constants.MATCH_PARENT)
      .height('256vp')
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