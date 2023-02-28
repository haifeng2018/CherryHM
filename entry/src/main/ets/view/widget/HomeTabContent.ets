import { CategoryInfo } from '../../model/HomeDataModel';
import { Logger } from '../../util/Logger';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct HomeTabContent {

  private listSearch = [
    '中共中央召开党外人士座谈会', '推动构建亚太命运共同体',
    '十九届六中全会精神新闻发布会', '中方邀拜登出席东奥？外交部回应',
    '大连8天215人感染：多为大学生', '胡塞武装突袭美国驻也门大使馆',
    '北交所15日开市 10家企业直接上市', '腾讯与抖音商谈对等开放',
  ]

  @State bgColors: Color[] = [Color.Red, Color.Orange, Color.Yellow, Color.Green, Color.Pink, Color.Grey, Color.Blue, Color.Brown]
  @State result: string = ''
  @State categoryList: Array<CategoryInfo> = [];

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    HttpRequest.url = "https://baobab.kaiyanapp.com/api/v4/categories?udid=cherry&deviceModel=hm"
    HttpRequest.setMethod(http.RequestMethod.GET)

    try {
      let promise  = HttpRequest.request()
      promise.then((data) =>{
        let resultJson = JSON.parse(data.result.toString());
        this.categoryList = resultJson
//        Logger.info('Result:' + data.result);
//        Logger.info('Result:' + data.responseCode);
//        Logger.info('header:' + JSON.stringify(data.header));
//        Logger.info('cookies:' + data.cookies); // 8+
//        Logger.info('header.Content-Type:' + data.header['Content-Type']);
//        Logger.info('header.Status-Line:' + data.header['Status-Line']);
      })
    } catch(err) {

    }
  }

  build() {
    Scroll(this.scroller){
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

        GridRow({
          columns: 2,
          direction: GridRowDirection.Row}){
          ForEach(this.categoryList, (categoryInfo) => {
            GridCol() {
              Column(){
                Image(categoryInfo.bgPicture)
                  .objectFit(ImageFit.Cover)
                  .width(Constants.FULL_WIDTH)
                  .layoutWeight(1)
                Text(categoryInfo.description)
                  .fontSize('18fp')
                  .fontColor($r('app.color.color_accent'))
                  .margin({top:'10vp'})
              }.width("100%").height("256vp")
            }
          })
        }.layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.color_F9F9F9'))
    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
    .scrollBar(BarState.On)  // 滚动条常驻显示
    .scrollBarColor(Color.Gray)  // 滚动条颜色
    .scrollBarWidth(30) // 滚动条宽度
    .edgeEffect(EdgeEffect.None)
  }

}