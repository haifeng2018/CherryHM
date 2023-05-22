@Entry
@Component
struct Widget4x4Card {
  /*
   * The action type.
   */
  readonly ACTION_ROUTER: string = 'router';
  readonly ACTION_MESSAGE: string = 'message';

  /*
   * The ability name.
  */
  readonly ABILITY_NAME: string = 'EntryAbility';

  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';
  readonly REFRESH_WIDGET_MESSAGE: string = 'REFRESH_WIDGET';

  /*
   * The mini display priority.
   */
  readonly MINI_DISPLAY_PRIORITY: number = 2;

  /*
   * The max line.
   */
  readonly MAX_LINES: number = 1;

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  /*
   * Image height percentage setting.
   */
  readonly IMAGE_HEIGHT_PERCENT: string = '80%';

  @LocalStorageProp('mini_title') miniTitle: string = '旅行';
  @LocalStorageProp('title') title: string = '旅行';
  @LocalStorageProp('content') content: string = '世界这么大，总有你的目的地';
  @LocalStorageProp('poster') poster: Resource = $r("app.media.default_img");

  build() {
    Row() {
      Column() {
        Image(this.poster)
          .width(this.FULL_WIDTH_PERCENT)
          .height(this.IMAGE_HEIGHT_PERCENT)
          .objectFit(ImageFit.Cover)
          .borderRadius($r('app.float.vp_10'))

        Blank()

        Row() {
          Text(this.title)
            .layoutWeight(1)
            .fontSize($r('app.float.fp_22'))
            .maxLines(1)
            .textOverflow({overflow:TextOverflow.Ellipsis})
          Image($r("app.media.ic_widget_refresh"))
            .width("30vp")
            .height("30vp")
            .onClick(() => {
              postCardAction(this, {
                "action": this.ACTION_MESSAGE,
                "abilityName": this.ABILITY_NAME,
                "params": {
                  "message": this.REFRESH_WIDGET_MESSAGE
                }
              });
            })
        }.width(this.FULL_WIDTH_PERCENT)

        Text(this.content)
          .maxLines(this.MAX_LINES)
          .margin({top:$r("app.float.vp_10")})
          .fontSize($r('app.float.fp_18'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(this.FULL_HEIGHT_PERCENT)
      .alignItems(HorizontalAlign.Start)
      .backgroundColor($r('app.color.white'))
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .alignItems(VerticalAlign.Top)
    .padding($r('app.float.row_padding'))
    .onClick(() => {
      postCardAction(this, {
        "action": this.ACTION_ROUTER,
        "abilityName": this.ABILITY_NAME,
        "params": {
          "message": this.MESSAGE
        }
      });
    })
  }
}