@CustomDialog
export struct LoadingDialog {
  private hint = $r('app.string.loading')
  controller: CustomDialogController
  @State angle: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image($r("app.media.ic_loading"))
        .width($r('app.float.vp_50'))
        .height($r('app.float.vp_50'))
        .rotate({
          x: 0,
          y: 0,
          z: 1,
          angle: this.angle,
          centerX: '50%',
          centerY: '50%'
        })
        .animation({
          duration: 1500,
          iterations: -1,
        })
        .onAppear(() => {
          this.angle = 360
        })

      Text(this.hint)
        .fontSize($r('app.float.fp_16'))
        .fontColor(Color.White)
    }.width(100).height(100)
    .backgroundColor($r('app.color.color_B3000000'))
    .borderRadius(10)
  }
}