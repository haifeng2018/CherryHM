import { HomeApi } from '../../api/HomeApi';
import { FollowInfo } from '../../bean/FollowInfo';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: FollowTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-关注
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct FollowTabContent {

  @State followList: Array<FollowInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendFollowRequest()
  }

  sendFollowRequest () {
    HttpRequest.url = HomeApi.FOLLOW
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
          ForEach(this.followList, (followInfo) => {
            GridItem() {
              this.followCell(followInfo)
            }.padding({left:'10vp',right:'10vp'})
          })
        }
        .layoutDirection(GridDirection.Column)
        .columnsTemplate('1fr')
        .columnsGap('10vp')
        .rowsGap('20vp')
        .backgroundColor($r('app.color.color_F9F9F9'))
        .width(Constants.FULL_WIDTH)
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder followCell (followInfo:  FollowInfo) {
    Column(){
      Image(followInfo.data.content.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.FULL_WIDTH)
        .height('256vp')
        .borderRadius({topLeft:'10vp',topRight:'10vp'})

      Row() {
        Image(followInfo.data.content.data.author.icon).width('40vp').height('40vp')
          .border({ width: '2vp' }).borderColor($r('app.color.white'))
          .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

        Text(followInfo.data.content.data.author.name)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('10vp')
      }
      .padding({left:'10vp',top:'20vp'})

      Text(followInfo.data.content.data.description)
        .width(Constants.FULL_WIDTH)
        .textAlign(TextAlign.Start)
        .fontSize('10fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(followInfo.data.content.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(followInfo.data.content.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(followInfo.data.content.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})
      }.padding({left:'10vp',right:'10vp'})
    }
    .width(Constants.FULL_WIDTH)
    .backgroundColor($r('app.color.white'))
    .padding({bottom:'10vp'})
    .alignItems(HorizontalAlign.Start)
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })

  }
}