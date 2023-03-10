import { BannerInfo } from './BannerInfo';
import { VideoCellContentInfo } from './VideoCellContentInfo';
import { VideoCellHeaderInfo } from './VideoCellHeaderInfo';
import { OwnInfo } from './OwnInfo';
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
  date: number
  url: string
  urls: Array<string>
  cover: CoverInfo
  author: AuthorInfo
  owner: OwnInfo
  consumption: ConsumptionInfo

  type:string
  dataType:string
  text:string
  duration: number
  count: number
  icon: string
  image: string
  backgroundImage: string
  header: VideoCellHeaderInfo
  content: VideoCellContentInfo
  itemList:Array<VideoCellContentInfo>
  titleList:Array<string>
  bannerList:Array<BannerInfo>
}