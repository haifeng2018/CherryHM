import { ConsumptionInfo } from './ConsumptionInfo';
import { AuthorInfo } from './AuthorInfo';
import { CoverInfo } from './CoverInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: WeeklyRankingItemData
 * Author: Victor
 * Date: 2023/3/2 16:04
 * Description: 
 * -----------------------------------------------------------------
 */
export class WeeklyRankingItemData {
  dataType: string
  id: number
  title: string
  description: string
  releaseTime: number
  playUrl: string
  cover: CoverInfo
  author: AuthorInfo
  consumption: ConsumptionInfo
}