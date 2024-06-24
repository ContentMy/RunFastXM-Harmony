/**
 * 1. 主题设置
 * 2. 沉浸式设置
 * 3. 通知栏设置
 */
import window from '@ohos.window'
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant'
import { logger } from './logger'
import { WindowMode } from '@ohos.UiTest'

class ThemeManager {
  windowStage: window.Window | null = null

  async getWindowStage() {
    if (this.windowStage) {
      return this.windowStage
    } else {
      return await window.getLastWindow(getContext())
    }
  }

  initThemeSetting() {
    const app = getContext()
      .getApplicationContext()
    app.on('environment', {
      onConfigurationUpdated: (config) => {
        AppStorage.Set('colorMode', config.colorMode)
        if (config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
          this.settingStatusBarBlack()
        }
        if (config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
          this.settingStatusBarWhite()
        }
        if (config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
          // TODO
        }
      },
      onMemoryLevel: (_level) => {
        // TODO
      }
    })
    // 默认浅色模式
    // const initColorMode = AppStorage.Get('initColorMode')
    // PersistentStorage.PersistProp('colorMode', initColorMode)
    // const currentColorMode = AppStorage.Get('colorMode')
    // app.setColorMode(currentColorMode)

  }

  settingStatusBarWhite() {
    this.settingStatusBar({ statusBarContentColor: '#FFFFFF' })
  }

  settingStatusBarBlack() {
    this.settingStatusBar({ statusBarContentColor: '#000000' })
  }

  settingStatusBar(config: window.SystemBarProperties) {
    this.getWindowStage()
      .then((windowStage: window.Window) => {
        windowStage.setWindowSystemBarProperties(config)
      })
  }

  enableFullScreen() {
    logger.info('enableFullScreen')
    this.getWindowStage()
      .then((windowStage: window.Window) => {
        windowStage.setWindowLayoutFullScreen(true)
        const topArea = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        AppStorage.SetOrCreate('topHeight', px2vp(topArea.topRect.height))
        // const bottomArea = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        // AppStorage.SetOrCreate('bottomHeight', px2vp(bottomArea.bottomRect.height))
      })
  }

  disableFullScreen() {
    this.getWindowStage()
      .then((windowStage: window.Window) => {
        windowStage.setWindowLayoutFullScreen(false)
        AppStorage.SetOrCreate('topHeight', 0)
        AppStorage.SetOrCreate('bottomHeight', 0)
      })
  }
}

export const themeManager = new ThemeManager()