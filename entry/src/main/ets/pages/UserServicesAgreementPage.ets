import router from '@ohos.router';
@Entry
@Component
struct UserServicesAgreementPage {

  onPageHide() {
    router.clear();
  }

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