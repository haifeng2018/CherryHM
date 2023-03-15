import DimensionUtil from '../../../util/DimensionUtil';
import Constants from '../../../util/Constants';
import { RefreshState } from './RefreshConstants';
import { RefreshConstants } from './RefreshConstants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RefreshHeader
 * Author: Victor
 * Date: 2023/3/13 15:13
 * Description: 
 * -----------------------------------------------------------------
 */
@Component
export default struct RefreshHeader {
  @State refreshTitle: Resource = $r('app.string.refresh_default_header_hint');
  @Consume(RefreshConstants.REFRESH_STATE_TAG)
  @Watch('onStateCheck') state: number;

  private onStateCheck() {
    switch (this.state) {
      case RefreshState.IDLE:
        this.refreshTitle = $r('app.string.refresh_default_header_hint');
        break;
      case RefreshState.DRAGGING_REFRESHABLE:
        this.refreshTitle = $r('app.string.refresh_default_header_load');
        break;
      case RefreshState.REFRESHING:
        this.refreshTitle = $r('app.string.refresh_default_header_loading');
        break;
    }
  }

  build() {
    if (this.state !== RefreshState.IDLE) {
      Row() {
        LoadingProgress()
          .width('50vp')
          .height('50vp')
          .color(Color.Blue)

        Text(this.refreshTitle)
          .height(Constants.MATCH_PARENT)
          .textAlign(TextAlign.Center)
          .fontSize(DimensionUtil.getFp($r('app.float.default_header_font_size')))
          .onAppear(() => {
            this.onStateCheck();
          })
      }
      .height(Constants.MATCH_PARENT)
      .width(Constants.MATCH_PARENT)
      .justifyContent(FlexAlign.Center)

    }
  }
}