import { CoverInfo } from './CoverInfo';
import { AuthorInfo } from './AuthorInfo';
import { ConsumptionInfo } from './ConsumptionInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: VideoCellContentData
 * Author: Victor
 * Date: 2023/3/3 16:46
 * Description: 
 * -----------------------------------------------------------------
 */
export class VideoCellContentData {
  id: number
  releaseTime: number
  title: string
  description: string
  playUrl: string
  category: string
  cover: CoverInfo
  author: AuthorInfo
  consumption: ConsumptionInfo
}