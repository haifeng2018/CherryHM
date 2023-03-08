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
  private listSearch = [
    '中共中央召开党外人士座谈会', '推动构建亚太命运共同体',
    '十九届六中全会精神新闻发布会', '中方邀拜登出席东奥？外交部回应',
    '大连8天215人感染：多为大学生', '胡塞武装突袭美国驻也门大使馆',
    '北交所15日开市 10家企业直接上市', '腾讯与抖音商谈对等开放',
  ]

  @State result: string = ''
  @State hotKeyWord: Array<string> = [];
  @State datas: Array<VideoInfo> = [];
  @State private historyArr: string[] = ["Text", "Button", "TextField", "Image", "Switch", "Checkbox", "RadioButton", "ProgressBar", "ScrollView"]
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
    Divider().vertical(false).strokeWidth('36vp').color($r('app.color.white')).lineCap(LineCapStyle.Square)
    Row(){
      Stack() {
        Image($r('app.media.ic_search'))
          .width('20vp')
          .height('20vp')
          .margin({left:'10vp'})

        Swiper() {
          ForEach(this.listSearch, item => {
            Text(item)
              .width(Constants.MATCH_PARENT)
              .height('40vp')
              .fontSize('16fp')
              .fontColor($r('app.color.color_666666'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: '28vp',right:'28vp' })
          }, item => item)
        }
        .vertical(true)
        .autoPlay(true)
        .indicator(false)
        .interval(3000)
        .margin({left:'10vp'})
      }
      .alignContent(Alignment.Start)
      .layoutWeight(1)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .borderRadius('20vp')
      .margin({left: '24vp',right:'10vp'})

      Text('取消')
        .fontSize('18fp')
        .fontColor($r('app.color.color_333333'))
        .align(Alignment.End)
        .padding({left:'10vp',right:'24vp'})
        .onClick(() => {
          router.back()
        })
    }
    .width(Constants.MATCH_PARENT)
    .height('56vp')
  }

  @Builder searchHistory() {
    Row() {
      Text('搜索历史')
        .fontColor($r('app.color.color_333333'))
        .fontSize('14fp')
        .padding('10vp')

      Blank()

      Text('清空')
        .fontColor($r('app.color.color_333333'))
        .fontSize('14fp')
        .padding('10vp')
        .onClick((event: ClickEvent) => {
          this.historyArr.splice(0, this.historyArr.length)
          this.historyArr.length = 0
        })
    }
    .width(Constants.MATCH_PARENT)
    .margin({top:'10vp'})
    .padding({left:'14vp',right:'14vp'})

    Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
      if (this.historyArr.length > 0) {
        ForEach(this.historyArr,
          (item: string) => {
            Text(item)
              .height('26vp')
              .fontSize('12fp')
              .borderStyle(BorderStyle.Solid)
              .borderWidth('1vp')
              .borderColor($r('app.color.color_DDDDDD'))
              .borderRadius('13vp')
              .padding({  left: '10vp', right: '10vp' })
              .margin({ top: '10vp', right: '10vp' })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .onClick(() => this.searchAction())
          },
          (item: string) => item.toString()
        )
      }
    }
    .margin({ left: '24vp', right: '24vp' })
  }

  @Builder recommendSearch() {
    Text('推荐搜索')
      .width(Constants.MATCH_PARENT)
      .fontColor($r('app.color.color_333333'))
      .textAlign(TextAlign.Start)
      .fontSize('14fp')
      .padding({left:'24vp'})
      .margin({top:'20vp'})

    Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
      if (this.hotKeyWord.length > 0) {
        ForEach(this.hotKeyWord,
          (item: string) => {
            Text(item)
              .height('26vp')
              .fontSize('12fp')
              .borderStyle(BorderStyle.Solid)
              .borderWidth('1vp')
              .borderColor($r('app.color.color_DDDDDD'))
              .borderRadius('13vp')
              .padding({  left: '10vp', right: '10vp' })
              .margin({ top: '10vp', right: '10vp' })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .onClick(() => this.searchAction())
          },
          (item: string) => item.toString()
        )
      }
    }
    .margin({ left: '24vp',top:'10vp', right: '24vp' })
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
                .borderRadius({topLeft:'10vp',topRight:'10vp'})
              Text(categoryInfo.description)
                .fontSize('18fp')
                .fontColor($r('app.color.color_333333'))
                .padding('10vp')
            }
            .width(Constants.MATCH_PARENT)
            .height("256vp")
            .backgroundColor($r('app.color.white'))
            .borderRadius('10vp')
            .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
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
        this.sendCategoryRequest()
      }, 1000)
      console.log('onRefreshing test')
    })
  }

  searchAction () {
    promptAction.showToast({message:'developing...'})
  }
}