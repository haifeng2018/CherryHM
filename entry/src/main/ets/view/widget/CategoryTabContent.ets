import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { CategoryInfo } from '../../bean/CategoryInfo';
import { DiscoveryApi } from '../../api/DiscoveryApi';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CategoryTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-发现-分类
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct CategoryTabContent {

  @State datas: Array<CategoryInfo> = [];
  @State isRefreshing: boolean = false

  scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.sendCategoryRequest()
  }

  sendCategoryRequest () {
    HttpRequest.url = DiscoveryApi.CATEGORY
    HttpRequest.setMethod(http.RequestMethod.GET)
    HttpRequest.request({
      onSuccess: (value) => {
        this.datas = value
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing, offset: 56, friction: 66 }) {
        Grid(this.scroller) {
          ForEach(this.datas, (data) => {
            GridItem() {
              this.cellLayout(data)
            }
          })
        }
        .layoutDirection(GridDirection.Column)
        .columnsTemplate('1fr 1fr')
        .columnsGap('10vp')
        .rowsGap('10vp')
        .backgroundColor($r('app.color.color_F9F9F9'))
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
        .padding('10vp')
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        refreshStatus
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
          this.sendCategoryRequest()
        }, 1000)
        console.log('onRefreshing test')
      })
      .width(Constants.MATCH_PARENT)
      .layoutWeight(1)
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder cellLayout (info: CategoryInfo) {
    Stack(){
      Image(info.bgPicture)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('198vp')
        .borderRadius('10vp')

      Text(info.name)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize('28fp')
        .fontColor($r('app.color.white'))

    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .sharedTransition(`${this.datas.indexOf(info)}${info.id}`, {
      duration: Constants.TRANSITION_ANIMATION_DURATION,
      curve: Curve.Smooth,
      delay: Constants.SHARE_ITEM_ANIMATION_DELAY
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.CATEGORY_DETAIL_PAGE,
        params: {
          categoryId: info.id,
          categoryName: info.name,
          shareId: `${this.datas.indexOf(info)}${info.id}`
        }
      })
    })
  }
}