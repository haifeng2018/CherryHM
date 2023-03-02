import { DailyPagerItemContent } from './DailyPagerItemContent';
import { DailyPagerItemHeader } from './DailyPagerItemHeader';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DailyPagerItemData
 * Author: Victor
 * Date: 2023/3/2 10:22
 * Description: 
 * -----------------------------------------------------------------
 */
 export class DailyPagerItemData {
  dataType: string
  type: string
  text: string
  subTitle: string
  actionUrl: string
  adTrack: string
  follow: string
  id: number
  header: DailyPagerItemHeader
  content: DailyPagerItemContent
 }