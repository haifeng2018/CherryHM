import Constants from '../../../util/Constants';
import { RefreshLoadLayoutPrams } from './RefreshLoadLayoutPrams';

/**
 * The refresh layout component.
 */
@Component
export default struct RefreshHeader {
  @ObjectLink refreshLayoutClass: RefreshLoadLayoutPrams;

  build() {
    if (this.refreshLayoutClass.isVisible) {
      Row() {
        LoadingProgress()
          .width(this.getSize(this.refreshLayoutClass.scale))
          .height(this.getSize(this.refreshLayoutClass.scale))

        Text(this.refreshLayoutClass.textValue)
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_18'))
      }
      .width(Constants.MATCH_PARENT)
      .justifyContent(FlexAlign.Center)
      .height(this.refreshLayoutClass.heightValue)
    }
  }

  getSize (scale: number): string {
//    return `${scale * 50}vp`
    return '50vp'
  }

}