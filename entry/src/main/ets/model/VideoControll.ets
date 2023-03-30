import { StackStyle } from '../bean/StackStyle';
import Constants from '../util/Constants';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: VideoControll
 * Author: Victor
 * Date: 2023/3/30 11:33
 * Description: 
 * -----------------------------------------------------------------
 */

/**
 * video component prepared callback
 */
export function prepared(event) {
  this.isLoading = false
  this.durationTime = event.duration;
  let second: number = event.duration % Constants.COMMON_NUM_MINUTE;
  let min: number = parseInt((event.duration / Constants.COMMON_NUM_MINUTE).toString());
  let head = min < Constants.COMMON_NUM_DOUBLE ? `${Constants.ZERO_STR}${min}` : min;
  let end = second < Constants.COMMON_NUM_DOUBLE ? `${Constants.ZERO_STR}${second}` : second;
  this.durationStringTime = `${head}${Constants.SPLIT}${end}`;
  this.flag = true;
};

/**
 * video component finish callback
 */
export function finish() {
  this.isPlay = false;
  this.isOpacity = false;
};

/**
 * video component onclick callback
 */
export function videoOnclick() {
  if (!this.isPlay) {
    this.controller.start();
    this.isPlay = true;
    this.isOpacity = true;
  } else {
    this.controller.pause()
    this.isPlay = false;
    this.isOpacity = false;
  }
};

/**
 * video slider component onchange callback
 */
export function sliderOnchange(value: number, mode: SliderChangeMode) {
  this.currentTime = parseInt(value.toString());
  this.controller.setCurrentTime(parseInt(value.toString()), SeekMode.Accurate);
  if (mode === SliderChangeMode.Begin) {
    this.isOpacity = false;
  }
  if (mode === SliderChangeMode.Moving) {
    this.isOpacity = false;
  }
  if (mode === SliderChangeMode.End) {
    this.isOpacity = true;
  }
};

/**
 * get video  string of current time
 * @param  the number of current time
 * @return the string of current time
 */
export function changeSliderTime(value: number): string {
  let second: number = value % Constants.COMMON_NUM_MINUTE;
  let min: number = parseInt((value / Constants.COMMON_NUM_MINUTE).toString());
  let head = min < Constants.COMMON_NUM_DOUBLE ? `${Constants.ZERO_STR}${min}` : min;
  let end = second < Constants.COMMON_NUM_DOUBLE ? `${Constants.ZERO_STR}${second}` : second;
  let nowTime = `${head}${Constants.SPLIT}${end}`;
  return nowTime;
};

/**
 * icon onclick callback
 */
export function iconOnclick() {
  if(this.flag) {
    this.controller.start();
    this.isPlay = true;
    this.isOpacity = true;
  } else {
    let that = this;
    that.isLoading = true;
    // The video loading is not complete. The loading action is displayed.
    let intervalLoading = setInterval(function() {
      if (that.progressVal >= StackStyle.PROGRESS_TOTAL) {
        that.progressVal = 0;
      } else {
        that.progressVal += StackStyle.PROGRESS_STEP;
      }
    }, StackStyle.MILLI_SECONDS)
    // The scheduled task determines whether the video loading is complete.
    let intervalFlag = setInterval(function() {
      if (that.flag) {
        that.controller.start();
        that.isPlay = true;
        that.isOpacity = true;
        that.isLoading = false;
        clearInterval(intervalFlag);
        clearInterval(intervalLoading);
      }
    }, StackStyle.MILLI_SECONDS);
  }
};