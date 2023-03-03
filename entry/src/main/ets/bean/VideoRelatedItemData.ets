import { ConsumptionInfo } from './ConsumptionInfo';
import { AuthorInfo } from './AuthorInfo';
import { CoverInfo } from './CoverInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: VideoRelatedItemData
 * Author: Victor
 * Date: 2023/3/3 16:14
 * Description: 
 * -----------------------------------------------------------------
 */
 export class VideoRelatedItemData {
   type:string
   dataType:string
   text:string
   id: number
   releaseTime: number
   duration: number
   title: string
   description: string
   playUrl: string
   category: string
   cover: CoverInfo
   author: AuthorInfo
   consumption: ConsumptionInfo
 }