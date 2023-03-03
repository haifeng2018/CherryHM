import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: MeTabContent
 * Author: Victor
 * Date: 2023/2/27 15:15
 * Description: 
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct MeTabContent {

  build() {
    Stack() {
      Column() {
        Image($r('app.media.img_me_header_cover'))
          .width(Constants.MATCH_PARENT)
          .height('188vp')
        Column() {
          Row(){
            Text('Cherry')
              .fontColor($r('app.color.color_333333'))
              .fontSize('22fp')
            Image($r('app.media.ic_me_edit_black'))
              .width('40vp')
              .height('40vp')
          }
          .width(Constants.MATCH_PARENT)
          .margin({top:'60vp',left:'24vp'})

          Row(){
            Text('0')
              .fontColor($r('app.color.color_333333'))
              .fontSize('12fp')

            Text('粉丝')
              .fontColor($r('app.color.color_666666'))
              .fontSize('12fp')
              .margin({left:'5vp'})

            Text('0')
              .fontColor($r('app.color.color_333333'))
              .fontSize('12fp')
              .margin({left:'30vp'})

            Text('关注')
              .fontColor($r('app.color.color_666666'))
              .fontSize('12fp')
              .margin({left:'5vp'})

            Text('0')
              .fontColor($r('app.color.color_333333'))
              .fontSize('12fp')
              .margin({left:'30vp'})

            Text('徽章')
              .fontColor($r('app.color.color_666666'))
              .fontSize('12fp')
              .margin({left:'5vp'})
          }
          .width(Constants.MATCH_PARENT)
          .margin({top:'20vp',left:'24vp'})

          Text('IP属地：广东')
            .fontColor($r('app.color.color_666666'))
            .fontSize('12fp')
            .width(Constants.MATCH_PARENT)
            .margin({left:'24vp',top:'36vp'})

          Row() {
            Text('缓存')
              .height(Constants.MATCH_PARENT)
              .layoutWeight(1)
              .fontSize('12fp')
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
            Divider().vertical(true).height(Constants.MATCH_PARENT).color($r('app.color.color_666666'))
            Text('收藏')
              .height(Constants.MATCH_PARENT)
              .layoutWeight(1)
              .fontSize('12fp')
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
            Divider().vertical(true).height(Constants.MATCH_PARENT).color($r('app.color.color_666666'))
            Text('观看记录')
              .height(Constants.MATCH_PARENT)
              .layoutWeight(1)
              .fontSize('12fp')
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
          }
          .width(Constants.MATCH_PARENT)
          .height('20vp')
          .margin({top:'30vp'})

          Image($r('app.media.img_me_no_video'))
            .width('110vp')
            .height('110vp')
            .margin({top:'60vp'})

          Text('暂无作品')
            .fontColor($r('app.color.color_666666'))
            .fontSize('18fp')
            .margin({top:'10vp'})
        }
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
      }

      Image($r('app.media.default_img'))
        .width('80vp')
        .height('80vp')
        .borderRadius('40vp')
        .margin({'top':'148vp',left:'24vp'})

      Row(){
        Blank()
        Image($r('app.media.ic_me_setting'))
          .width('56vp')
          .height('56vp')
          .padding('5vp')
      }
      .padding({top:'36vp',right:'19vp'})
      .width(Constants.MATCH_PARENT)

    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .alignContent(Alignment.TopStart)
  }
}