import Constants from '../util/Constants';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.MATCH_PARENT)
    }
    .height(Constants.MATCH_PARENT)
  }
}