import Constants from '../util/Constants';
import router from '@ohos.router';
import web_webview from '@ohos.web.webview'

@Entry
@Component
struct WebPage {

  title: string = router.getParams()?.['title'];
  url: string = router.getParams()?.['url'];

  onPageHide() {
    router.clear()
  }

  controller: web_webview.WebviewController = new web_webview.WebviewController()

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
    Row(){
      Image($r('app.media.ic_back'))
        .width('30vp')
        .height('30vp')
        .objectFit(ImageFit.Contain)
        .margin({left:'14vp'})
        .onClick(() =>{
          router.back()
        })

      Text(this.title)
        .height('56vp')
        .layoutWeight(1)
        .fontSize($r('app.float.fp_24'))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(500)
        .textAlign(TextAlign.Center)

      Image($r('app.media.ic_copy_link_grey'))
        .width('40vp')
        .height('40vp')
        .margin({right:'24vp'})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({top:$r('app.float.status_bar_height')})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }
}