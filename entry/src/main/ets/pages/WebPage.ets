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
    Row() {
      Column() {
        Row(){
          Image($r('app.media.ic_back'))
            .width(55).height(55).padding(16)
            .objectFit(ImageFit.Cover)
            .onClick(() =>{
                router.back()
            })

          Text(this.title).fontSize(18).fontColor($r('app.color.color_333333')).textAlign(TextAlign.Center).layoutWeight(1)
        }
        Web({ src:this.url, controller:this.controller }).layoutWeight(1)
      }
      .width('100%')
    }
    .height('100%')
  }
}