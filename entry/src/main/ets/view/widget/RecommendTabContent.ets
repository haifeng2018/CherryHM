import LMList from './refresh/LMList';
import { RefreshConfig } from './refresh/RefreshConfig';
import { OwnInfo } from '../../bean/OwnInfo';
import { AuthorInfo } from '../../bean/AuthorInfo';
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

  @State nextPageUrl: string = CommunityApi.RECOMMEND

  sendRecommendRequest () {
    HttpRequest.url = this.nextPageUrl
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        if (this.nextPageUrl === CommunityApi.RECOMMEND) {
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
    this.nextPageUrl = CommunityApi.RECOMMEND
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
    if (data.type === 'horizontalScrollCard') {
      if (data.data.dataType === 'HorizontalScrollCard') {
        this.bannerLayout(data)
      }
    } else if (data.type === 'communityColumnsCard') {
      this.cellLayout(data)
    }
  }

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.content.data.owner.avatar)
        .width($r('app.float.vp_40'))
        .height($r('app.float.vp_40'))
        .clip(new Circle({ width: '40vp', height: '40vp' }))

      Column() {
        Text(info.data.content.data.owner.nickname)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_18'))
          .padding($r('app.float.vp_2'))
          .textAlign(TextAlign.Start)

        Text(info.data.content.data.owner.description)
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

      if (info.data.content.type === 'video') {
        Image($r('app.media.ic_play_duration'))
          .width($r('app.float.vp_15'))
          .height($r('app.float.vp_15'))
          .objectFit(ImageFit.Contain)

        Text(DateUtil.formatDuration(info.data.content.data.duration))
          .margin({left:$r('app.float.vp_5')})
          .fontSize($r('app.float.fp_18'))
          .fontColor($r('app.color.color_666666'))
      }
    }
    .width(Constants.MATCH_PARENT)
    .padding({
      top:$r('app.float.vp_10'),
      bottom:$r('app.float.vp_20'),
      left:$r('app.float.vp_20'),
      right:$r('app.float.vp_20')
    })
  }

  @Builder bannerLayout(info: VideoInfo) {
    Swiper() {
      ForEach(info.data.itemList, item => {
        Image(item.data.image)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)
          .sharedTransition(`${this.datas.indexOf(info)}${item.data.id}`, {
            duration: Constants.TRANSITION_ANIMATION_DURATION,
            curve: Curve.Smooth,
            delay: Constants.SHARE_ITEM_ANIMATION_DELAY
          })
          .onClick(() => {
          })
      })
    }
    .width(Constants.MATCH_PARENT)
    .height($r('app.float.vp_256'))
    .index(0)
    .autoPlay(info.data.itemList.length > 1)
    .interval(3000)
    .indicator(info.data.itemList.length > 1)
    .indicatorStyle({
      bottom:10,size: 20, mask: true,
      color:$r('app.color.color_80FFFFFF'),
      selectedColor:$r('app.color.white')})
    .loop(true)
    .duration(1000)
    .itemSpace(0)
    .curve(Curve.Linear)
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

  getMediaType (type): Resource {
    if (type === 'video') {
      return $r('app.string.video')
    } else if (type === 'ugcPicture') {
      return $r('app.string.picture')
    }
  }

  getAuthorInfo (owner: OwnInfo): AuthorInfo {
    let author = new AuthorInfo()
    author.icon = owner.avatar
    author.name = owner.nickname
    return author
  }
}