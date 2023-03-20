import { RefreshLoadLayoutPrams } from './RefreshLoadLayoutPrams';
import RefreshHeader from './RefreshHeader'

/**
 * The load more layout component.
 */
@Component
export default struct LoadMoreLayout {
  @ObjectLink loadMoreLayoutClass: RefreshLoadLayoutPrams;

  build() {
    Column() {
      if (this.loadMoreLayoutClass.isVisible) {
        RefreshHeader({
          refreshLayoutClass: new RefreshLoadLayoutPrams(this.loadMoreLayoutClass.isVisible,
             this.loadMoreLayoutClass.textValue, this.loadMoreLayoutClass.heightValue,this.loadMoreLayoutClass.heightValue*2+66)
        })
      } else {
        RefreshHeader({
          refreshLayoutClass: new RefreshLoadLayoutPrams(this.loadMoreLayoutClass.isVisible,
           this.loadMoreLayoutClass.textValue, 0,this.loadMoreLayoutClass.offsetY)
        })
      }
    }
  }
}