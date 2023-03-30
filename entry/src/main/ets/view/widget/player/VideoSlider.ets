import Constants from '../../../util/Constants';
import { sliderOnchange } from '../../../model/VideoControll';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: VideoSlider
 * Author: Victor
 * Date: 2023/3/30 11:41
 * Description: 
 * -----------------------------------------------------------------
 */
@Component
export struct VideoSlider {
  @Consume isOpacity: boolean;
  private controller: VideoController;
  @Consume  sliderStartTime: string;
  @Consume  currentTime: number;
  @Consume durationTime: number ;
  @Consume durationStringTime: string ;
  @Consume isPlay: boolean;

  build() {
    Row({ space: 12 }) {
      Text(this.sliderStartTime)
        .fontSize($r('app.float.fp_12'))
        .margin({ left: $r('app.float.vp_12') })
        .fontColor(Color.White)
      Slider({
        value: this.currentTime,
        min: 0,
        max: this.durationTime,
        step: 1,
        style: SliderStyle.OutSet
      })
        .blockColor($r('app.color.white'))
        .width('70%')
        .trackColor(Color.Gray)
        .selectedColor($r("app.color.white"))
        .showSteps(true)
        .showTips(true)
        .trackThickness(this.isOpacity ? 2 : 4)
        .onChange((value: number, mode: SliderChangeMode) => {
          sliderOnchange.call(this, value, mode);
        })
      Text(this.durationStringTime)
        .fontSize($r('app.float.fp_12'))
        .margin({ right: $r('app.float.vp_12') })
        .fontColor(Color.White)
    }
    .opacity(this.isOpacity ? 0.2 : 1)
    .width(Constants.MATCH_PARENT)
    .backgroundColor($r('app.color.color_66000000'))
  }
}