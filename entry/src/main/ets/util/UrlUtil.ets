/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UrlUtil
 * Author: Victor
 * Date: 2023/3/23 15:59
 * Description: 
 * -----------------------------------------------------------------
 */
 class UrlUtil {
  getTitle(actionUrl: string): string {
   let title = actionUrl.substring(actionUrl.indexOf('=') + 1, actionUrl.indexOf('&'))
   let decodeTitle = decodeURIComponent(title)
   console.error('NewsTabContent', 'decodeTitle = ' + decodeTitle)
   return decodeTitle
  }

  getUrl(actionUrl: string): string {
   let url = actionUrl.substring(actionUrl.indexOf('url'))
   let decodeUrl = decodeURIComponent(url)

   console.error('NewsTabContent', 'decodeUrl = ' + decodeUrl)
   return decodeUrl
  }
 }

export default new UrlUtil()