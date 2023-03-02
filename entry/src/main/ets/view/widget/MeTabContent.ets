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
          .width(Constants.FULL_WIDTH)
          .height('188vp')
        Column() {
          Row(){
            Text('Cherry')
              .fontColor($r('app.color.color_333333'))
              .fontSize('22fp')
            Image($r('app.media.ic_me_edit_black'))
              .width('40vp')
              .height('40vp')
          }.margin({top:'60vp',left:'24vp'})

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
          .margin({top:'20vp',left:'24vp'})

          Text('IP属地：广东')
            .fontColor($r('app.color.color_666666'))
            .fontSize('12fp')
            .margin({left:'24vp',top:'36vp'})

          Row() {
            Text('缓存')
              .height(Constants.FULL_HEIGHT)
              .layoutWeight(1)
              .fontSize('12fp')
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
            Divider().vertical(true).height(Constants.FULL_HEIGHT).color($r('app.color.color_666666'))
            Text('收藏')
              .height(Constants.FULL_HEIGHT)
              .layoutWeight(1)
              .fontSize('12fp')
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
            Divider().vertical(true).height(Constants.FULL_HEIGHT).color($r('app.color.color_666666'))
            Text('观看记录')
              .height(Constants.FULL_HEIGHT)
              .layoutWeight(1)
              .fontSize('12fp')
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
          }
          .width(Constants.FULL_WIDTH)
          .height('20vp')
          .margin({top:'30vp'})
        }
        .width(Constants.FULL_WIDTH)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }

      Image($r('app.media.default_img'))
        .width('80vp')
        .height('80vp')
        .border({ width: '2vp' }).borderColor($r('app.color.white'))
        .borderRadius('40vp').borderStyle(BorderStyle.Dashed)
        .margin({'top':'148vp',left:'24vp'})

    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
    .alignContent(Alignment.TopStart)
  }
}