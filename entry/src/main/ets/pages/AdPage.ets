import RouterPath from '../util/RouterPath';
import router from '@ohos.router';
import Logger from '../util/Logger';
import Constants from '../util/Constants';

/**
 * Stay on the ad page for a few seconds to jump to the home page.
 */
@Entry
@Component
struct AdPage {
  private TAG = 'AdPage';
  @State countDownSeconds: number = 2;
  private timeId: number;

  onPageShow() {
    this.timeId = setInterval(() => {
      if (this.countDownSeconds == 0) {
        this.jumpToAppHomePage();
      } else {
        this.countDownSeconds--;
      }
    }, Constants.AD_INTERVAL_TIME);
  }

  onPageHide() {
    router.clear();
    clearInterval(this.timeId);
  }

  /**
   * Jump to app home page.
   */
  jumpToAppHomePage() {
    router.pushUrl({
      url: RouterPath.MAIN_PAGE
    }).catch((error) => {
      Logger.error(this.TAG, 'AdvertisingPage pushUrl error ' + JSON.stringify(error));
    });
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.img_splash'))
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
      Text($r('app.string.advertising_text_title', this.countDownSeconds))
        .fontColor(Color.White)
        .fontSize($r('app.float.fp_12'))
        .backgroundColor($r('app.color.color_33000000'))
        .border({
          radius: $r('app.float.vp_18'),
          width: $r('app.float.vp_1'),
          color: Color.White
        })
        .margin({
          top: $r('app.float.vp_30'),
          left: $r('app.float.vp_260')
        })
        .padding({
          left: $r('app.float.vp_12'),
          top: $r('app.float.vp_8'),
          right: $r('app.float.vp_12'),
          bottom: $r('app.float.vp_8')
        })
        .onClick(() => {
          this.jumpToAppHomePage();
        })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
  }
}
