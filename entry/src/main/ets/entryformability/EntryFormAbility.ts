import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formProvider from '@ohos.app.form.formProvider';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want) {
    // Called to return a FormBindingData object.
    let formId = want.parameters["ohos.extra.param.key.form_identity"];
    let dataObj1 = {
      "formId": formId
    };
    let obj1 = formBindingData.createFormBindingData(dataObj1);
    return obj1;
  }

  onCastToNormalForm(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId) {
    // Called to notify the form provider to update a specified form.
    // Called when a specified message event defined by the form provider is triggered.
    let formData = {
      'mini_title': '2格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
      'title': '2格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
      'content': '2去你想去的地方，发现世界的美', // 和卡片布局中对应
      'poster': 'http://img.kaiyanapp.com/50dab5468ecd2dbe5eb99dab5d608a0a.jpeg?imageMogr2/quality/60/format/jpg', // 和卡片布局中对应
    };
    let formInfo = formBindingData.createFormBindingData(formData)
    formProvider.updateForm(formId, formInfo).then((data) => {
      console.info('FormAbility updateForm success.' + JSON.stringify(data));
    }).catch((error) => {
      console.error('FormAbility updateForm failed: ' + JSON.stringify(error));
    })
  }

  onChangeFormVisibility(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onFormEvent(formId, message) {
    // Called when a specified message event defined by the form provider is triggered.
    let formData = {
      'mini_title': '1格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
      'title': '1格鲁吉亚旅行记录，穿越上帝遗忘的后花园', // 和卡片布局中对应
      'content': '1去你想去的地方，发现世界的美', // 和卡片布局中对应
      'poster': 'http://img.kaiyanapp.com/50dab5468ecd2dbe5eb99dab5d608a0a.jpeg?imageMogr2/quality/60/format/jpg', // 和卡片布局中对应
    };
    let formInfo = formBindingData.createFormBindingData(formData)
    formProvider.updateForm(formId, formInfo).then((data) => {
      console.info('FormAbility updateForm success.' + JSON.stringify(data));
    }).catch((error) => {
      console.error('FormAbility updateForm failed: ' + JSON.stringify(error));
    })
  }

  onRemoveForm(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
};