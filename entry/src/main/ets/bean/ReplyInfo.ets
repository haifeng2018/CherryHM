import { ParentReplyInfo } from './ParentReplyInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ReplyInfo
 * Author: Victor
 * Date: 2023/3/27 14:39
 * Description: 
 * -----------------------------------------------------------------
 */
export class ReplyInfo {
  id: number
  videoId: number
  videoTitle: string
  message: string
  parentReply: ParentReplyInfo
}