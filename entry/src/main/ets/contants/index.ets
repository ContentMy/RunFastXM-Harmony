import { TabBarModel } from '../models/TabBarModel'

export const TabBarItems: TabBarModel[] = [
  {
    defaultIcon: $r('app.media.remind_default'),
    activeIcon: $r('app.media.remind_select'),
    label: '提醒'
  },
  {
    defaultIcon: $r('app.media.target_default'),
    activeIcon: $r('app.media.target_select'),
    label: '目标'
  },
  {
    defaultIcon: $r('app.media.memorandum_default'),
    activeIcon: $r('app.media.memorandum_select'),
    label: '日记'
  },
  {
    defaultIcon: $r('app.media.user_default'),
    activeIcon: $r('app.media.user_select'),
    label: '我的'
  }
]