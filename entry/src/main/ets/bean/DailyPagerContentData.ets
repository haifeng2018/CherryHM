import { ConsumptionInfo } from './ConsumptionInfo';
import { AuthorInfo } from './AuthorInfo';
import { CoverInfo } from './CoverInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DailyPagerContentData
 * Author: Victor
 * Date: 2023/3/2 10:29
 * Description: 
 * -----------------------------------------------------------------
 */
 export class DailyPagerContentData {
  id: number;
  releaseTime: number;
  title: string;
  description: string;
  playUrl: string;
  cover: CoverInfo;
  author: AuthorInfo;
  consumption: ConsumptionInfo;
 }