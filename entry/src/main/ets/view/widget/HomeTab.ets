/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTab
 * Author: Victor
 * Date: 2023/2/27 12:22
 * Description:
 * -----------------------------------------------------------------
 */
@Component
export struct HomeTab {
  @Link checked: boolean

  build() {
    Column() {
      Image(this.checked ? $r('app.media.ic_home_checked') : $r('app.media.ic_home_normal'))
        .width(28)
        .height(28)
        .margin(6)
        .opacity(this.checked ? 1 : 0.4)
        .objectFit(ImageFit.Contain)
      Text('首页')
        .fontColor(this.checked ? $r('app.color.color_0091FF') : $r('app.color.color_999999'))
        .fontSize(12)
    }.width('100%')
  }

}