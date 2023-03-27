import { VideoCellContentInfo } from '../bean/VideoCellContentInfo';
import { UserPageData } from '../bean/UserPageData';
import RouterPath from '../util/RouterPath';
import { VideoInfo } from '../bean/VideoInfo';
import Constants from '../util/Constants';
import promptAction from '@ohos.promptAction';
import { AuthApi } from '../api/AuthApi';
import RefreshComponent from '../view/widget/refresh/RefreshComponent';
import { RefreshConfig } from '../view/widget/refresh/RefreshConfig';
import router from '@ohos.router';
import HttpRequest from '../util/HttpRequest';
import UrlUtil from '../util/UrlUtil';
import { PageState } from '../view/widget/refresh/PageState';

@Entry
@Component
struct UserPage {

  userId: string = router.getParams()?.['userId'];

  @State data: UserPageData = null;
  @State datas: Array<any> = [];
  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  private tabTitles = [{ id: 0, name: '首页' }, { id: 1, name: '作品' }, { id: 2, name: '动态' }]
  @State currentIndex: number = 0

  aboutToAppear() {
    this.sendUserInfoRequest()
  }

  sendUserInfoRequest () {
    HttpRequest.url = `${AuthApi.USER_INFO}${this.userId}&userType=${this.getUserType()}`
    HttpRequest.request({
      onSuccess: (value) => {
        this.pageState = PageState.Success;
        this.data = value
        this.sendUserProfileRequest()
      },
      onFail: (errorCode) => {
        this.pageState = PageState.Fail
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  sendUserProfileRequest () {
    HttpRequest.url = `${AuthApi.USER_PROFILE}${this.userId}&userType=${this.getUserType()}`
    HttpRequest.request({
      onSuccess: (value) => {
        this.datas = value.itemList
      },
      onFail: (errorCode) => {
        promptAction.showToast({ message: 'errorCode = ' + errorCode});
      }
    })
  }

  build() {
    Column() {
      this.titleBar()

      RefreshComponent({
        itemLayout: () => this.itemLayout(),
        onRefresh: () => {
          this.sendUserInfoRequest()
        }
      })
        .width(Constants.MATCH_PARENT)
        .layoutWeight(1)
        .zIndex(0)
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder itemLayout () {
    List() {
      ListItem() {
        this.headerLayout()
      }
      ListItem() {
        this.contentLayout()
      }
    }
    .width(Constants.MATCH_PARENT)
    .height(Constants.MATCH_PARENT)
    // 去掉回弹效果
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      // 监听当前列表首位索引
      this.listScrollTop = start === 0
    })
  }

  @Builder headerLayout () {
    Stack() {
      Image(this.getHeadUrl())
        .width(Constants.MATCH_PARENT)
        .height('200vp')
        .blur(98)

      Column() {
        Row() {
          Image(this.data.pgcInfo.icon)
            .width('80vp')
            .height('80vp')
            .clip(new Circle({ width: '80vp', height: '80vp' }))
            .border({ width: '2vp',color:$r('app.color.color_80DDDDDD'),radius:'40vp',style:BorderStyle.Solid })

          Text(this.data.pgcInfo.description)
            .layoutWeight(1)
            .margin({top:'40vp',left:'10vp',right:'10vp'})
            .fontColor($r('app.color.color_666666'))
            .fontSize('22fp')
            .textAlign(TextAlign.Start)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .padding({left:'30vp'})
        .alignItems(VerticalAlign.Top)

        Row() {
          Text(`作品：${this.data.pgcInfo.videoCount}`)
            .height(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .fontColor($r('app.color.color_333333'))
            .fontSize('18fp')
            .textAlign(TextAlign.Center)

          Text(`分享：${this.data.pgcInfo.shareCount}`)
            .height(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .fontColor($r('app.color.color_333333'))
            .fontSize('18fp')
            .textAlign(TextAlign.Center)

          Text(`收藏：${this.data.pgcInfo.collectCount}`)
            .height(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .fontColor($r('app.color.color_333333'))
            .fontSize('18fp')
            .textAlign(TextAlign.Center)
        }
        .width(Constants.MATCH_PARENT)
        .height('50vp')

        Text(this.data.pgcInfo.brief)
          .width(Constants.MATCH_PARENT)
          .padding('10vp')
          .fontColor($r('app.color.color_333333'))
          .fontSize('18fp')
          .textAlign(TextAlign.Start)

      }
      .width(Constants.MATCH_PARENT)
      .margin({top:'160vp'})
    }
    .width(Constants.MATCH_PARENT)
    .alignContent(Alignment.Top)
  }

  @Builder contentLayout () {
    Column() {
      ForEach(this.datas, (data) => {
        if (data.type === 'videoCollectionOfHorizontalScrollCard') {
          this.horizontalScrollCardCell(data)
        } else if (data.type === 'textHeader') {
          this.headCell(data.data.text)
        } else if (data.type === 'video') {
          this.videoSmallCardCell(data)
        } else if (data.type === 'briefCard') {
          this.briefCardCell(data)
        } else if (data.type === 'DynamicInfoCard') {
          this.dynamicInfoCardCell(data)
        } else if (data.type === 'videoCollectionWithBrief') {
          this.videoCollectionWithBriefCell(data)
        }
      })
    }
    .width(Constants.MATCH_PARENT)
    .padding('10vp')
  }

  @Builder TabBuilder(index: number) {
    Stack() {
      Text(this.tabTitles[index].name)
        .height(Constants.MATCH_PARENT)
        .padding('12vp')
        .fontSize(this.currentIndex === index ? '22fp' : '20fp')
        .fontWeight(this.currentIndex === index ? 700 : 500)
        .fontColor(this.currentIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))

      Divider()
        .strokeWidth('5vp')
        .width('20vp')
        .color($r('app.color.color_333333'))
        .opacity(this.currentIndex === index ? 1 : 0)

    }
    .alignContent(Alignment.Bottom)
  }

  @Builder horizontalScrollCardCell(info: VideoInfo) {
    this.headCell(info.data.header.title)
    List({ space: 10 }) {
      ForEach(info.data.itemList, (data) => {
        ListItem() {
          this.horizontalScrollCardItem(data)
        }
        .width('320vp')
      })
    }
    .listDirection(Axis.Horizontal)
    .backgroundColor($r('app.color.color_F9F9F9'))
    .width(Constants.MATCH_PARENT)
    .height('168vp')
  }

  @Builder horizontalScrollCardItem(data: VideoCellContentInfo) {
    Stack(){
      Image(data.data.cover.feed)
        .objectFit(ImageFit.Cover)
        .width(Constants.MATCH_PARENT)
        .height(Constants.MATCH_PARENT)
        .borderRadius('10vp')

      Text(data.data.title)
        .width(Constants.MATCH_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize('18fp')
        .fontColor($r('app.color.white'))

    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({bottomLeft:'10vp',bottomRight:'10vp'})
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.VIDEO_DETAIL_PAGE,
        params: {
          data:data.data,
          shareId: `${this.datas.indexOf(data)}${data.data.id}`
        }
      })
    })
  }

  @Builder headCell(title: string) {
    Text(title)
      .width(Constants.MATCH_PARENT)
      .height('56vp').fontSize('22fp')
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.color_666666'))
  }

  @Builder videoSmallCardCell(info: VideoInfo) {
    Stack(){
      Row() {
        Image(info.data.cover.detail)
          .width('168vp')
          .height(Constants.MATCH_PARENT)
          .borderRadius({topLeft:'10vp',bottomLeft:'10vp'})

        Column() {
          Text(info.data.category)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.End)
            .fontColor($r('app.color.color_666666'))
            .fontSize('18fp')
            .padding({ right:'10vp' })

          Text(info.data.title)
            .width(Constants.MATCH_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize('16fp')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ bottom:'10vp',left:'30vp',right: '10vp' })
            .align(Alignment.Bottom)

        }
        .height(Constants.MATCH_PARENT)
        .layoutWeight(1)

      }
      .width(Constants.MATCH_PARENT)
      .height(Constants.MATCH_PARENT)

      if (info.data.author != null && info.data.author.icon != null) {
        Image(info.data.author.icon)
          .width('40vp')
          .height('40vp')
          .margin({left:'148vp'})
          .clip(new Circle({ width: '40vp', height: '40vp' }))
      }
    }
    .width(Constants.MATCH_PARENT)
    .height('118vp')
    .margin({top:'5vp',bottom:'5vp'})
    .backgroundColor($r('app.color.white'))
    .borderRadius('10vp')
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .alignContent(Alignment.Start)
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

  @Builder videoCollectionWithBriefCell(info: VideoInfo) {
    Column() {
      Swiper() {
        ForEach(info.data.itemList, item => {
          Image(item.data.cover.feed)
            .width(Constants.MATCH_PARENT)
            .height(Constants.MATCH_PARENT)
            .borderRadius('10vp')
            .onClick(() => {
              router.pushUrl({
                url: RouterPath.VIDEO_DETAIL_PAGE,
                params: {
                  data:item.data,
                  shareId: `${this.datas.indexOf(info)}${item.data.id}`
                }
              })
            })
        })
      }
      .width(Constants.MATCH_PARENT)
      .height('198vp')
      .cachedCount(info.data.itemList.length)
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

     this.authorLayout(info)
    }
  }

  @Builder briefCardCell(info: VideoInfo) {
    Row() {
      Image(info.data.icon)
        .width('60vp')
        .height('60vp')
        .clip(new Circle({ width: '60vp', height: '60vp' }))

      Column() {
        Text(info.data.title)
          .width(Constants.MATCH_PARENT)
          .margin({ left: '10vp' })
          .fontColor($r('app.color.color_333333'))
          .fontSize('20fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)

        Text(info.data.description)
          .width(Constants.MATCH_PARENT)
          .margin({ left: '10vp' })
          .fontColor($r('app.color.color_666666'))
          .fontSize('18fp')
          .padding('2vp')
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)

      Text('+关注')
        .margin({ left: '5vp' })
        .padding({ top: '4vp', bottom: '4vp', left: '10vp', right: '10vp' })
        .fontColor($r('app.color.color_666666'))
        .fontSize('18fp')
        .border({ width: '1vp', color: $r('app.color.color_666666'), radius: '5vp', style: BorderStyle.Solid })
    }
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .margin({ top: '5vp', bottom: '5vp' })
    .padding('10vp')
    .borderRadius('10vp')
    .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
    .onClick(() => {
      router.pushUrl({
        url: RouterPath.WEB_PAGE,
        params: {
          title: info.data.title.replace('#', ''),
          url: UrlUtil.getUrl(info.data.actionUrl),
        },
      })
    })
  }

  @Builder authorLayout(info: VideoInfo) {
    Row(){
      Image(info.data.header.icon)
        .width('40vp')
        .height('40vp')
        .clip(new Circle({ width: '40vp', height: '40vp' }))

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
    .padding({top:'10vp',bottom:'20vp',left:'20vp',right:'20vp'})
  }

  @Builder dynamicInfoCardCell (info: VideoInfo) {
    Row() {
      Image(info.data.user.avatar)
        .width('30vp')
        .height('30vp')
        .clip(new Circle({ width: '30vp', height: '30vp' }))

      Column() {
        Row() {
          Text(info.data.user.nickname)
            .fontColor($r('app.color.color_333333'))
            .fontSize('18fp')
            .textAlign(TextAlign.Start)

          Text(info.data.text)
            .layoutWeight(1)
            .fontColor($r('app.color.color_666666'))
            .fontSize('18fp')
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

        Text(info.data.reply.message)
          .width(Constants.MATCH_PARENT)
          .fontColor($r('app.color.color_666666'))
          .fontSize('18fp')
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

         if (info.data.reply.parentReply != null) {
           Column() {
             Row() {
               Image(info.data.reply.parentReply.user.avatar)
                 .width('20vp')
                 .height('20vp')
                 .clip(new Circle({ width: '20vp', height: '20vp' }))

               Text(info.data.reply.parentReply.user.nickname)
                 .width(Constants.MATCH_PARENT)
                 .fontColor($r('app.color.color_333333'))
                 .fontSize('18fp')
                 .padding('2vp')
                 .textAlign(TextAlign.Start)
             }
             .width(Constants.MATCH_PARENT)
             .margin('5vp')

             Text(info.data.reply.parentReply.message)
               .width(Constants.MATCH_PARENT)
               .padding('5vp')
               .fontColor($r('app.color.color_666666'))
               .fontSize('18fp')
               .textAlign(TextAlign.Start)
           }
           .margin({top:'10vp'})
           .padding('5vp')
           .borderRadius('10vp')
           .backgroundColor($r('app.color.color_DDDDDD'))
         }
      }
      .width(Constants.MATCH_PARENT)
      .margin({left:'5vp'})
      .padding('10vp')
      .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
  }

  getHeadUrl (): string {
    let cover = this.data.pgcInfo.cover
    if (cover == null) {
      cover =  this.data.pgcInfo.icon
    }
    return cover
  }

  getUserType (): string {
    let userType = 'PGC'
    if (userType.length >= 4) {
      userType = 'NORMAL'
    }
    return userType
  }

  @Builder titleBar() {
    if (this.data != null && this.data.pgcInfo != null) {
      Row(){
        Image($r('app.media.ic_back'))
          .width('30vp')
          .height('30vp')
          .objectFit(ImageFit.Contain)
          .margin({left:'14vp'})
          .onClick(() =>{
            router.back()
          })

        Marquee({
          start: true,
          step: 20,
          loop: Infinity,
          fromStart: true,
          src: this.data.pgcInfo.name
        })
          .width(Constants.MATCH_PARENT)
          .height('56vp')
          .layoutWeight(1)
          .fontSize($r('app.float.fp_24'))
          .fontColor($r('app.color.color_333333'))
          .fontWeight(500)
          .onStart(() => {
            console.info('Marquee animation complete onStart')
          })
          .onBounce(() => {
            console.info('Marquee animation complete onBounce')
          })
          .onFinish(() => {
            console.info('Marquee animation complete onFinish')
          })

        Image($r('app.media.ic_share'))
          .width('30vp')
          .height('30vp')
          .align(Alignment.End)
          .margin({right:'24vp'})
      }
      .width(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.white'))
      .padding({top:$r('app.float.status_bar_height')})
      .shadow({ radius: 10, color: $r('app.color.color_1400001E'), offsetX: 10, offsetY: 20 })
      .zIndex(1)
    }

  }

}