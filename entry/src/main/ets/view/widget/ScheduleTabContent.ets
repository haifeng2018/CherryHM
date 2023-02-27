import Constants from '../../util/Constants';
import { LoadingDialog } from '../dialog/loadingDialog';
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ScheduleTabContent
 * Author: Victor
 * Date: 2023/2/27 15:12
 * Description: 
 * -----------------------------------------------------------------
 */

@Component
export struct ScheduleTabContent {

  loadingDlgCtr: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({}),
    alignment: DialogAlignment.Center,
    customStyle: true
  });


  build() {
    Column() {
      Button('loading')
        .align(Alignment.Center)
        .width('50%')
        .margin({top:168})
        .onClick(() => {
            this.loadingDlgCtr.open()
        })
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}