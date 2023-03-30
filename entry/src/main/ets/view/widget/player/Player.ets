import { StackStyle } from '../../../bean/StackStyle';
import { iconOnclick } from '../../../model/VideoControll';
import { VideoSlider } from './VideoSlider';
import { videoOnclick } from '../../../model/VideoControll';
import promptAction from '@ohos.promptAction';
import { finish } from '../../../model/VideoControll';
import { prepared } from '../../../model/VideoControll';
import { changeSliderTime } from '../../../model/VideoControll';
import Constants from '../../../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: Player
 * Author: Victor
 * Date: 2023/3/30 11:46
 * Description: 
 * -----------------------------------------------------------------
 */
@Component
export struct Player {
  @Consume playUrl: string;
  private controller: VideoController;
  private previewUris: Resource;
  private isUseDefaultControl: boolean = false;
  @Provide currentTime: number = 0;
  @Provide durationTime: number = 0;
  @State playerAspectRatio: number = 16 / 10;
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @Provide durationStringTime: string = Constants.START_TIME;
  @Provide sliderStartTime: string = Constants.START_TIME;
  @State isAutoPlay: boolean = true
  @Consume isPlay: boolean;
  @Consume isOpacity: boolean;
  @Consume flag: boolean;
  @Consume isLoading: boolean;
  @Consume progressVal: number;

  build() {
    Stack() {
      Video({
        src: this.playUrl,
        previewUri: this.previewUris,
        currentProgressRate: this.curRate,
        controller: this.controller
      })
        .width(Constants.MATCH_PARENT)
        .aspectRatio(this.playerAspectRatio)
        .controls(this.isUseDefaultControl)
        .autoPlay(this.isAutoPlay)
        .objectFit(ImageFit.Contain)
        .loop(false)
        .onUpdate((event) => {
          this.currentTime = event.time;
          this.sliderStartTime = changeSliderTime(this.currentTime);
        })
        .onPrepared((event) => {
          prepared.call(this, event);
        })
        .onFinish(() => {
          finish.call(this);
        })
        .onError(() => {
          promptAction.showToast({
            duration: Constants.COMMON_NUM_DURATION,
            message: '请检查网络'
          });
        })
        .onClick(() => {
          videoOnclick.call(this);
        })

      VideoSlider({ controller: this.controller })

      if (this.isLoading) {
        Progress({
          value: StackStyle.PROGRESS_VALUE,
          total: StackStyle.PROGRESS_TOTAL,
          type: ProgressType.ScaleRing
        })
          .color(Color.Grey)
          .value(this.progressVal)
          .width(StackStyle.PROGRESS_WIDTH)
          .style({
            strokeWidth: StackStyle.PROGRESS_STROKE_WIDTH,
            scaleCount: StackStyle.PROGRESS_SCALE_COUNT,
            scaleWidth: StackStyle.PROGRESS_SCALE_WIDTH
          })
      }
    }
    .backgroundColor($r('app.color.black'))
    .alignContent(Alignment.Bottom)
  }
}