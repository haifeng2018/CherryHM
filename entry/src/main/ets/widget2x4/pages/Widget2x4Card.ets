@Entry
@Component
struct Widget2x4Card {
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
  readonly MAX_LINES: number = 2;

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
  readonly IMAGE_WEIGHT_PERCENT: string = '36%';

  @LocalStorageProp('mini_title') miniTitle: string = '旅行';
  @LocalStorageProp('title') title: string = '旅行';
  @LocalStorageProp('content') content: string = '世界这么大，总有你的目的地';
  @LocalStorageProp('poster') poster: Resource = $r("app.media.default_img");

  build() {
    Row() {
      Image(this.poster)
        .width(this.IMAGE_WEIGHT_PERCENT)
        .height(this.FULL_HEIGHT_PERCENT)
        .objectFit(ImageFit.Cover)
        .borderRadius($r('app.float.vp_10'))

      Column() {
        Row() {
          Text(this.title)
            .layoutWeight(1)
            .fontSize($r('app.float.fp_28'))
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
        }.width(this.FULL_WIDTH_PERCENT).layoutWeight(1)

        Text(this.content)
          .width(this.FULL_WIDTH_PERCENT)
          .layoutWeight(1)
          .maxLines(this.MAX_LINES)
          .textAlign(TextAlign.Start)
          .fontSize($r('app.float.fp_16'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .height(this.FULL_HEIGHT_PERCENT)
      .margin({left:$r("app.float.vp_20")})
      .justifyContent(FlexAlign.Center)
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