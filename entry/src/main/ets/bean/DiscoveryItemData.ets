import { DiscoveryItemHeader } from './DiscoveryItemHeader';
import { DiscoveryCellInfo } from './DiscoveryCellInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DiscoveryItemData
 * Author: Victor
 * Date: 2023/3/2 11:13
 * Description: 
 * -----------------------------------------------------------------
 */
export class DiscoveryItemData {
  dataType: string
  text: string
  icon: string
  iconType: string
  title: string
  description: string
  actionUrl: string
  count: number
  id: number
  itemList:Array<DiscoveryCellInfo>
  header:DiscoveryItemHeader
}