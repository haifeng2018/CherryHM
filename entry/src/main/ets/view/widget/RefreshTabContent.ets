import { RouterPath } from '../../util/RouterPath';
import router from '@ohos.router';
import { VideoInfo } from '../../bean/VideoInfo';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import Constants from '../../util/Constants';
import HttpRequest from '../../util/HttpRequest';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RefreshTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-热门-周排行、月排行、总排行
 * -----------------------------------------------------------------
 */
@Preview
@Component
export struct RefreshTabContent {
  @State url: string = "";
  @State followList: Array<VideoInfo> = [];

  scroller: Scroller = new Scroller()

  // 页数
  private pageNo = 1

  // 列表y坐标偏移量
  @State offsetY: number = 0
  // 按下的y坐标
  private downY = 0
  // 上一次移动的y坐标
  private lastMoveY = 0
  // 当前列表首部的索引
  private startIndex = 0
  // 当前列表尾部的索引
  private endIndex = 0

  // 下拉刷新的布局高度
  private pullRefreshHeight = 70
  // 下拉刷新文字：下拉刷新、松开刷新、正在刷新、刷新成功
  @State pullRefreshText: string= '下拉刷新'
  // 下拉刷新图标：与文字对应
  @State pullRefreshImage: Resource = $r("app.media.ic_logo")
  // 是否可以刷新：未达到刷新条件，收缩回去
  private isCanRefresh = false
  // 是否正在刷新：刷新中不进入触摸逻辑
  private isRefreshing: boolean = false
  // 是否已经进入了下拉刷新操作
  private isPullRefreshOperation = false

  // 上拉加载的布局默认高度
  private loadMoreHeight = 70
  // 上拉加载的布局是否显示
  @State isVisibleLoadMore: boolean = false
  // 是否可以加载更多
  private isCanLoadMore = false
  // 是否加载中：加载中不进入触摸逻辑
  private isLoading: boolean = false

  aboutToAppear() {
    this.sendRankingRequest()
  }
  sendRankingRequest () {
    HttpRequest.url = this.url
    HttpRequest.setMethod(http.RequestMethod.GET)
    HttpRequest.request({

      onSuccess: (value) => {
        if (this.pageNo == 1) {
          this.followList = value.itemList
        } else {
          this.followList.push(value.itemList)
        }

        // 关闭下拉刷新
        if(this.isRefreshing){
          this.closeRefresh()
        }
        // 关闭加载更多
        if(this.isLoading){
          this.closeLoadMore()
        }
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
        // 关闭下拉刷新
        if(this.isRefreshing){
          this.closeRefresh()
        }
        // 关闭加载更多
        if(this.isLoading){
          this.closeLoadMore()
        }
      }
    })
  }

  build() {
    Column() {
      // 下拉刷新布局
      this.CustomPullRefreshLayout()

      List() {
        ForEach(this.followList, (data) => {
          ListItem() {
            this.listCell(data)
          }.padding({left:'10vp',right:'10vp'})
        })
        // 加载更多布局
        ListItem(){
          this.CustomLoadMoreLayout()
        }
      }
      .width(Constants.MATCH_PARENT)
      .layoutWeight(1)
      .padding({top:'10vp',bottom:'10vp'})
      .backgroundColor(Color.White) // 背景
      .edgeEffect(EdgeEffect.None) // 去掉回弹效果
      .offset({ x: 0, y: `${this.offsetY}px` }) // touch事件计算的偏移量单位是px，记得加上单位
      .onScrollIndex((start, end) => { // 监听当前列表首位索引
        console.info(`${start}=start============end=${end}`)
        this.startIndex = start
        this.endIndex = end
      })
      .onAppear(()=>{
        this.refreshData()
      })
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder listCell (info: VideoInfo) {
    Column(){
      Image(info.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height('256vp')
        .borderRadius({topLeft:'10vp',topRight:'10vp'})

      Row() {
        Image(info.data.author.icon).width('40vp').height('40vp')
          .border({ width: '2vp' }).borderColor($r('app.color.white'))
          .borderRadius('40vp').borderStyle(BorderStyle.Dashed)

        Text(info.data.author.name)
          .fontColor($r('app.color.color_666666'))
          .fontSize('12fp')
          .padding('10vp')
      }
      .padding({left:'10vp',top:'20vp'})

      Text(info.data.description)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Start)
        .fontSize('10fp')
        .fontColor($r('app.color.color_999999'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding('10vp')

      Row() {
        Image($r('app.media.ic_video_likes')).width('20vp').height('20vp')
        Text(info.data.consumption.collectionCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_comment')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.consumption.replyCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})

        Image($r('app.media.ic_video_share')).width('20vp').height('20vp').margin({left:'20vp'})
        Text(info.data.consumption.shareCount.toString())
          .fontColor($r('app.color.color_999999')).fontSize('10fp').margin({left:'5vp'})
      }.padding({left:'10vp',right:'10vp'})
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({bottom:'10vp'})
    .alignItems(HorizontalAlign.Start)
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          playUrl: info.data.playUrl,
          id: info.data.id,
          title: info.data.title,
          description: info.data.description,
          category: info.data.category,
          collectionCount: info.data.consumption.collectionCount,
          shareCount: info.data.consumption.shareCount,
          replyCount: info.data.consumption.replyCount,
        }
      })
    })
  }

  // 刷新测试数据
  private refreshData(){
    this.pageNo = 1
    this.sendRankingRequest()
  }

  // 加载更多测试数据
  private loadMoreData(){
    this.pageNo++
    this.sendRankingRequest()
  }

  // 自定义下拉刷新布局
  @Builder CustomPullRefreshLayout(){
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image(this.pullRefreshImage)
        .width(18)
        .height(18)

      Text(this.pullRefreshText)
        .margin({ left: 7, bottom: 1 })
        .fontSize(17)
    }
    .width('100%')
    .height(this.pullRefreshHeight)
    // 布局跟着列表偏移量移动
    .offset({ x: 0, y: `${vp2px(-this.pullRefreshHeight) + this.offsetY}px` })
  }

  // 自定义加载更多布局
  @Builder CustomLoadMoreLayout(){
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image($r("app.media.app_icon"))
        .width(18)
        .height(18)

      Text('加载更多中...')
        .margin({ left: 7, bottom: 1 })
        .fontSize(17)
    }
    .width('100%')
    .height(this.loadMoreHeight)
    .backgroundColor('#f4f4f4')
    .visibility(this.isVisibleLoadMore ? Visibility.Visible : Visibility.None)
  }

  // 触摸事件
  listTouchEvent(event: TouchEvent){
    switch (event.type) {
      case TouchType.Down: // 手指按下
      // 记录按下的y坐标
        this.downY = event.touches[0].y
        this.lastMoveY = event.touches[0].y
        break
      case TouchType.Move: // 手指移动
      // 下拉刷新中 或 加载更多中，不进入处理逻辑
        if(this.isRefreshing || this.isLoading){
          console.info('========Move刷新中，返回=========')
          return
        }
      // 判断手势
        let isDownPull = event.touches[0].y - this.lastMoveY > 0
      // 下拉手势 或 已经进入了下拉刷新操作
        if ((isDownPull || this.isPullRefreshOperation) && !this.isCanLoadMore) {
          this.touchMovePullRefresh(event)
        } else {
          this.touchMoveLoadMore(event)
        }
        this.lastMoveY = event.touches[0].y
        break
      case TouchType.Up: // 手指抬起
      case TouchType.Cancel: // 触摸意外中断：来电界面
      // 刷新中 或 加载更多中，不进入处理逻辑
        if(this.isRefreshing || this.isLoading){
          console.info('========Up刷新中，返回=========')
          return
        }
        if (this.isPullRefreshOperation) {
          this.touchUpPullRefresh()
        } else {
          this.touchUpLoadMore()
        }
        break
    }
  }

  //============================================下拉刷新==================================================
  // 手指移动，处理下拉刷新
  touchMovePullRefresh(event:TouchEvent){
    // 当首部索引位于0
    if (this.startIndex == 0) {
      this.isPullRefreshOperation = true
      // 下拉刷新布局高度
      var height = vp2px(this.pullRefreshHeight)
      // 滑动的偏移量
      this.offsetY = event.touches[0].y - this.downY

      // 偏移量大于下拉刷新布局高度，达到刷新条件
      if (this.offsetY >= height) {
        // 状态1：松开刷新
        this.pullRefreshState(1)
        // 偏移量的值缓慢增加
        this.offsetY = height + this.offsetY * 0.15
      } else {
        // 状态0：下拉刷新
        this.pullRefreshState(0)
      }

      if (this.offsetY < 0) {
        this.offsetY = 0
        this.isPullRefreshOperation = false
      }
    }
  }

  // 手指抬起，处理下拉刷新
  touchUpPullRefresh(){
    // 是否可以刷新
    if (this.isCanRefresh) {
      console.info('======执行下拉刷新========')
      // 偏移量为下拉刷新布局高度
      this.offsetY = vp2px(this.pullRefreshHeight)
      // 状态2：正在刷新
      this.pullRefreshState(2)

      // 耗时操作
      this.refreshData()

    } else {
      console.info('======关闭下拉刷新！未达到条件========')
      // 关闭刷新
      this.closeRefresh()
    }
  }

  // 下拉刷新状态
  // 0下拉刷新、1松开刷新、2正在刷新、3刷新成功
  pullRefreshState(state:number){
    switch (state) {
      case 0:
      // 初始状态
        this.pullRefreshText = '下拉刷新'
        this.pullRefreshImage = $r("app.media.ic_me_normal")
        this.isCanRefresh = false
        this.isRefreshing = false
        break;
      case 1:
        this.pullRefreshText = '松开刷新'
        this.pullRefreshImage = $r("app.media.ic_me_checked")
        this.isCanRefresh = true
        this.isRefreshing = false
        break;
      case 2:
        this.offsetY = vp2px(this.pullRefreshHeight)
        this.pullRefreshText = '正在刷新'
        this.pullRefreshImage = $r("app.media.ic_tv_normal")
        this.isCanRefresh = true
        this.isRefreshing = true
        break;
      case 3:
        this.pullRefreshText = '刷新成功'
        this.pullRefreshImage = $r("app.media.ic_tv_checked")
        this.isCanRefresh = true
        this.isRefreshing = true
        break;
    }
  }

  // 关闭刷新
  closeRefresh() {
    // 如果允许刷新，延迟进入，为了显示刷新中
    setTimeout(() => {
      var delay = 50
      if (this.isCanRefresh) {
        // 状态3：刷新成功
        this.pullRefreshState(3)
        // 为了显示刷新成功，延迟执行收缩动画
        delay = 500
      }
      animateTo({
        duration: 150, // 动画时长
        delay: delay, // 延迟时长
        onFinish: () => {
          // 状态0：下拉刷新
          this.pullRefreshState(0)
          this.isPullRefreshOperation = false
        }
      }, () => {
        this.offsetY = 0
      })
    }, this.isCanRefresh ? 500 : 0)
  }

  //============================================加载更多==================================================
  // 手指移动，处理加载更多
  touchMoveLoadMore(event:TouchEvent) {
    // 因为加载更多是在列表后面新增一个item，当一屏能够展示全部列表，endIndex 为 length+1
    if (this.endIndex == this.followList.length - 1 || this.endIndex == this.followList.length) {
      // 滑动的偏移量
      this.offsetY = event.touches[0].y - this.downY
      if (Math.abs(this.offsetY) > vp2px(this.loadMoreHeight)/2) {
        // 可以刷新了
        this.isCanLoadMore = true
        // 显示加载更多布局
        this.isVisibleLoadMore = true
        // 偏移量缓慢增加
        this.offsetY = - vp2px(this.loadMoreHeight) + this.offsetY * 0.1
      }
    }
  }

  // 手指抬起，处理加载更多
  touchUpLoadMore() {
    animateTo({
      duration: 200, // 动画时长
    }, () => {
      // 偏移量设置为0
      this.offsetY = 0
    })
    if (this.isCanLoadMore) {
      console.info('======执行加载更多========')
      // 加载中...
      this.isLoading = true
      // 耗时操作
      this.loadMoreData()
    } else {
      console.info('======关闭加载更多！未达到条件========')
      this.closeLoadMore()
    }
  }

  // 关闭加载更多
  closeLoadMore() {
    this.isCanLoadMore = false
    this.isLoading = false
    this.isVisibleLoadMore = false
  }
}