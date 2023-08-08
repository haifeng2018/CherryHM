import Constants from '../util/Constants';
import router from '@ohos.router';
import web_webview from '@ohos.web.webview'

@Entry
@Component
struct WebPage {

  title: string = router.getParams()?.[Constants.TITLE];
  url: string = router.getParams()?.[Constants.URL];

  @State progress: number = 0;

  controller: web_webview.WebviewController = new web_webview.WebviewController()

  build() {
      Column() {
        this.titleBar()
        Progress({value: this.progress, total: 100})
          .width(Constants.MATCH_PARENT)
          .height($r('app.float.vp_2'))
          .color($r('app.color.color_accent'))
          .visibility(this.progress === 100 ? Visibility.None : Visibility.Visible)
        Web({ src:this.url, controller:this.controller })
          .width(Constants.MATCH_PARENT)
          .layoutWeight(1)
          .onProgressChange(e => {
            this.progress = e.newProgress;
          })
      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder titleBar() {
    Row(){
      Image($r('app.media.ic_back'))
        .width($r('app.float.vp_20'))
        .height($r('app.float.vp_20'))
        .objectFit(ImageFit.Contain)
        .margin({left:$r('app.float.vp_14')})
        .onClick(() =>{
          router.back()
        })

      Text(this.title)
        .height($r('app.float.vp_56'))
        .layoutWeight(1)
        .fontSize($r('app.float.fp_20'))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(500)
        .textAlign(TextAlign.Center)

      Image($r('app.media.ic_copy_link_grey'))
        .width($r('app.float.vp_30'))
        .height($r('app.float.vp_30'))
        .margin({right:$r('app.float.vp_24')})
        .onClick(() => {
        })
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({top:$r('app.float.status_bar_height')})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
  }
}