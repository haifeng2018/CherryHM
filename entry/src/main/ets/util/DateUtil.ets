/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DateUtil
 * Author: Victor
 * Date: 2023/3/23 15:59
 * Description: 
 * -----------------------------------------------------------------
 */
 class DateUtil {

  formatReleaseDate(releaseTime: number): string {
   let releaseDate = new Date(releaseTime)

   let year = releaseDate.getFullYear().toString()
   let month = releaseDate.getMonth().toString()
   let day = releaseDate.getDay().toString()
   let hours = releaseDate.getHours()
   let mins = releaseDate.getMinutes()

   let hoursStr = hours.toString()
   if (hours < 10) {
    hoursStr = "0" + hours
   }

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   return year + '/' + month + '/' + day + ' ' + hoursStr + ':' + minsStr
  }

  formatDuration(duration: number): string {
   let mins = Math.floor(duration / 60)
   let secs = Math.floor(duration % 60)

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   let secsStr = secs.toString()
   if (secs < 10) {
    secsStr = "0" + secs
   }

   return minsStr + ':' + secsStr
  }
 }

export default new DateUtil()