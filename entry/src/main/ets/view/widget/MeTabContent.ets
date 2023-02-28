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

@Component
export struct MeTabContent {

  build() {
    Stack() {
      Image($r('app.media.img_me_header')).width('100%').height('40%').align(Alignment.Top)

      Column() {
        Stack(){
          Text($r('app.string.tab_me'))
            .width(Constants.FULL_WIDTH)
            .height('56vp')
            .fontSize($r('app.float.fp_20'))
            .fontColor($r('app.color.color_333333'))
            .fontWeight(500)
            .textAlign(TextAlign.Center)
            .backgroundColor($r('app.color.color_primary'))
          Image($r('app.media.ic_share'))
            .width('30vp')
            .height('30vp')
            .align(Alignment.End)
            .margin({right:'24vp'})
        }
        .width(Constants.FULL_WIDTH)
        .backgroundColor($r('app.color.color_primary_dark'))
        .alignContent(Alignment.End)
        .padding({top:'36vp'})

        Text('我的').fontSize('18fp').fontColor($r('app.color.white')).width('100%').height('10%')
          .textAlign(TextAlign.Center).margin({ top: '20vp' })

        Row(){
          Image($r('app.media.default_img')).width('80vp').height('80vp')
            .border({ width: '2vp' }).borderColor($r('app.color.white'))
            .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

          Column(){
            Text('王大锤').fontSize('22fp').fontColor($r('app.color.white')).width('100%')
              .textAlign(TextAlign.Start).margin({ left: '10vp',top:'10vp' })

            Text('I\'m the master of my fate, the captain of my soul.')
              .fontSize('18fp').fontColor($r('app.color.white')).width('100%')
              .layoutWeight(1)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Start).margin({ left: '10vp',right:'10vp',top:'10vp' })

          }.width('80%').height('80vp')

          Image($r('app.media.ic_right_white')).width('50vp').height('50vp')

        }.width('100%').height('10%').alignItems(VerticalAlign.Center).margin({ left: '20vp',top:'20vp' })

      }.width('100%').height('100%').alignItems(HorizontalAlign.Start)

    }.width('100%').height('100%').alignContent(Alignment.Top)
  }
}