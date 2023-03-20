import Constants from '../../../util/Constants';
import { RefreshConfig } from './RefreshConfig';
import { RefreshLoadLayoutPrams } from './RefreshLoadLayoutPrams';
import LoadMoreLayout from './LoadMoreLayout';
import RefreshHeader from './RefreshHeader';
import { PageState } from './PageState';
import { RefreshState } from './RefreshState';

/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LMList
 * Author: Victor
 * Date: 2023/3/17 12:00
 * Description: 
 * -----------------------------------------------------------------
 */
@Component
export default struct RefreshComponent {
  @State pullDownRefreshText: Resource = $r('app.string.pull_down_refresh_text');
  @State pullDownRefreshImage: Resource = $r('app.media.ic_pull_down_refresh');
  @State pullDownRefreshHeight: number = RefreshConfig.CUSTOM_LAYOUT_HEIGHT;
  @State isVisiblePullDown: boolean = false;
  @State pullUpLoadText: Resource = $r('app.string.pull_up_load_text');
  @State pullUpLoadImage: Resource = $r('app.media.ic_pull_up_load');
  @State pullUpLoadHeight: number = RefreshConfig.CUSTOM_LAYOUT_HEIGHT;
  @State isVisiblePullUpLoad: boolean = false;
  @State offsetY: number = 0;
  private downY = 0;
  private lastMoveY = 0;
  private isRefreshing: boolean = false;
  private isCanRefresh = false;
  private isPullRefreshOperation = false;
  private isLoading: boolean = false;
  private isCanLoadMore = false;

  @Consume(RefreshConfig.REFRESH_STATE_TAG) @Watch('onStateChanged') pageState: number;
  @Consume(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) @Watch('onDataChanged') listScrollTop: boolean;

  private onRefresh: () => void;
  @BuilderParam itemLayout: () => void;

  private onStateChanged() {

  }
  private onDataChanged() {

  }

  build() {
    Column() {
      if (this.pageState === PageState.Loading) {
        this.LoadingLayout()
      } else if (this.pageState === PageState.Success) {
        this.ContentLayout()
      } else {
        this.FailLayout()
      }
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
    .onTouch((event) => {
      if (this.pageState === PageState.Success) {
        this.listTouchEvent(event,{
          onRefresh: () => {
            this.onRefresh()
          }
        });
      }
    })
  }

  @Builder LoadingLayout() {
    RefreshHeader({ refreshLayoutClass: new RefreshLoadLayoutPrams(true,
     $r('app.string.pull_up_load_text'), this.pullDownRefreshHeight,this.offsetY) })
  }

  @Builder ContentLayout() {
    Column() {
      RefreshHeader({
        refreshLayoutClass: new RefreshLoadLayoutPrams(this.isVisiblePullDown,
        this.pullDownRefreshText, this.pullDownRefreshHeight,this.offsetY)
      })

      if (this.itemLayout !== null) {
        this.itemLayout()
      }
    }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
    .offset({ y: `${vp2px(-this.pullUpLoadHeight) + this.offsetY}px`})
  }

  @Builder FailLayout() {
    Image($r('app.media.none'))
      .height('120vp')
      .width('120vp')
    Text($r('app.string.page_none_msg'))
      .opacity(0.6)
      .fontSize('18fp')
      .fontColor($r('app.color.color_666666'))
  }

  getHeaderScale ():number {
    let scale = this.offsetY / this.pullDownRefreshHeight
    return scale
  }

  /////////////////处理下拉刷新 start//////////////////////
  listTouchEvent(event: TouchEvent,callback) {
    //list grid没有滚动到第一个不进入下拉刷新处理
    if (this.listScrollTop) {
      switch (event.type) {
        case TouchType.Down:
          this.downY = event.touches[0].y;
          this.lastMoveY = event.touches[0].y;
          break;
        case TouchType.Move:
          if (this.isRefreshing || this.isLoading) {
            return;
          }
          let isDownPull = event.touches[0].y - this.lastMoveY > 0;
          if ((isDownPull || this.isPullRefreshOperation) && !this.isCanLoadMore) {
            // 手指移动，处理下拉刷新
            this.touchMovePullRefresh(event);
          }
          this.lastMoveY = event.touches[0].y;
          break;
        case TouchType.Cancel:
          break;
        case TouchType.Up:
          if (this.isRefreshing || this.isLoading) {
            return;
          }
          if (this.isPullRefreshOperation) {
            // 手指抬起，处理下拉刷新
            this.touchUpPullRefresh(callback);
          }
          break;
        default:
          break;
      }
    }
  }

  touchMovePullRefresh(event: TouchEvent) {
    this.isPullRefreshOperation = true;
    let height = vp2px(this.pullDownRefreshHeight);
    this.offsetY = event.touches[0].y - this.downY;
    // 滑动的偏移量大于下拉刷新布局高度，达到刷新条件
    if (this.offsetY >= height) {
      this.pullRefreshState.call(this, RefreshState.Release);
      this.offsetY = height + this.offsetY * RefreshConfig.Y_OFF_SET_COEFFICIENT;
    } else {
      this.pullRefreshState.call(this, RefreshState.DropDown);
    }
    if (this.offsetY < 0) {
      this.offsetY = 0;
      this.isPullRefreshOperation = false;
    }
  }

  touchUpPullRefresh(callback) {
    if (this.isCanRefresh) {
      this.offsetY = vp2px(this.pullDownRefreshHeight);
      this.pullRefreshState.call(this, RefreshState.Refreshing);
      setTimeout(() => {
        let self = this;
        this.closeRefresh.call(self, true);
        callback.onRefresh()
      }, RefreshConfig.DELAY_TIME);
    } else {
      this.closeRefresh.call(this, false);
    }
  }

  pullRefreshState(state: number) {
    switch (state) {
      case RefreshState.DropDown:
        this.pullDownRefreshText = $r('app.string.pull_down_refresh_text');
        this.pullDownRefreshImage = $r("app.media.ic_pull_down_refresh");
        this.isCanRefresh = false;
        this.isRefreshing = false;
        this.isVisiblePullDown = true;
        break;
      case RefreshState.Release:
        this.pullDownRefreshText = $r('app.string.release_refresh_text');
        this.pullDownRefreshImage = $r("app.media.ic_pull_up_refresh");
        this.isCanRefresh = true;
        this.isRefreshing = false;
        break;
      case RefreshState.Refreshing:
        this.offsetY = vp2px(this.pullDownRefreshHeight);
        this.pullDownRefreshText = $r('app.string.refreshing_text');
        this.pullDownRefreshImage = $r("app.media.ic_pull_up_load");
        this.isCanRefresh = true;
        this.isRefreshing = true;
        break;
      case RefreshState.Success:
        this.pullDownRefreshText = $r('app.string.refresh_success_text');
        this.pullDownRefreshImage = $r("app.media.ic_succeed_refresh");
        this.isCanRefresh = true;
        this.isRefreshing = true;
        break;
      case RefreshState.Fail:
        this.pullDownRefreshText = $r('app.string.refresh_fail_text');
        this.pullDownRefreshImage = $r("app.media.ic_fail_refresh");
        this.isCanRefresh = true;
        this.isRefreshing = true;
        break;
      default:
        break;
    }
  }

  closeRefresh(isRefreshSuccess: boolean) {
    let self = this;
    setTimeout(() => {
      let delay = RefreshConfig.DELAY_PULL_DOWN_REFRESH;
      if (self.isCanRefresh) {
        this.pullRefreshState.call(this, isRefreshSuccess ? RefreshState.Success : RefreshState.Fail);
        delay = RefreshConfig.DELAY_SHRINK_ANIMATION_TIME;
      }
      animateTo({
        duration: RefreshConfig.CLOSE_PULL_DOWN_REFRESH_TIME,
        delay: delay,
        onFinish: () => {
          this.pullRefreshState.call(this, RefreshState.DropDown);
          self.isVisiblePullDown = false;
          self.isPullRefreshOperation = false;
        }
      }, () => {
        self.offsetY = 0;
      })
    }, self.isCanRefresh ? RefreshConfig.DELAY_ANIMATION_DURATION : 0);
  }

  /////////////////处理下拉刷新 end//////////////////////

}