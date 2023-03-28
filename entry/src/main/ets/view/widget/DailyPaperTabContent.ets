import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import RouterPath from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import { HomeApi } from '../../api/HomeApi';
import promptAction from '@ohos.promptAction';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
import DateUtil from '../../util/DateUtil';
import { PageState } from './refresh/PageState';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DailyPaperTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-日报
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct DailyPaperTabContent {

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = HomeApi.DAILY_PAPER

  sendDailyPaperRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === HomeApi.DAILY_PAPER) {
          this.datas = value.itemList
        } else {
          this.datas = this.datas.concat(value.itemList);
        }
        this.nextPageUrl = value.nextPageUrl
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  aboutToAppear() {
    this.sendDailyPaperRequest()
  }

  refreshData () {
    this.nextPageUrl = HomeApi.DAILY_PAPER
    this.sendDailyPaperRequest()
  }

  loadMoreData () {
    this.sendDailyPaperRequest()
  }

  build() {
    LMList({
      itemLayout: (data) => this.itemLayout(data),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder itemLayout (info: VideoInfo) {
    if (info.type === 'textCard') {
      this.headCell(info)
    } else {
      this.contentCell(info)
    }
  }

  @Builder headCell(dailyPagerInfo: VideoInfo) {
    Text(dailyPagerInfo.data.text)
      .width(Constants.MATCH_PARENT)
      .fontSize($r('app.float.fp_22'))
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .padding($r('app.float.vp_10'))
  }

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.content.data.author.icon)
        .width($r('app.float.vp_40'))
        .height($r('app.float.vp_40'))
        .clip(new Circle({ width: '40vp', height: '40vp' }))

      Column() {
        Text(info.data.content.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)

        Text(info.data.content.data.author.description)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize($r('app.float.fp_12'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({left:$r('app.float.vp_10')})

      Image($r('app.media.ic_play_duration'))
        .width($r('app.float.vp_15'))
        .height($r('app.float.vp_15'))
        .objectFit(ImageFit.Contain)

      Text(DateUtil.formatDuration(info.data.content.data.duration))
        .margin({left:$r('app.float.vp_5')})
        .fontSize($r('app.float.fp_18'))
        .fontColor($r('app.color.color_666666'))
    }
    .width(Constants.MATCH_PARENT)
    .padding({
      top:$r('app.float.vp_10'),
      bottom:$r('app.float.vp_20'),
      left:$r('app.float.vp_20'),
      right:$r('app.float.vp_20')
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.USER_PAGE,
        params: {
          userId:info.data.content.data.author.id,
        }
      })
    })
  }

  @Builder contentCell (info: VideoInfo) {
    Column(){
      Stack() {
        Image(info.data.content.data.cover.feed)
          .objectFit(ImageFit.Cover)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)

        Text(info.data.content.data.category)
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_16'))
          .backgroundColor($r('app.color.color_4DFFFFFF'))
          .margin({top:$r('app.float.vp_5'),right:$r('app.float.vp_5')})
          .padding({
            top:$r('app.float.vp_5'),
            bottom:$r('app.float.vp_5'),
            left:$r('app.float.vp_10'),
            right:$r('app.float.vp_10')
          })
          .borderRadius($r('app.float.vp_5'))
      }
      .width(Constants.MATCH_PARENT)
      .height($r('app.float.vp_256'))
      .alignContent(Alignment.TopEnd)

      Text(info.data.content.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.fp_16'))
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding($r('app.float.vp_10'))

      this.authorLayout(info)
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .sharedTransition(`${this.datas.indexOf(info)}${info.data.content.data.id}`, {
      duration: Constants.TRANSITION_ANIMATION_DURATION,
      curve: Curve.Smooth,
      delay: Constants.SHARE_ITEM_ANIMATION_DELAY
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          data:info.data.content.data,
          shareId: `${this.datas.indexOf(info)}${info.data.content.data.id}`
        }
      })
    })
  }
}