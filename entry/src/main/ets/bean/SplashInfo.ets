/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: SplashInfo
 * Author: Victor
 * Date: 2022/12/8 16:11
 * Description: 
 * -----------------------------------------------------------------
 */
const imageData: any[] = [
  { 'id': '1', 'name': '第一张图片标题', 'image': $r('app.media.img_splash1') },
  { 'id': '2', 'name': '第二张图片标题', 'image': $r('app.media.img_splash2') }
]

/**
 * 轮播图数据模型
 *
 * @param id id
 * @param name 标题
 * @param image 图片
 */
export class SplashInfo{
  id: string;
  name: string;
  image: Resource;

  constructor(id: string, name: string, image: Resource) {
    this.id = id;
    this.name = name;
    this.image = image;
  }
}

export function initializeOnStartup(): Array<SplashInfo> {
  let imageDataArray: Array<SplashInfo> = []
  imageData.forEach((item, index) => {
      imageDataArray.push(new SplashInfo(item.id, item.name, item.image))
  })
  return imageDataArray
}