import promptAction from '@ohos.promptAction';
import { CategoryInfo } from '../model/HomeDataModel';
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

  @State bgColors: Color[] = [Color.Red, Color.Orange, Color.Yellow, Color.Green, Color.Pink, Color.Grey, Color.Blue, Color.Brown]
  @State result: string = ''
  @State categoryList: Array<CategoryInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendCategoryRequest()
  }

  sendCategoryRequest () {
    HttpRequest.url = "https://baobab.kaiyanapp.com/api/v4/categories?udid=cherry&deviceModel=hm"
    HttpRequest.setMethod(http.RequestMethod.GET)
    HttpRequest.request({
      onSuccess: (value) => {
        this.categoryList = value
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    Column() {
      Divider().vertical(false).strokeWidth('36vp').color($r('app.color.color_primary_dark')).lineCap(LineCapStyle.Square)
      Row(){
        Stack() {
          Image($r('app.media.ic_search'))
            .width('20vp')
            .height('20vp')
            .margin({left:'10vp'})

          Swiper() {
            ForEach(this.listSearch, item => {
              Text(item)
                .width(Constants.FULL_WIDTH)
                .height('40vp')
                .fontSize('16fp')
                .fontColor($r('app.color.color_666666'))
                .margin({ left: '30vp' })
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

        Image($r('app.media.ic_share'))
          .width('30vp')
          .height('30vp')
          .align(Alignment.End)
          .margin({right:'24vp'})
      }
      .width(Constants.FULL_WIDTH)
      .height('56vp')
      .backgroundColor($r('app.color.color_primary'))

      Refresh({ refreshing: $$this.isRefreshing, offset: 56, friction: 66 }) {
        Grid(this.scroller) {
          ForEach(this.categoryList, (categoryInfo) => {
            GridItem() {
              Column(){
                Image(categoryInfo.bgPicture)
                  .objectFit(ImageFit.Cover)
                  .width(Constants.FULL_WIDTH)
                  .layoutWeight(1)
                  .borderRadius({topLeft:'10vp',topRight:'10vp'})
                Text(categoryInfo.description)
                  .fontSize('18fp')
                  .fontColor($r('app.color.color_333333'))
                  .padding('10vp')
              }
              .width("100%")
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
        .width(Constants.FULL_WIDTH)
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
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.color_F9F9F9'))
  }
}