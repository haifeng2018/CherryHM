import { LightTopicsInfo } from './LightTopicsInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LightTopicsData
 * Author: Victor
 * Date: 2023/3/8 14:41
 * Description: 
 * -----------------------------------------------------------------
 */
export class LightTopicsData {
  id: number
  headerImage: string
  brief: string
  text: string
  shareLink: string
  count: number
  itemList: Array<LightTopicsInfo>
}