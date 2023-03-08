import { VideoInfo } from '../../bean/VideoInfo';
import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { DiscoveryApi } from '../../api/DiscoveryApi';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
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

  @State datas: Array<VideoInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendNewsRequest()
  }

  sendNewsRequest () {
    HttpRequest.url = DiscoveryApi.NEWS
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
          this.sendNewsRequest()
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

  @Builder headCell(dailyPagerInfo: VideoInfo) {
    Text(dailyPagerInfo.data.text)
      .width(Constants.MATCH_PARENT)
      .height('36vp').fontSize('28fp')
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
            .borderRadius({topLeft:'10vp',bottomLeft:'10vp'})
        })
      }
      .width('128vp')
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
        .fontSize('16fp')
        .fontColor($r('app.color.color_999999'))
        .lineHeight('28vp')
        .maxLines(5)
        .margin({left:'10vp',right:'10vp'})
    }
    .width(Constants.MATCH_PARENT)
    .height('168vp')
    .backgroundColor($r('app.color.white'))
    .borderRadius('10vp')
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }

}