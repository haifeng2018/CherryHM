import Constants from '../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: TvTabContent
 * Author: Victor
 * Date: 2023/2/27 15:14
 * Description: 
 * -----------------------------------------------------------------
 */
@Component
export struct TvTabContent {

  @State isRefreshing: boolean = false

  private timetable: any = [
    {
      title:'星期一',
      projects:['语文', '数学', '英语']
    },
    {
      title:'星期二',
      projects:['物理', '化学', '生物']
    },
    {
      title:'星期三',
      projects:['历史', '地理', '政治']
    },
    {
      title:'星期四',
      projects:['美术', '音乐', '体育']
    },
    {
      title:'星期五',
      projects:['Photoshop', '鸿蒙app开发']
    },
    {
      title:'星期六',
      projects:['放假']
    },
    {
      title:'星期日',
      projects:['放假']
    }
  ]

  @Builder itemHead(text:string) {
    Text(text)
      .fontSize(28)
      .backgroundColor($r('app.color.color_999999'))
      .width(Constants.MATCH_PARENT)
  }

  @Builder itemFoot(num:number) {
    Text('共' + num + "节课")
      .fontSize(10)
      .backgroundColor($r('app.color.color_666666'))
      .width(Constants.MATCH_PARENT)
      .padding(5)
  }

  build() {
    Column() {
      Stack(){
        Text($r('app.string.tab_hot'))
          .width(Constants.MATCH_PARENT)
          .height('56vp')
          .fontSize($r('app.float.fp_20'))
          .fontColor($r('app.color.color_333333'))
          .fontWeight(500)
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_primary'))
        Image($r('app.media.ic_share'))
          .width('30vp')
          .height('30vp')
          .align(Alignment.End)
          .margin({right:'24vp'})
      }
      .width(Constants.MATCH_PARENT)
      .backgroundColor($r('app.color.color_primary_dark'))
      .alignContent(Alignment.End)
      .padding({top:'36vp'})

      Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
        Column() {
          List({ space: 20 }) {
            ForEach(this.timetable, (item) => {
              ListItemGroup({ header:this.itemHead(item.title), footer:this.itemFoot(item.projects.length) }) {
                ForEach(item.projects, (project) => {
                  ListItem() {
                    Text(project)
                      .width(Constants.MATCH_PARENT).height(100).fontSize(20)
                      .textAlign(TextAlign.Center).backgroundColor(0xFFFFFF)
                  }
                }, item => item)
              }
              .borderRadius(20)
              .divider({ strokeWidth: 1, color: $r('app.color.color_0091FF') }) // 每行之间的分界线
            })
          }
          .width(Constants.MATCH_PARENT)
          .sticky(StickyStyle.Header|StickyStyle.Footer)
        }.width(Constants.MATCH_PARENT).height(Constants.MATCH_PARENT).backgroundColor(0xDCDCDC).padding({ top: 5 })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 1000)
        console.log('onRefreshing test')
      })
    }
  }
}