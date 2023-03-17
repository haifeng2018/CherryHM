import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import { OwnInfo } from '../../bean/OwnInfo';
import { AuthorInfo } from '../../bean/AuthorInfo';
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
 * File: MonthlyRankingTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-发现-推荐
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct RecommendTabContent {

  @Provide(RefreshConfig.REFRESH_DATA_TAG) datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;

  @State nextPageUrl: string = DiscoveryApi.RECOMMEND

  sendRecommendRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === DiscoveryApi.RECOMMEND) {
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
    this.sendRecommendRequest()
  }


  refreshData () {
    this.nextPageUrl = DiscoveryApi.RECOMMEND
    this.sendRecommendRequest()
  }

  loadMoreData () {
    this.sendRecommendRequest()
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

  @Builder itemLayout(data: VideoInfo) {
    if (data.type === 'communityColumnsCard') {
      this.cellLayout(data)
    }
  }

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.content.data.owner.avatar)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.content.data.owner.nickname)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.content.data.owner.description)
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

  @Builder cellLayout (info: VideoInfo) {
    Column(){
      Stack() {
        Image(info.data.content.data.cover.feed)
          .objectFit(ImageFit.Cover)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)

        Text(this.getMediaType(info.data.content.type))
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
      if (info.data.content.type === 'video') {
        info.data.content.data.author = this.getAuthorInfo(info.data.content.data.owner)
        router.pushUrl({
          url: RouterPath.VIDEO_DETAIL_PAGE,
          params: {
            data:info.data.content.data,
            shareId: `${this.datas.indexOf(info)}${info.data.content.data.id}`
          }
        })
      } if (info.data.content.type === 'ugcPicture') {
        router.pushUrl({
          url: RouterPath.POSTER_PAGE,
          params: {
            data: info.data.content.data,
            shareId: `${this.datas.indexOf(info)}${info.data.content.data.id}`
          },
        })
      }
    })
  }

  getMediaType (type): string {
    if (type === 'video') {
      return '视频'
    } else if (type === 'ugcPicture') {
      return '图片'
    }
  }

  getAuthorInfo (owner: OwnInfo): AuthorInfo {
    let author = new AuthorInfo()
    author.icon = owner.avatar
    author.name = owner.nickname
    return author
  }
}