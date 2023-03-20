/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DiscoveryApi
 * Author: Victor
 * Date: 2023/3/2 14:22
 * Description: 
 * -----------------------------------------------------------------
 */

export class DiscoveryApi {
  static readonly DISCOVERY = 'http://baobab.kaiyanapp.com/api/v7/index/tab/discovery'
  static readonly CATEGORY_DETAIL = 'http://baobab.kaiyanapp.com/api/v4/categories/videoList?udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=hm&id='
  static readonly FOLLOW = 'http://baobab.kaiyanapp.com/api/v4/tabs/follow'
  static readonly CATEGORY = 'http://baobab.kaiyanapp.com/api/v4/categories'
  static readonly TOPICS = 'http://baobab.kaiyanapp.com/api/v3/specialTopics'
  static readonly LIGHT_TOPICS = 'http://baobab.kaiyanapp.com/api/v3/lightTopics/internal/'
  static readonly NEWS = 'http://baobab.kaiyanapp.com/api/v7/information/list?vc=6030000&deviceModel=HM'
  static readonly RECOMMEND = 'http://baobab.kaiyanapp.com/api/v7/community/tab/rec'
  static readonly AUTH = '&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=hm'
  static readonly NEWS_AUTH = '&vc=6030000&deviceModel=hm'
}
