import { RefreshConfig } from './refresh/RefreshConfig';
import RefreshComponent from './refresh/RefreshComponent';
import RouterPath from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import promptAction from '@ohos.promptAction';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
import { PageState } from './refresh/PageState';

/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: WeeklyRankingTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-热门-周排行、月排行、总排行
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct RankingTabContent {
  @State url: string = "";
  @State datas: Array<VideoInfo> = [];

  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  aboutToAppear() {
    this.sendRankingRequest()
  }

  sendRankingRequest () {
    HttpRequest.url = this.url
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        this.datas = value.itemList
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    RefreshComponent({
      itemLayout: () => this.itemLayout(),
      onRefresh: () => {
        this.sendRankingRequest()
      }
    })
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder itemLayout () {
    List() {
      ForEach(this.datas, (data) => {
        ListItem() {
          this.cellLayout(data)
        }
      })
    }
    // 去掉回弹效果
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      // 监听当前列表首位索引
      this.listScrollTop = start === 0
    })
  }

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.author.icon)
        .width('40vp')
        .height('40vp')
        .border({ width: '2vp',color:$r('app.color.white'),radius:'20vp',style:BorderStyle.Solid })

      Column() {
        Text(info.data.author.name)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.author.description)
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

  @Builder cellLayout (info: VideoInfo) {
    Column(){
      this.authorLayout(info)
      Stack() {
        Image(info.data.cover.feed)
          .objectFit(ImageFit.Cover)
          .width(Constants.MATCH_PARENT)
          .height(Constants.MATCH_PARENT)

        Text(info.data.category)
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

      Text(info.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize('16fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(info.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'30vp'})
        Text(info.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'30vp'})
        Text(info.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('16fp').margin({left:'5vp'})
      }
      .width(Constants.MATCH_PARENT)
      .justifyContent(FlexAlign.End)
      .padding({left:'10vp',right:'10vp'})

      Text()
        .width(Constants.MATCH_PARENT)
        .height('1vp')
        .margin({top:'10vp'})
        .backgroundColor($r('app.color.color_80DDDDDD'))
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .alignItems(HorizontalAlign.Start)
    .sharedTransition(`${this.datas.indexOf(info)}${info.data.id}`, {
      duration: Constants.TRANSITION_ANIMATION_DURATION,
      curve: Curve.Smooth,
      delay: Constants.SHARE_ITEM_ANIMATION_DELAY
    })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          data:info.data,
          shareId: `${this.datas.indexOf(info)}${info.data.id}`
        }
      })
    })
  }
}