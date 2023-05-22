@Entry
@Component
struct Widget1x2Card {
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
      Text(this.title)
        .layoutWeight(1)
        .height(this.FULL_HEIGHT_PERCENT)
        .margin({right:$r("app.float.vp_10")})
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.fp_18'))
        .maxLines(1)
        .textOverflow({overflow:TextOverflow.Ellipsis})

      Image($r("app.media.ic_widget_play"))
        .height(this.FULL_HEIGHT_PERCENT)
        .aspectRatio(1.0)
        .objectFit(ImageFit.Contain)
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