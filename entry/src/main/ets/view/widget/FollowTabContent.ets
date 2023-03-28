import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import RouterPath from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import { CommunityApi } from '../../api/CommunityApi';
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
 * Description: 首页-发现-关注
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct FollowTabContent {

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = CommunityApi.FOLLOW

  sendFollowRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === CommunityApi.FOLLOW) {
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
    this.nextPageUrl = CommunityApi.FOLLOW
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
        .width($r('app.float.vp_40'))
        .height($r('app.float.vp_40'))
        .clip(new Circle({ width: '40vp', height: '40vp' }))

      Column() {
        Text(info.data.header.title)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)

        Text(info.data.header.description)
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
    }
    .width(Constants.MATCH_PARENT)
    .padding({
      top:$r('app.float.vp_10'),
      bottom:$r('app.float.vp_10'),
      left:$r('app.float.vp_20'),
      right:$r('app.float.vp_20')
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.USER_PAGE,
        params: {
          userId:info.data.header.id,
        }
      })
    })
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
                  .borderRadius($r('app.float.vp_10'))

                Text(item.data.category)
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize($r('app.float.fp_16'))
                  .backgroundColor($r('app.color.color_4DFFFFFF'))
                  .margin({
                    top:$r('app.float.vp_5'),
                    right:$r('app.float.vp_5')
                  })
                  .padding({
                    top:$r('app.float.vp_5'),
                    bottom:$r('app.float.vp_5'),
                    left:$r('app.float.vp_10'),
                    right:$r('app.float.vp_10')
                  })
                  .borderRadius($r('app.float.vp_5'))
              }
              .width(Constants.MATCH_PARENT)
              .height($r('app.float.vp_198'))
              .alignContent(Alignment.TopEnd)

              Text(item.data.title)
                .width(Constants.MATCH_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_333333'))
                .fontSize($r('app.float.fp_16'))
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})
                .margin({top:$r('app.float.vp_5')})
                .padding($r('app.float.vp_5'))

              Text(DateUtil.formatReleaseDate(item.data.releaseTime))
                .width(Constants.MATCH_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_666666'))
                .fontSize($r('app.float.fp_18'))
                .padding($r('app.float.vp_5'))
            }
            .width($r('app.float.vp_328'))
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
      .padding({left:$r('app.float.vp_20')})

      Text()
        .width(Constants.MATCH_PARENT)
        .height($r('app.float.vp_1'))
        .margin({top:$r('app.float.vp_5')})
        .backgroundColor($r('app.color.color_80DDDDDD'))
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
  }

}