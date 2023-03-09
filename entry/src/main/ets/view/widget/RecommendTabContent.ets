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
 * File: MonthlyRankingTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-发现-推荐
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct RecommendTabContent {

  @State datas: Array<VideoInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendRecommendRequest()
  }

  sendRecommendRequest () {
    HttpRequest.url = DiscoveryApi.RECOMMEND
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
        Grid(this.scroller) {
          ForEach(this.datas, (data) => {
            GridItem() {
               if (data.type === 'communityColumnsCard') {
                 this.gridCell(data)
               }
            }
          })
        }
        .layoutDirection(GridDirection.Column)
        .columnsTemplate('1fr 1fr')
        .columnsGap('10vp')
        .rowsGap('10vp')
        .backgroundColor($r('app.color.color_F9F9F9'))
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
        .padding('10vp')
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        refreshStatus
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
          this.sendRecommendRequest()
        }, 1000)
        console.log('onRefreshing test')
      })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder gridCell (info: VideoInfo) {
    Column(){
      Image(info.data.content.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('198vp')
        .borderRadius({topLeft:'10vp',topRight:'10vp'})
        .sharedTransition(Constants.POSTER_DETAIL_TRANSITION_ID, {
          duration: Constants.TRANSITION_ANIMATION_DURATION,
          curve: Curve.Smooth,
          delay: Constants.SHARE_ITEM_ANIMATION_DELAY
        })

      Row() {
        Image(info.data.content.data.owner.avatar).width('40vp').height('40vp')
          .border({ width: '2vp' }).borderColor($r('app.color.white'))
          .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

        Text(info.data.content.data.owner.nickname)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('10vp')
      }
      .padding({left:'10vp',top:'20vp'})

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(info.data.content.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.content.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.content.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})
      }.padding('10vp')
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      if (info.data.content.type === 'video') {
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
      } if (info.data.content.type === 'ugcPicture') {
        router.pushUrl({
          url: RouterPath.POSTER_PAGE,
          params: {
            description: info.data.content.data.description,
            url: info.data.content.data.url,
          },
        })
      }
    })
  }
}