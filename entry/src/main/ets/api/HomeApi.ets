/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeApi
 * Author: Victor
 * Date: 2023/3/1 16:36
 * Description: 
 * -----------------------------------------------------------------
 */

export class HomeApi {
  static readonly DISCOVERY = 'http://baobab.kaiyanapp.com/api/v7/index/tab/discovery?udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&vc=6030000&deviceModel=hm'
  static readonly FOLLOW = 'http://baobab.kaiyanapp.com/api/v6/community/tab/follow'
  static readonly DAILY_PAPER = 'http://baobab.kaiyanapp.com/api/v5/index/tab/feed'
  static readonly HOT_KEYWORD = 'http://baobab.kaiyanapp.com/api/v3/queries/hot'

  static readonly TAG = 'http://baobab.kaiyanapp.com/api/v7/tag/tabList'//
  static readonly RECOMMEND = 'http://baobab.kaiyanapp.com/api/v5/index/tab/allRec'//
}
