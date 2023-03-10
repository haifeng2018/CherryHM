import { VideoCellContentData } from '../bean/VideoCellContentData';
import Constants from '../util/Constants';
import router from '@ohos.router';
@Entry
@Component
struct PosterPage {
  @State data: VideoCellContentData = router.getParams()?.['data'];
  @State shareId: string = router.getParams()?.['shareId'];

  onPageHide() {
    router.clear()
  }

  build() {
      Column() {
        this.titleBar()

        Image(this.data.url)
          .width(Constants.MATCH_PARENT)
          .layoutWeight(1)
          .objectFit(ImageFit.Cover)
          .sharedTransition(this.shareId, {
            duration: Constants.TRANSITION_ANIMATION_DURATION,
            curve: Curve.Smooth,
            delay: Constants.SHARE_ITEM_ANIMATION_DELAY
          })
      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder titleBar() {
    Row(){
      Image($r('app.media.ic_back'))
        .width('30vp')
        .height('30vp')
        .objectFit(ImageFit.Contain)
        .margin({left:'14vp'})
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
        .height('56vp')
        .layoutWeight(1)
        .fontSize($r('app.float.fp_24'))
        .fontColor($r('app.color.color_333333'))
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

      Image($r('app.media.ic_share'))
        .width('30vp')
        .height('30vp')
        .align(Alignment.End)
        .margin({right:'24vp'})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({top:$r('app.float.status_bar_height')})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }

}