/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: Constants
 * Author: Victor
 * Date: 2022/12/8 14:27
 * Description: 
 * -----------------------------------------------------------------
 */

export default class Constants {

  static readonly DATA = 'data';
  static readonly TITLE = 'title';
  static readonly URL = 'url';
  static readonly SHARE_ID = 'shareId';
  static readonly TOPIC_ID = 'topicId';
  static readonly USER_ID = 'userId';

  static readonly TRANSPARENT_COLOR: string = '#00ffffff';

  /**
   * Preference saved key.
   */
  static readonly PREFERENCES_KEY_PRIVACY: string = 'isPrivacy';

  /**
   * Preference saved file name.
   */
  static readonly PREFERENCES_FILE_NAME: string = 'myStore';

  /**
   * Launcher page count down.
   */
  static readonly LAUNCHER_DELAY_TIME: number = 1000;

  /**
   * Interval execution time.
   */
  static readonly AD_INTERVAL_TIME: number = 1000;

  /**
   * Width or Height the percentage of the 100.
   */
  static readonly MATCH_PARENT: string = '100%';
  static readonly INTENT_DATA_KEY: string = 'data';

  static readonly POSTER_DETAIL_TRANSITION_ID = 'posterDetailShareId';
  static readonly TRANSITION_ANIMATION_DURATION: number = 500;
  static readonly SHARE_ITEM_ANIMATION_DELAY = 100;

  /**
   * the divide of single and double
   */
  static readonly COMMON_NUM_DOUBLE: number = 10;

  /**
   * the minute of one hour
   */
  static readonly COMMON_NUM_MINUTE: number = 60;

  /**
   * video net address
   */
  static readonly ZERO_STR: string = '0';

  /**
   * time split
   */
  static readonly SPLIT: string = ':';

  /**
   * init time of string
   */
  static readonly START_TIME: string = '00:00';

  /**
   * toast duration
   */
  static readonly COMMON_NUM_DURATION: number = 5000;

  static readonly USER_SERVICES_AGREEMENT: string = 'https://github.com/haifeng2018/CherryHM';
  static readonly PRIVACY_POLICY: string = 'https://gitee.com/victor1990/CherryHM';

}