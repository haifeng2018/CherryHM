import { DailyPagerInfo } from './DailyPagerInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DailyPagerData
 * Author: Victor
 * Date: 2023/3/2 10:17
 * Description: 
 * -----------------------------------------------------------------
 */
 export class DailyPagerData {
  count: number
  total: number
  nextPageUrl: string
  adExist: boolean
  itemList: Array<DailyPagerInfo>
 }