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
          refreshLayoutClass: new RefreshLoadLayoutPrams(1,this.loadMoreLayoutClass.isVisible,
            this.loadMoreLayoutClass.imageSrc, this.loadMoreLayoutClass.textValue, this.loadMoreLayoutClass.heightValue)
        })
      } else {
        RefreshHeader({
          refreshLayoutClass: new RefreshLoadLayoutPrams(1,this.loadMoreLayoutClass.isVisible,
            this.loadMoreLayoutClass.imageSrc, this.loadMoreLayoutClass.textValue, 0)
        })
      }
    }
  }
}