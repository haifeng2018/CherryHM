import RouterPath from '../util/RouterPath';
import router from '@ohos.router';
import Logger from '../util/Logger';
import Constants from '../util/Constants';

/**
 * Stay on the advertising page for a few seconds to jump to the home page.
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
        .fontSize($r('app.float.advertising_text_font_size'))
        .letterSpacing('0.05')
        .backgroundColor($r('app.color.color_33000000'))
        .border({
          radius: $r('app.float.advertising_text_radius'),
          width: $r('app.float.advertising_text_border_width'),
          color: Color.White
        })
        .margin({
          top: $r('app.float.advertising_title_text_margin_top'),
          left: $r('app.float.advertising_title_text_margin_left')
        })
        .padding({
          left: $r('app.float.advertising_text_padding_left'),
          top: $r('app.float.advertising_text_padding_top'),
          right: $r('app.float.advertising_text_padding_left'),
          bottom: $r('app.float.advertising_text_padding_bottom')
        })
        .onClick(() => {
          this.jumpToAppHomePage();
        })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
  }
}
