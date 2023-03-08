import { AuthorInfo } from './AuthorInfo';
import { CoverInfo } from './CoverInfo';
import { ConsumptionInfo } from './ConsumptionInfo';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LightTopicsContentData
 * Author: Victor
 * Date: 2023/3/8 14:59
 * Description: 
 * -----------------------------------------------------------------
 */
export class LightTopicsContentData {
    dataType: string
    id: number
    releaseTime: number
    title: string
    description: string
    library: string
    category: string
    resourceType: string
    playUrl: string
    consumption: ConsumptionInfo
    cover: CoverInfo
    author: AuthorInfo
}