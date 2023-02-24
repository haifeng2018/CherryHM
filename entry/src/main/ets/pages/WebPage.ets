@Entry
@Component
struct WebPage {
  controller:WebController = new WebController();

  build() {
    Row() {
      Column() {
        Web({ src:'https://app.privacy.hokkj.cn/', controller:this.controller })
      }
      .width('100%')
    }
    .height('100%')
  }
}