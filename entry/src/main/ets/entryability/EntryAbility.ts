import RouterPath from '../util/RouterPath';
import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import formProvider from '@ohos.app.form.formProvider';

export default class EntryAbility extends UIAbility {
    entryPage: string = RouterPath.LAUNCHER_PAGE;

    onCreate(want, launchParam) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
        if (want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
            let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
            let message = JSON.parse(want.parameters.params).detail;
            console.info(`UpdateForm formId: ${curFormId}, message: ${message}`);
            let formData = {
                'mini_title': '格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'title': '格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'content': '去你想去的地方，发现世界的美', // 和卡片布局中对应
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

    // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
    onNewWant(want, launchParam) {
        console.info('onNewWant Want:' + JSON.stringify(want));
        if (want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
            let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
            let message = JSON.parse(want.parameters.params).detail;
            console.info(`UpdateForm formId: ${curFormId}, message: ${message}`);
            let formData = {
                'mini_title': '格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'title': '格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
                'content': '去你想去的地方，发现世界的美', // 和卡片布局中对应
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

        // 1.获取应用主窗口。
        let windowClass = null;
        windowStage.getMainWindow((err, data) => {
            if (err.code) {
                console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
                return;
            }
            windowClass = data;
            console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

            // 2.实现沉浸式效果。方式一：设置导航栏、状态栏不显示。
//            let names = ['status','navigation'];
            /*let names = [];
            windowClass.setWindowSystemBarEnable(names, (err) => {
                if (err.code) {
                    console.error('Failed to set the system bar to be visible. Cause:' + JSON.stringify(err));
                    return;
                }
                console.info('Succeeded in setting the system bar to be visible.');
            });*/
            // 2.实现沉浸式效果。方式二：设置窗口为全屏布局，配合设置导航栏、状态栏的透明度、背景/文字颜色及高亮图标等属性，与主窗口显示保持协调一致。
            let isLayoutFullScreen = false;
            windowClass.setWindowLayoutFullScreen(isLayoutFullScreen, (err) => {
                if (err.code) {
                    console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
                    return;
                }
                console.info('Succeeded in setting the window layout to full-screen mode.');
            });

            var sysBarProps={
                isStatusBarLightIcon: true,
                isNavigationBarLightIcon:true,
                statusBarColor: '$color:white',
                navigationBarColor: '$color:transparent',
                // 以下两个属性从API Version 8开始支持
                statusBarContentColor: "$color:color_F9F9F9",
                navigationBarContentColor: "$color:white",
            };
            windowClass.setWindowSystemBarProperties(sysBarProps, (err) => {
                if (err.code) {
                    console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
                    return;
                }
                console.info('Succeeded in setting the system bar properties.');
            });
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
