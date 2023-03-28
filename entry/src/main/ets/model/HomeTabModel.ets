/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabModel
 * Author: Victor
 * Date: 2023/2/27 14:53
 * Description: 
 * -----------------------------------------------------------------
 */

export interface NavItem {
  icon: Resource;
  icon_selected: Resource;
  text: Resource;
  id: number;
}

export enum TabId {
  HOME,
  COMMUNITY,
  HOT,
  ME
}

export const NavList: NavItem[] = [
  {
    icon: $r('app.media.ic_home_normal'),
    icon_selected: $r('app.media.ic_home_checked'),
    text: $r('app.string.tab_home'),
    id: TabId.HOME
  },
  {
    icon: $r('app.media.ic_discovery_normal'),
    icon_selected: $r('app.media.ic_discovery_checked'),
    text: $r('app.string.tab_community'),
    id: TabId.COMMUNITY
  },
  {
    icon: $r('app.media.ic_hot_normal'),
    icon_selected: $r('app.media.ic_hot_checked'),
    text: $r('app.string.tab_hot'),
    id: TabId.HOT
  },
  {
    icon: $r('app.media.ic_me_normal'),
    icon_selected: $r('app.media.ic_me_checked'),
    text: $r('app.string.tab_me'),
    id: TabId.ME
  },
]

export const homePageTabTitles = [{ id: 0, name: '推荐' },{ id: 1, name: '关注' },{ id: 2, name: '日报' }]