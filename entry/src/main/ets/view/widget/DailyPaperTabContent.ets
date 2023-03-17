import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import { HomeApi } from '../../api/HomeApi';
import promptAction from '@ohos.promptAction';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
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
      .fontSize('22fp')
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .padding('10vp')
  }

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.content.data.author.icon)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.content.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.content.data.author.description)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({left:'10vp'})
    }
    .width(Constants.MATCH_PARENT)
    .padding({top:'10vp',bottom:'20vp',left:'20vp',right:'20vp'})
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
          .fontSize('16fp')
          .backgroundColor($r('app.color.color_4DFFFFFF'))
          .margin({top:'5vp',right:'5vp'})
          .padding({top:'5vp',bottom:'5vp',left:'10vp',right:'10vp'})
          .borderRadius('5vp')
      }
      .width(Constants.MATCH_PARENT)
      .height('256vp')
      .alignContent(Alignment.TopEnd)

      Text(info.data.content.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize('16fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

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