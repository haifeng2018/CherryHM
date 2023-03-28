import RouterPath from '../util/RouterPath';
import { VideoCellContentData } from '../bean/VideoCellContentData';
import Constants from '../util/Constants';
import router from '@ohos.router';
@Entry
@Component
struct PosterPage {
  @State data: VideoCellContentData = router.getParams()?.[Constants.DATA];
  @State shareId: string = router.getParams()?.[Constants.SHARE_ID];

  onPageHide() {
    router.clear()
  }

  build() {
      Column() {
        this.titleBar()

        Image(this.data.url)
          .width(Constants.MATCH_PARENT)
          .layoutWeight(1)
          .objectFit(ImageFit.Contain)
          .sharedTransition(this.shareId, {
            duration: Constants.TRANSITION_ANIMATION_DURATION,
            curve: Curve.Smooth,
            delay: Constants.SHARE_ITEM_ANIMATION_DELAY
          })

        this.authorLayout()
      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.black'))
  }

  @Builder titleBar() {
    Row(){
      Image($r('app.media.ic_back_white'))
        .width($r('app.float.vp_30'))
        .height($r('app.float.vp_30'))
        .objectFit(ImageFit.Contain)
        .margin({left:$r('app.float.vp_14')})
        .onClick(() =>{
          router.back()
        })

      Marquee({
        start: true,
        step: 20,
        loop: Infinity,
        fromStart: true,
        src: this.data.description
      })
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_56'))
        .layoutWeight(1)
        .fontSize($r('app.float.fp_24'))
        .fontColor($r('app.color.white'))
        .fontWeight(500)
        .onStart(() => {
          console.info('Marquee animation complete onStart')
        })
        .onBounce(() => {
          console.info('Marquee animation complete onBounce')
        })
        .onFinish(() => {
          console.info('Marquee animation complete onFinish')
        })

      Image($r('app.media.ic_share_white'))
        .width($r('app.float.vp_30'))
        .height($r('app.float.vp_30'))
        .align(Alignment.End)
        .margin({right:$r('app.float.vp_24')})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_B3000000'))
    .padding({top:$r('app.float.status_bar_height')})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }

  @Builder authorLayout () {
    Column() {
      Row() {
        Image(this.data.owner.avatar)
          .width($r('app.float.vp_60'))
          .height($r('app.float.vp_60'))
          .clip(new Circle({ width: '60vp', height: '60vp' }))

        Column() {
          Text(this.data.owner.nickname)
            .width(Constants.MATCH_PARENT)
            .fontColor($r('app.color.white'))
            .fontSize($r('app.float.fp_20'))
            .padding($r('app.float.vp_2'))
            .textAlign(TextAlign.Start)

          Text(this.data.owner.country + this.data.owner.city)
            .width(Constants.MATCH_PARENT)
            .fontColor($r('app.color.color_DDDDDD'))
            .fontSize($r('app.float.fp_18'))
            .padding($r('app.float.vp_2'))
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .padding({left:$r('app.float.vp_10')})

        Text($r('app.string.private_chat'))
          .padding({
            top:$r('app.float.vp_6'),
            bottom:$r('app.float.vp_6'),
            left:$r('app.float.vp_15'),
            right:$r('app.float.vp_15')
          })
          .fontColor($r('app.color.white'))
          .fontSize($r('app.float.fp_18'))
          .backgroundColor($r('app.color.color_0091FF'))
          .borderRadius($r('app.float.vp_5'))

        Text($r('app.string.add_follow'))
          .margin({left:$r('app.float.vp_10')})
          .padding({
            top:$r('app.float.vp_4'),
            bottom:$r('app.float.vp_4'),
            left:$r('app.float.vp_10'),
            right:$r('app.float.vp_10')
          })
          .fontColor($r('app.color.white'))
          .fontSize($r('app.float.fp_18'))
          .border({
            width: $r('app.float.vp_2'),
            color:$r('app.color.white'),
            radius:$r('app.float.vp_5'),
            style:BorderStyle.Solid
          })
      }
      .width(Constants.MATCH_PARENT)

      Text(this.data.owner.description)
        .width(Constants.MATCH_PARENT)
        .fontColor($r('app.color.color_DDDDDD'))
        .fontSize($r('app.float.fp_18'))
        .padding($r('app.float.vp_2'))
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Image($r('app.media.ic_video_likes'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))

        Text(this.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_16'))
          .margin({left:$r('app.float.vp_5')})

        Image($r('app.media.ic_video_comment'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))
          .margin({left:$r('app.float.vp_30')})

        Text(this.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_16'))
          .margin({left:$r('app.float.vp_5')})

        Image($r('app.media.ic_video_share'))
          .width($r('app.float.vp_20'))
          .height($r('app.float.vp_20'))
          .margin({left:$r('app.float.vp_30')
          })

        Text(this.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_16'))
          .margin({left:$r('app.float.vp_5')})
      }
      .width(Constants.MATCH_PARENT)
      .justifyContent(FlexAlign.End)
      .padding({left:$r('app.float.vp_10'),right:$r('app.float.vp_10')})

      Text()
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_1'))
        .margin({top:$r('app.float.vp_10')})
        .backgroundColor($r('app.color.color_80DDDDDD'))
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_B3000000'))
    .padding($r('app.float.vp_10'))
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.USER_PAGE,
        params: {
          userId:this.data.owner.uid,
        }
      })
    })
  }
}