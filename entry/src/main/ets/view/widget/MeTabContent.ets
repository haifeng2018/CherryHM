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
          .height($r('app.float.vp_188'))

        Column() {
          Row(){
            Text('Cherry')
              .fontColor($r('app.color.color_333333'))
              .fontSize($r('app.float.fp_22'))

            Image($r('app.media.ic_me_edit_black'))
              .width($r('app.float.vp_40'))
              .height($r('app.float.vp_40'))
          }
          .width(Constants.MATCH_PARENT)
          .margin({top:$r('app.float.vp_60'),left:$r('app.float.vp_24')})

          Row(){
            Text('0')
              .fontColor($r('app.color.color_333333'))
              .fontSize($r('app.float.fp_12'))

            Text($r('app.string.follower'))
              .fontColor($r('app.color.color_666666'))
              .fontSize($r('app.float.fp_12'))
              .margin({left:$r('app.float.vp_5')})

            Text('0')
              .fontColor($r('app.color.color_333333'))
              .fontSize($r('app.float.fp_12'))
              .margin({left:$r('app.float.vp_30')})

            Text($r('app.string.follow'))
              .fontColor($r('app.color.color_666666'))
              .fontSize($r('app.float.fp_12'))
              .margin({left:$r('app.float.vp_50')})

            Text('0')
              .fontColor($r('app.color.color_333333'))
              .fontSize($r('app.float.fp_12'))
              .margin({left:$r('app.float.vp_30')})

            Text($r('app.string.badge'))
              .fontColor($r('app.color.color_666666'))
              .fontSize($r('app.float.fp_12'))
              .margin({left:$r('app.float.vp_5')})
          }
          .width(Constants.MATCH_PARENT)
          .margin({top:$r('app.float.vp_20'),left:$r('app.float.vp_24')})

          Text($r('app.string.ip_addr'))
            .fontColor($r('app.color.color_666666'))
            .fontSize($r('app.float.fp_12'))
            .width(Constants.MATCH_PARENT)
            .margin({
              left:$r('app.float.vp_24'),
              top:$r('app.float.vp_36')
            })

          Row() {

            Text($r('app.string.cache'))
              .height(Constants.MATCH_PARENT)
              .layoutWeight(1)
              .fontSize($r('app.float.fp_12'))
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)

            Divider().vertical(true).height(Constants.MATCH_PARENT).color($r('app.color.color_666666'))

            Text($r('app.string.collection'))
              .height(Constants.MATCH_PARENT)
              .layoutWeight(1)
              .fontSize($r('app.float.fp_12'))
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)

            Divider().vertical(true).height(Constants.MATCH_PARENT).color($r('app.color.color_666666'))

            Text($r('app.string.watch_history'))
              .height(Constants.MATCH_PARENT)
              .layoutWeight(1)
              .fontSize($r('app.float.fp_12'))
              .fontColor($r('app.color.color_666666'))
              .textAlign(TextAlign.Center)
          }
          .width(Constants.MATCH_PARENT)
          .height($r('app.float.vp_20'))
          .margin({top:$r('app.float.vp_30')})

          Image($r('app.media.img_me_no_video'))
            .width($r('app.float.vp_110'))
            .height($r('app.float.vp_110'))
            .margin({top:$r('app.float.vp_60')})

          Text($r('app.string.no_video'))
            .fontColor($r('app.color.color_666666'))
            .fontSize($r('app.float.fp_18'))
            .margin({top:$r('app.float.vp_10')})
        }
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
      }

      Image($r('app.media.default_img'))
        .width($r('app.float.vp_80'))
        .height($r('app.float.vp_80'))
        .objectFit(ImageFit.Cover)
        .margin({'top':$r('app.float.vp_148'),left:$r('app.float.vp_24')})
        .clip(new Circle({ width: '80vp', height: '80vp' }))
        .border({
          width: $r('app.float.vp_2'),
          color:$r('app.color.white'),
          radius:$r('app.float.vp_40'),
          style:BorderStyle.Solid
        })

      Row(){
        Blank()

        Image($r('app.media.ic_me_setting'))
          .width($r('app.float.vp_56'))
          .height($r('app.float.vp_56'))
          .padding($r('app.float.vp_5'))
      }
      .padding({top:$r('app.float.vp_36'),right:$r('app.float.vp_20')})
      .width(Constants.MATCH_PARENT)

    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .alignContent(Alignment.TopStart)
  }
}