import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoCellData } from '../../bean/VideoCellData';
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
 * Description: 首页-发现-关注
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct FollowTabContent {

  @State datas: Array<VideoInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendFollowRequest()
  }

  sendFollowRequest () {
    HttpRequest.url = DiscoveryApi.FOLLOW
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
          this.sendFollowRequest()
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

  @Builder headCell(info: VideoInfo) {
    Row(){
      Image(info.data.header.icon)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp' })
        .borderColor($r('app.color.white'))
        .borderRadius('40vp')

      Column() {
        Text(info.data.header.title)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('12fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.header.description)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize('10fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({left:'10vp'})

    }
    .width(Constants.MATCH_PARENT)
    .padding('10vp')
  }

  @Builder contentCell (info: VideoInfo) {
    Column(){
      this.headCell(info)
      List({ space: 10 }) {
        ForEach(info.data.itemList, (item) => {
          ListItem() {
            Column(){
              Stack() {
                Image(item.data.cover.feed)
                  .width(Constants.MATCH_PARENT)
                  .height(Constants.MATCH_PARENT)
                  .borderRadius('10vp')

                Text(item.data.category)
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize('16fp')
                  .backgroundColor($r('app.color.color_4DFFFFFF'))
                  .margin({top:'5vp',right:'5vp'})
                  .padding({top:'5vp',bottom:'5vp',left:'10vp',right:'10vp'})
                  .borderRadius('5vp')
              }
              .width(Constants.MATCH_PARENT)
              .height('168vp')
              .alignContent(Alignment.TopEnd)

              Text(item.data.title)
                .width(Constants.MATCH_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_333333'))
                .fontSize('18fp')
                .padding('5vp')

              Text(this.formatReleaseDate(item.data.releaseTime))
                .width(Constants.MATCH_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_666666'))
                .fontSize('18fp')
                .padding({left:'5vp'})
            }
            .width('318vp')
            .padding({bottom:'5vp'})
          }
          .onClick(() => {
            router.pushUrl({
              url: RouterPath.VIDEO_DETAIL_PAGE,
              params: {
                playUrl: item.data.playUrl,
                id: item.data.id,
                title: item.data.title,
                description: item.data.description,
                category: item.data.category,
                collectionCount: item.data.consumption.collectionCount,
                shareCount: item.data.consumption.shareCount,
                replyCount: item.data.consumption.replyCount,
              }
            })
          })
        })
      }.listDirection(Axis.Horizontal)
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .borderRadius('5vp')
    .shadow({ radius: 5, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 10 })
  }

  formatReleaseDate(releaseTime: number): string {
    let releaseDate = new Date(releaseTime)

    let year = releaseDate.getFullYear().toString()
    let month = releaseDate.getMonth().toString()
    let day = releaseDate.getDay().toString()
    let hours = releaseDate.getHours()
    let mins = releaseDate.getMinutes()

    let hoursStr = hours.toString()
    if (hours < 10) {
      hoursStr = "0" + hours
    }

    let minsStr = hours.toString()
    if (mins < 10) {
        minsStr = "0" + mins
    }

    return year + '/' + month + '/' + day + ' ' + hoursStr + ':' + minsStr
  }
}