import window from '@ohos.window';
import Logger from './Logger';

export class WindowBarManager {
  private static instance: WindowBarManager;
  currentBarColor: string | Resource;
  cacheWindowStage: window.WindowStage;

  constructor() {
    if (!WindowBarManager.instance) {
      WindowBarManager.instance = this;
    }
    return WindowBarManager.instance;
  }

  immersiveWindow(args) {
    let {
      windowStage,
      color,
      isLayoutFullScreen = false
    } = args;

    if (this.currentBarColor && this.currentBarColor === color) return;

    if (windowStage) {
      this.cacheWindowStage = windowStage;
    } else if (this.cacheWindowStage) {
      windowStage = this.cacheWindowStage;
    }

    let windowClass = null;
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        Logger.error(`Failed to obtain the main window. Cause: ${JSON.stringify(err)}`);
        return;
      }

      windowClass = data;
      Logger.info(`Succeeded in obtaining the main window. Data:  ${JSON.stringify(data)}`);
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen, (err) => {
        if (err.code) {
          Logger.error(`Failed to set the window layout to full-screen mode. Cause: ${JSON.stringify(err)}`);
          return;
        }
        Logger.info('Succeeded in setting the window layout to full-screen mode.');
      });

      let sysBarProps = {
        statusBarColor: color,
        navigationBarColor: $r('app.color.white'),
        statusBarContentColor: $r('app.color.color_F9F9F9'),
        navigationBarContentColor: $r('app.color.white')
      };
      windowClass.setWindowSystemBarProperties(sysBarProps, (err) => {
        if (err.code) {
          Logger.error(`Failed to set the system bar properties. Cause: ${JSON.stringify(err)}`)
          return;
        }
        this.currentBarColor = color;
        Logger.info('Succeeded in setting the system bar properties.')
      });
    });
  }
}