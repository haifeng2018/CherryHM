import Constants from '../util/Constants';
import router from '@ohos.router';
@Entry
@Component
struct WebPage {
  title: string = router.getParams()?.['title'];
  url: string = router.getParams()?.['url'];

  onPageHide() {
    router.clear()
  }

  controller:WebController = new WebController();

  build() {
      Column() {
        this.titleBar()

        Web({ src:this.url, controller:this.controller })
          .width(Constants.MATCH_PARENT)
          .layoutWeight(1)
      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder titleBar() {
    Stack(){
      Text(this.title)
        .width(Constants.MATCH_PARENT)
        .height('30vp')
        .fontSize($r('app.float.fp_24'))
        .fontColor($r('app.color.color_333333'))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.white'))

      Image($r('app.media.ic_back'))
        .width('30vp')
        .height('30vp')
        .objectFit(ImageFit.Contain)
        .margin({left:'14vp'})
        .onClick(() =>{
          router.back()
        })
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignContent(Alignment.BottomStart)
    .padding({top:$r('app.float.status_bar_height'),bottom:'5vp'})
  }
}