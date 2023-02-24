@Entry
@Component
struct UserServicesAgreementPage {
  controller:WebController = new WebController();

  build() {
    Row() {
      Column() {
        Web({ src:'https://app.service.hokkj.cn/', controller:this.controller })
      }
      .width('100%')
    }
    .height('100%')
  }
}