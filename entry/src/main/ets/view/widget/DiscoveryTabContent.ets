import { DiscoveryApi } from '../../api/DiscoveryApi';
import { DiscoveryCellInfo } from '../../bean/DiscoveryCellInfo';
import { DiscoveryInfo } from '../../bean/DiscoveryInfo';
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
 * Description: 首页-日报
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct DailyPaperTabContent {

  @State dailyPagerList: Array<DiscoveryInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendFollowRequest()
  }

  sendFollowRequest () {
    HttpRequest.url = DiscoveryApi.DISCOVERY
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
      Stack(){
        Text($r('app.string.tab_discovery'))
          .width(Constants.FULL_WIDTH)
          .height('56vp')
          .fontSize($r('app.float.fp_20'))
          .fontColor($r('app.color.color_333333'))
          .fontWeight(500)
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.white'))
        Image($r('app.media.ic_share'))
          .width('30vp')
          .height('30vp')
          .align(Alignment.End)
          .margin({right:'24vp'})
      }
      .width(Constants.FULL_WIDTH)
      .backgroundColor($r('app.color.white'))
      .alignContent(Alignment.End)
      .padding({top:'36vp'})

      Refresh({ refreshing: $$this.isRefreshing, offset: 56, friction: 66 }) {
        List({ space: 20 }) {
          ForEach(this.dailyPagerList, (item) => {
            ListItem() {
              if (item.type === 'horizontalScrollCard') {
                this.horizontalScrollCardCell(item)
              } else if (item.type === 'textCard') {
                if (item.data.type === 'header5') {
                  this.textCardCell(item)
                }
                if (item.data.type === 'header7') {
                  this.textCardCell(item)
                }
              } else if (item.type === 'briefCard') {
                if (item.data.iconType === 'square') {
                  this.briefCardCell(item)
                }
                if (item.data.iconType === 'round') {
                  this.authorCardCell(item)
                }
              } else if (item.type === 'columnCardList') {//数据格式问题
                this.columnCardListCell(item)
              }
            }
            .padding({left:'10vp',right:'10vp'})
          })
        }
        .width(Constants.FULL_WIDTH)
        .height(Constants.FULL_HEIGHT)
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
      .width(Constants.FULL_WIDTH)
      .layoutWeight(1)
    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder horizontalScrollCardCell(info: DiscoveryInfo) {
    Swiper() {
      ForEach(info.data.itemList, item => {
        Image(item.data.image)
          .width(Constants.FULL_WIDTH)
          .height('198vp')
          .borderRadius('10vp')
      })
    }
    .cachedCount(info.data.count)
    .index(0)
    .autoPlay(info.data.count > 1)
    .interval(3000)
    .indicator(info.data.count > 1)
    .indicatorStyle({
      bottom:10,size: 20, mask: true,
      color:$r('app.color.color_80FFFFFF'),
      selectedColor:$r('app.color.white')})
    .loop(true)
    .duration(1000)
    .itemSpace(0)
    .curve(Curve.Linear)
  }

  @Builder textCardCell(info: DiscoveryInfo) {
    Text(info.data.text)
      .width(Constants.FULL_WIDTH)
      .height('66vp')
      .fontSize('36fp')
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }

  @Builder briefCardCell(info: DiscoveryInfo) {
    Stack() {
      Image(info.data.icon)
        .width(Constants.FULL_WIDTH)
        .height(Constants.FULL_HEIGHT)
        .borderRadius('10vp')

      Text(info.data.title)
        .width(Constants.FULL_WIDTH)
        .height(Constants.FULL_HEIGHT)
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.color_666666'))
        .fontSize('22fp')
    }
    .width(Constants.FULL_WIDTH)
    .height('198vp')
  }

  @Builder authorCardCell(info: DiscoveryInfo) {
    Row() {

      Image(info.data.icon).width('40vp').height('40vp')
        .border({ width: '2vp' }).borderColor($r('app.color.white'))
        .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

      Text(info.data.title)
        .width(Constants.FULL_WIDTH)
        .height(Constants.FULL_HEIGHT)
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.color_666666'))
        .fontSize('22fp')
        .margin({left:'20vp'})
    }
    .width(Constants.FULL_WIDTH)
    .height('68vp')
    .backgroundColor($r('app.color.white'))
    .padding('10vp')
    .borderRadius('10vp')
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }

  @Builder columnCardListCell(info: DiscoveryInfo) {
     List({ space: 10 }) {
        ForEach(info.data.itemList, (item) => {
          ListItem() {
            Stack() {
              Image(item.data.image)
                .width(Constants.FULL_WIDTH)
                .height(Constants.FULL_HEIGHT)
                .borderRadius('10vp')

              Text(item.data.title)
                .width(Constants.FULL_WIDTH)
                .height(Constants.FULL_HEIGHT)
                .textAlign(TextAlign.Center)
                .fontColor($r('app.color.white'))
                .fontSize('18fp')
            }
            .width('128vp')
            .aspectRatio(1.5)
            .margin({ right: 15 })
          }
        })
     }.listDirection(Axis.Horizontal)
  }
}