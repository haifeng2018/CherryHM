import Constants from '../../../util/Constants';
import { RefreshLoadLayoutPrams } from './RefreshLoadLayoutPrams';

/**
 * The refresh layout component.
 */
@Component
export default struct RefreshHeader {
  @ObjectLink refreshLayoutClass: RefreshLoadLayoutPrams;

  build() {
    Row() {
      LoadingProgress()
        .width($r('app.float.vp_50'))
        .height($r('app.float.vp_50'))

      Text(this.refreshLayoutClass.textValue)
        .fontColor($r('app.color.color_666666'))
        .fontSize($r('app.float.fp_18'))
    }
    .width(Constants.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
    .height(this.refreshLayoutClass.heightValue)
    .opacity(this.getOpacity())
//    .scale({x:this.getOpacity(),y:this.getOpacity()})
  }

  getSize (): string {
    let size = this.getOpacity() * 50
    if (size > 50) {
      size = 50
    }
    return `${size}vp`
  }

  getOpacity():number {
    if (this.refreshLayoutClass.offsetY > 2*this.refreshLayoutClass.heightValue) {
      let y = this.refreshLayoutClass.offsetY - 2*this.refreshLayoutClass.heightValue
      let opacity = y / this.refreshLayoutClass.heightValue
      if (opacity > 1) {
        opacity = 1
      }
      return opacity
    }
    return 0
  }

}