import { VideoCellContentData } from './VideoCellContentData';
import { VideoCellData } from './VideoCellData';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: VideoInfo
 * Author: Victor
 * Date: 2023/3/3 16:27
 * Description: 
 * -----------------------------------------------------------------
 */
export class VideoInfo {
  type: string;
  trackingData: string;
  tag: string;
  id: number;
  adIndex: number;
  data: VideoCellContentData;
}