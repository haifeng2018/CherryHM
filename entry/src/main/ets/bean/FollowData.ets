import { FollowInfo } from './FollowInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: FollowData
 * Author: Victor
 * Date: 2023/3/1 17:12
 * Description: 
 * -----------------------------------------------------------------
 */
export class FollowData {
  count: number;
  total: number;
  nextPageUrl: string;
  adExist: boolean;
  itemList: Array<FollowInfo>;
}