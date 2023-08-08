import RouterPath from '../util/RouterPath';
import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import formProvider from '@ohos.app.form.formProvider';
import { WindowBarManager } from '../util/WindowBar';
import Constants from '../util/Constants';

export default class EntryAbility extends UIAbility {
    entryPage: string = RouterPath.LAUNCHER_PAGE;

    onCreate(want, launchParam) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
        if (want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
            let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
            let message = JSON.parse(want.parameters.params).detail;
            console.info(`UpdateForm formId: ${curFormId}, message: ${message}`);
            let formData = {
                'mini_title': '3格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'title': '3格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'content': '3去你想去的地方，发现世界的美', // 和卡片布局中对应
                'poster': 'http://img.kaiyanapp.com/50dab5468ecd2dbe5eb99dab5d608a0a.jpeg?imageMogr2/quality/60/format/jpg', // 和卡片布局中对应
            };
            let formMsg = formBindingData.createFormBindingData(formData)
            formProvider.updateForm(curFormId, formMsg).then((data) => {
                console.info('updateForm success.' + JSON.stringify(data));
            }).catch((error) => {
                console.error('updateForm failed:' + JSON.stringify(error));
            })
            try {
                // 设置过5分钟后更新卡片内容
                formProvider.setFormNextRefreshTime(curFormId, 5, (err, data) => {
                    if (err) {
                        console.error(`Failed to setFormNextRefreshTime. Code: ${err.code}, message: ${err.message}`);
                        return;
                    } else {
                        console.info('Succeeded in setFormNextRefreshTimeing.');
                    }
                });
            } catch (err) {
                console.error(`Failed to setFormNextRefreshTime. Code: ${err.code}, message: ${err.message}`);
            }
        }
    }

    // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
    onNewWant(want, launchParam) {
        console.info('onNewWant Want:' + JSON.stringify(want));
        if (want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
            let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
            let message = JSON.parse(want.parameters.params).detail;
            console.info(`UpdateForm formId: ${curFormId}, message: ${message}`);
            let formData = {
                'mini_title': '4格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'title': '4格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'content': '4去你想去的地方，发现世界的美', // 和卡片布局中对应
                'poster': 'http://img.kaiyanapp.com/50dab5468ecd2dbe5eb99dab5d608a0a.jpeg?imageMogr2/quality/60/format/jpg', // 和卡片布局中对应
            };
            let formMsg = formBindingData.createFormBindingData(formData)
            formProvider.updateForm(curFormId, formMsg).then((data) => {
                console.info('updateForm success.' + JSON.stringify(data));
            }).catch((error) => {
                console.error('updateForm failed:' + JSON.stringify(error));
            })
        }
    }

    onDestroy() {
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    }

    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
        const windowBarMag = new WindowBarManager();
        windowBarMag.immersiveWindow({
            windowStage,
            color: Constants.TRANSPARENT_COLOR,
            isLayoutFullScreen: true
        })
        // 3.为沉浸式窗口加载对应的目标页面。
        windowStage.loadContent(this.entryPage, (err) => {
            if (err.code) {
                console.error('Failed to load the content. Cause:' + JSON.stringify(err));
                return;
            }
            console.info('Succeeded in loading the content.');
        });
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }

    onForeground() {
        // Ability has brought to foreground
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    }

    onBackground() {
        // Ability has back to background
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    }
}
