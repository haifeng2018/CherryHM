import { DailyPagerInfo } from '../../bean/DailyPagerInfo';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HomeApi from '../../api/HomeApi';
import HttpRequest from '../../util/HttpRequest';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DailyPaperTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-日报
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct DailyPaperTabContent {

  @State dailyPagerList: Array<DailyPagerInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendFollowRequest()
  }

  sendFollowRequest () {
    HttpRequest.url = HomeApi.DAILY_PAPER
    HttpRequest.setMethod(http.RequestMethod.GET)
    HttpRequest.request({
      onSuccess: (value) => {
        this.dailyPagerList = value.itemList
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
          ForEach(this.dailyPagerList, (item) => {
            ListItem() {
              if (item.type === 'textCard') {
                this.headCell(item)
              } else {
                this.contentCell(item)
              }
            }
            .padding({left:'10vp',right:'10vp'})
          })
        }
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

  @Builder headCell(dailyPagerInfo:  DailyPagerInfo) {
    Text(dailyPagerInfo.data.text)
      .width(Constants.FULL_WIDTH)
      .height('66vp').fontSize('36fp')
      .textAlign(TextAlign.Center)
      .fontColor($r('app.color.color_666666'))
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }

  @Builder contentCell (dailyPagerInfo:  DailyPagerInfo) {
    Column(){
      Image(dailyPagerInfo.data.content.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.FULL_WIDTH)
        .height('256vp')
        .borderRadius({topLeft:'10vp',topRight:'10vp'})

      Row() {
        Image(dailyPagerInfo.data.content.data.author.icon).width('40vp').height('40vp')
          .border({ width: '2vp' }).borderColor($r('app.color.white'))
          .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

        Text(dailyPagerInfo.data.content.data.author.name)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('10vp')
      }
      .padding({left:'10vp',top:'20vp'})

      Text(dailyPagerInfo.data.content.data.description)
        .width(Constants.FULL_WIDTH)
        .textAlign(TextAlign.Start)
        .fontSize('10fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(dailyPagerInfo.data.content.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(dailyPagerInfo.data.content.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(dailyPagerInfo.data.content.data.consumption.shareCount.toString())
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