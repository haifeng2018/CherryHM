import Constants from '../util/Constants';
import router from '@ohos.router';
import web_webview from '@ohos.web.webview'

@Entry
@Component
struct WebPage {
  @State userAgent:string = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36'

  @State js: string =
  "javascript:(function() {document.getElementsByClassName(\"share-bar-container\")[0].style.display=\'none\';" +
  "document.getElementsByClassName(\"footer-container j-footer-container\")[0].style.display=\'none\';" +
  "document.getElementsByClassName(\"kyt-promotion-bar-positioner\")[0].style.display=\'none\';" +
  "})()"

  @State title: string = router.getParams()?.['title'];
  @State url: string = router.getParams()?.['url'];

  onPageHide() {
    router.clear()
  }

  controller: web_webview.WebviewController = new web_webview.WebviewController()

  testObj = {
    test: (data1, data2, data3) => {
      console.log("data1:" + data1)
      console.log("data2:" + data2)
      console.log("data3:" + data3)
      return "AceString"
    },
    getElementsByClassName: () => {
      console.log('toString' + "interface instead.")
      return null
    }
  }

  aboutToAppear() {
    console.error('WebPage','title = ' + this.title)
    console.error('WebPage','url = ' + this.url)
  }

  build() {
      Column() {
        this.titleBar()
        Web({ src:this.url, controller:this.controller })
          .width(Constants.MATCH_PARENT)
          .layoutWeight(1)
          .zoomAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .javaScriptAccess(true)
          .mediaPlayGestureAccess(true)
          .userAgent(this.userAgent)
          .javaScriptProxy({
            object: this.testObj,
            name: "objName",
            methodList: ["test", "toString"],
            controller: this.controller,
          })
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