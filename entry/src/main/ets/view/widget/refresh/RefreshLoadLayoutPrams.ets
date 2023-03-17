/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CustomRefreshLoadLayoutClass
 * Author: Victor
 * Date: 2023/3/17 15:23
 * Description: 
 * -----------------------------------------------------------------
 */
/**
 * Custom refresh load layout data.
 */
@Observed
export class RefreshLoadLayoutPrams {
  /**
   * Custom refresh load layout isVisible.
   */
  isVisible: boolean;

  /**
   * Custom refresh load layout imageSrc.
   */
  imageSrc: Resource;

  /**
   * Custom refresh load layout textValue.
   */
  textValue: Resource;

  /**
   * Custom refresh load layout heightValue.
   */
  heightValue: number;

  scale: number;

  constructor(scale: number,isVisible: boolean, imageSrc: Resource, textValue: Resource, heightValue: number) {
    this.scale = scale;
    this.isVisible = isVisible;
    this.imageSrc = imageSrc;
    this.textValue = textValue;
    this.heightValue = heightValue;
  }
}