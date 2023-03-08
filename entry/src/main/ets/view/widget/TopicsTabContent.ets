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

  scroller: Scroller = new Scroller()

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
        List({ space: 20 }) {
          ForEach(this.datas, (item) => {
            ListItem() {
                this.contentCell(item)
            }
            .padding({left:'10vp',right:'10vp'})
          })
        }
        .backgroundColor($r('app.color.color_F9F9F9'))
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
        .padding({top:'10vp',bottom:'10vp'})
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
      .borderRadius('10vp')
      .width(Constants.MATCH_PARENT)
      .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
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