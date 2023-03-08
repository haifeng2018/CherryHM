import { OwnInfo } from './OwnInfo';
import { BannerInfo } from './BannerInfo';
import { VideoCellContentInfo } from './VideoCellContentInfo';
import { VideoInfo } from './VideoInfo';
import { VideoCellHeaderInfo } from './VideoCellHeaderInfo';
import { ConsumptionInfo } from './ConsumptionInfo';
import { AuthorInfo } from './AuthorInfo';
import { CoverInfo } from './CoverInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: VideoCellData
 * Author: Victor
 * Date: 2023/3/3 16:36
 * Description: 
 * -----------------------------------------------------------------
 */
 export class VideoCellData {
  type:string
  dataType:string
  text:string
  id: number
  releaseTime: number
  duration: number
  count: number
  title: string
  icon: string
  image: string
  backgroundImage: string
  description: string
  playUrl: string
  category: string
  cover: CoverInfo
  author: AuthorInfo
  consumption: ConsumptionInfo
  header: VideoCellHeaderInfo
  content: VideoCellContentInfo
  itemList:Array<VideoCellContentInfo>
  titleList:Array<string>
  bannerList:Array<BannerInfo>
 }