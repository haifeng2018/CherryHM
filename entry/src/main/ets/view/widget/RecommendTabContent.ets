import { OwnInfo } from '../../bean/OwnInfo';
import { VideoCellHeaderInfo } from '../../bean/VideoCellHeaderInfo';
import { AuthorInfo } from '../../bean/AuthorInfo';
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
      Stack() {
        Image(info.data.content.data.cover.feed)
          .objectFit(ImageFit.Cover)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)
          .borderRadius({topLeft:'10vp',topRight:'10vp'})
          .sharedTransition(`${this.datas.indexOf(info)}${info.data.content.data.id}`, {
            duration: Constants.TRANSITION_ANIMATION_DURATION,
            curve: Curve.Smooth,
            delay: Constants.SHARE_ITEM_ANIMATION_DELAY
          })

        Text(this.getMediaType(info.data.content.type))
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_333333'))
          .fontSize('16fp')
          .backgroundColor($r('app.color.color_4DFFFFFF'))
          .margin({top:'5vp',right:'5vp'})
          .padding({top:'5vp',bottom:'5vp',left:'10vp',right:'10vp'})
          .borderRadius('5vp')
      }
      .width(Constants.MATCH_PARENT)
      .height('198vp')
      .alignContent(Alignment.TopEnd)

      Row() {
        Image(info.data.content.data.owner.avatar).width('40vp').height('40vp')
          .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

        Text(info.data.content.data.owner.nickname)
          .fontColor($r('app.color.color_666666'))
          .fontSize('18fp')
          .padding('10vp')
      }
      .padding({left:'10vp',top:'20vp'})

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(info.data.content.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.content.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.content.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})
      }.padding('10vp')
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      if (info.data.content.type === 'video') {
        info.data.content.data.author = this.getAuthorInfo(info.data.content.data.owner)
        router.pushUrl({
          url: RouterPath.VIDEO_DETAIL_PAGE,
          params: {
            data:info.data.content.data,
            shareId: `${this.datas.indexOf(info)}${info.data.content.data.id}`
          }
        })
      } if (info.data.content.type === 'ugcPicture') {
        router.pushUrl({
          url: RouterPath.POSTER_PAGE,
          params: {
            data: info.data.content.data,
            shareId: `${this.datas.indexOf(info)}${info.data.content.data.id}`
          },
        })
      }
    })
  }

  getMediaType (type): string {
    if (type === 'video') {
      return '视频'
    } else if (type === 'ugcPicture') {
      return '图片'
    }
  }

  getAuthorInfo (owner: OwnInfo): AuthorInfo {
    let author = new AuthorInfo()
    author.icon = owner.avatar
    author.name = owner.nickname
    return author
  }
}