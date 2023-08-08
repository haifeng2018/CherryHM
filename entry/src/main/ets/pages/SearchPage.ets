import { searchHistory } from '../model/SearchPageModel';
import { hotSearchKeys } from '../model/SearchPageModel';
import { VideoInfo } from '../bean/VideoInfo';
import router from '@ohos.router';
import { HomeApi } from '../api/HomeApi';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../util/Constants';
import HttpRequest from '../util/HttpRequest';

/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: SearchPage
 * Author: Victor
 * Date: 2023/3/1 16:31
 * Description: 
 * -----------------------------------------------------------------
 */

@Entry
@Component
struct SearchPage {
  @State result: string = ''
  @State hotKeyWord: Array<string> = [];
  @State datas: Array<VideoInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendCategoryRequest()
  }

  sendCategoryRequest () {
    HttpRequest.url = HomeApi.HOT_KEYWORD
    HttpRequest.setMethod(http.RequestMethod.GET)
    HttpRequest.request({
      onSuccess: (value) => {
        this.hotKeyWord = value
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    Column() {
     this.titleBar()
     this.searchHistory()
     this.recommendSearch()
     this.searchResult()
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
  }

  @Builder titleBar() {
    Divider().vertical(false)
      .strokeWidth('30vp')
      .color($r('app.color.white'))
      .lineCap(LineCapStyle.Square)

    Row(){
      Stack() {
        Image($r('app.media.ic_search'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))
          .margin({left:$r('app.float.vp_10')})

        Swiper() {
          ForEach(hotSearchKeys, item => {
            Text(item)
              .width(Constants.MATCH_PARENT)
              .height($r('app.float.vp_40'))
              .fontSize($r('app.float.fp_16'))
              .fontColor($r('app.color.color_666666'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: $r('app.float.vp_28'),right:$r('app.float.vp_28') })
          }, item => item)
        }
        .vertical(true)
        .autoPlay(true)
        .indicator(false)
        .interval(3000)
        .margin({left:$r('app.float.vp_10')})
      }
      .alignContent(Alignment.Start)
      .layoutWeight(1)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .borderRadius($r('app.float.vp_20'))
      .margin({left: $r('app.float.vp_24'),right:$r('app.float.vp_10')})

      Text($r('app.string.cancel'))
        .fontSize($r('app.float.fp_20'))
        .fontColor($r('app.color.color_333333'))
        .align(Alignment.End)
        .padding({left:$r('app.float.vp_10'),right:$r('app.float.vp_24')})
        .onClick(() => {
          router.back()
        })
    }
    .width(Constants.MATCH_PARENT)
    .height($r('app.float.vp_56'))
  }

  @Builder searchHistory() {
    Row() {
      Text($r('app.string.search_history'))
        .fontColor($r('app.color.color_333333'))
        .fontSize($r('app.float.fp_14'))
        .padding($r('app.float.vp_10'))

      Blank()

      Text($r('app.string.clear'))
        .fontColor($r('app.color.color_333333'))
        .fontSize($r('app.float.fp_14'))
        .padding($r('app.float.vp_10'))
        .onClick((event: ClickEvent) => {
          searchHistory.splice(0, searchHistory.length)
          searchHistory.length = 0
        })
    }
    .width(Constants.MATCH_PARENT)
    .margin({top:$r('app.float.vp_10')})
    .padding({left:$r('app.float.vp_14'),right:$r('app.float.vp_14')})

    Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
      if (searchHistory.length > 0) {
        ForEach(searchHistory,
          (item: string) => {
            Text(item)
              .height($r('app.float.vp_26'))
              .fontSize($r('app.float.fp_12'))
              .borderStyle(BorderStyle.Solid)
              .borderWidth($r('app.float.vp_1'))
              .borderColor($r('app.color.color_DDDDDD'))
              .borderRadius($r('app.float.vp_13'))
              .padding({  left: $r('app.float.vp_10'), right: $r('app.float.vp_10') })
              .margin({ top: $r('app.float.vp_10'), right: $r('app.float.vp_10') })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .onClick(() => this.searchAction())
          },
          (item: string) => item.toString()
        )
      }
    }
    .margin({ left: $r('app.float.vp_24'), right: $r('app.float.vp_24') })
  }

  @Builder recommendSearch() {
    Text($r('app.string.recommend_search'))
      .width(Constants.MATCH_PARENT)
      .fontColor($r('app.color.color_333333'))
      .textAlign(TextAlign.Start)
      .fontSize($r('app.float.vp_14'))
      .padding({left:$r('app.float.vp_24')})
      .margin({top:$r('app.float.vp_20')})

    Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
      if (this.hotKeyWord.length > 0) {
        ForEach(this.hotKeyWord,
          (item: string) => {
            Text(item)
              .height($r('app.float.vp_26'))
              .fontSize($r('app.float.fp_12'))
              .borderStyle(BorderStyle.Solid)
              .borderWidth($r('app.float.vp_1'))
              .borderColor($r('app.color.color_DDDDDD'))
              .borderRadius($r('app.float.vp_13'))
              .padding({  left: $r('app.float.vp_10'), right: $r('app.float.vp_10') })
              .margin({ top: $r('app.float.vp_10'), right: $r('app.float.vp_10') })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .onClick(() => this.searchAction())
          },
          (item: string) => item.toString()
        )
      }
    }
    .margin({ left: $r('app.float.vp_24'),top:$r('app.float.vp_10'), right: $r('app.float.vp_10') })
  }

  @Builder searchResult() {
    Refresh({ refreshing: this.isRefreshing, offset: 56, friction: 66 }) {
      Grid(this.scroller) {
        ForEach(this.datas, (categoryInfo) => {
          GridItem() {
            Column(){
              Image(categoryInfo.bgPicture)
                .objectFit(ImageFit.Cover)
                .width(Constants.MATCH_PARENT)
                .layoutWeight(1)
                .borderRadius({
                  topLeft:$r('app.float.vp_10'),
                  topRight:$r('app.float.vp_10')
                })
              Text(categoryInfo.description)
                .fontSize($r('app.float.fp_18'))
                .fontColor($r('app.color.color_333333'))
                .padding($r('app.float.vp_10'))
            }
            .width(Constants.MATCH_PARENT)
            .height($r('app.float.vp_256'))
            .backgroundColor($r('app.color.white'))
            .borderRadius($r('app.float.vp_10'))
            .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
          }
        })
      }
      .layoutDirection(GridDirection.Column)
      .columnsTemplate('1fr 1fr')
      .columnsGap($r('app.float.vp_10'))
      .rowsGap($r('app.float.vp_10'))
      .backgroundColor($r('app.color.color_F9F9F9'))
      .width(Constants.MATCH_PARENT)
      .layoutWeight(1)
      .padding($r('app.float.vp_10'))
    }
    .onStateChange((refreshStatus: RefreshStatus) => {
      refreshStatus
      console.info('Refresh onStatueChange state is ' + refreshStatus)
    })
    .onRefreshing(() => {
      setTimeout(() => {
        this.isRefreshing = false
        this.sendCategoryRequest()
      }, 1000)
      console.log('onRefreshing test')
    })
  }

  searchAction () {
    promptAction.showToast({message:'developing...'})
  }
}