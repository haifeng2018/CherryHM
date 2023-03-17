import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import { DiscoveryApi } from '../../api/DiscoveryApi';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
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
 * Description: 首页-发现-关注
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct FollowTabContent {

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = DiscoveryApi.FOLLOW

  sendFollowRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === DiscoveryApi.FOLLOW) {
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
    this.sendFollowRequest()
  }

  refreshData () {
    this.nextPageUrl = DiscoveryApi.FOLLOW
    this.sendFollowRequest()
  }

  loadMoreData () {
    this.sendFollowRequest()
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

  @Builder headCell(info: VideoInfo) {
    Row(){
      Image(info.data.header.icon)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.header.title)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.header.description)
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
    .padding({top:'10vp',bottom:'10vp',left:'20vp',right:'20vp'})
  }

  @Builder itemLayout (info: VideoInfo) {
    Column(){
      this.headCell(info)
      List({ space: 10 }) {
        ForEach(info.data.itemList, (item) => {
          ListItem() {
            Column(){
              Stack() {
                Image(item.data.cover.feed)
                  .width(Constants.MATCH_PARENT)
                  .height(Constants.MATCH_PARENT)
                  .borderRadius('10vp')

                Text(item.data.category)
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize('16fp')
                  .backgroundColor($r('app.color.color_4DFFFFFF'))
                  .margin({top:'5vp',right:'5vp'})
                  .padding({top:'5vp',bottom:'5vp',left:'10vp',right:'10vp'})
                  .borderRadius('5vp')
              }
              .width(Constants.MATCH_PARENT)
              .height('198vp')
              .alignContent(Alignment.TopEnd)

              Text(item.data.title)
                .width(Constants.MATCH_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_333333'))
                .fontSize('16fp')
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})
                .margin({top:'5vp'})
                .padding('5vp')

              Text(this.formatReleaseDate(item.data.releaseTime))
                .width(Constants.MATCH_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_666666'))
                .fontSize('18fp')
                .padding('5vp')
            }
            .width('328vp')
          }
          .sharedTransition(`${info.data.itemList.indexOf(item)}${item.data.id}`, {
            duration: Constants.TRANSITION_ANIMATION_DURATION,
            curve: Curve.Smooth,
            delay: Constants.SHARE_ITEM_ANIMATION_DELAY
          })
          .onClick(() => {
            router.pushUrl({
              url: RouterPath.VIDEO_DETAIL_PAGE,
              params: {
                data:item.data,
                shareId: `${info.data.itemList.indexOf(item)}${item.data.id}`
              }
            })
          })
        })
      }
      .listDirection(Axis.Horizontal)
      .padding({left:'20vp'})

      Text()
        .width(Constants.MATCH_PARENT)
        .height('1vp')
        .margin({top:'5vp'})
        .backgroundColor($r('app.color.color_80DDDDDD'))
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
  }

  formatReleaseDate(releaseTime: number): string {
    let releaseDate = new Date(releaseTime)

    let year = releaseDate.getFullYear().toString()
    let month = releaseDate.getMonth().toString()
    let day = releaseDate.getDay().toString()
    let hours = releaseDate.getHours()
    let mins = releaseDate.getMinutes()

    let hoursStr = hours.toString()
    if (hours < 10) {
      hoursStr = "0" + hours
    }

    let minsStr = hours.toString()
    if (mins < 10) {
        minsStr = "0" + mins
    }

    return year + '/' + month + '/' + day + ' ' + hoursStr + ':' + minsStr
  }
}