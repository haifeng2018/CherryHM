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
  WeChat,
  TV,
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
    icon: $r('app.media.ic_schedule_normal'),
    icon_selected: $r('app.media.ic_schedule_checked'),
    text: $r('app.string.tab_wechat'),
    id: TabId.WeChat
  },
  {
    icon: $r('app.media.ic_tv_normal'),
    icon_selected: $r('app.media.ic_tv_checked'),
    text: $r('app.string.tab_tv'),
    id: TabId.TV
  },
  {
    icon: $r('app.media.ic_me_normal'),
    icon_selected: $r('app.media.ic_me_checked'),
    text: $r('app.string.tab_me'),
    id: TabId.ME
  },
]