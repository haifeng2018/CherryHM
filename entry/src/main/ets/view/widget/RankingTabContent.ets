import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: WeeklyRankingTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-热门-周排行、月排行、总排行
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct RankingTabContent {
  @State url: string = "";
  @State followList: Array<VideoInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendRankingRequest()
  }

  sendRankingRequest () {
    HttpRequest.url = this.url
    HttpRequest.setMethod(http.RequestMethod.GET)
    HttpRequest.request({
      onSuccess: (value) => {
        this.followList = value.itemList
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
          ForEach(this.followList, (data) => {
            GridItem() {
              this.listCell(data)
            }.padding({left:'10vp',right:'10vp'})
          })
        }
        .layoutDirection(GridDirection.Column)
        .columnsTemplate('1fr')
        .columnsGap('10vp')
        .rowsGap('20vp')
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
          this.sendRankingRequest()
        }, 1000)
        console.log('onRefreshing test')
      })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder listCell (info: VideoInfo) {
    Column(){
      Image(info.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('256vp')
        .borderRadius({topLeft:'10vp',topRight:'10vp'})

      Row() {
        Image(info.data.author.icon).width('40vp').height('40vp')
          .border({ width: '2vp' }).borderColor($r('app.color.white'))
          .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

        Text(info.data.author.name)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('10vp')
      }
      .padding({left:'10vp',top:'20vp'})

      Text(info.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize('10fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(info.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})
      }.padding({left:'10vp',right:'10vp'})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({bottom:'10vp'})
    .alignItems(HorizontalAlign.Start)
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          playUrl: info.data.playUrl,
          id: info.data.id,
          title: info.data.title,
          description: info.data.description,
          category: info.data.category,
          collectionCount: info.data.consumption.collectionCount,
          shareCount: info.data.consumption.shareCount,
          replyCount: info.data.consumption.replyCount,
        }
      })
    })
  }
}