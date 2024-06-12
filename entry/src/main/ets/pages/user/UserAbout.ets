import bundleManager from '@ohos.bundle.bundleManager';
// import { BusinessError } from '@ohos.base';
@Component
@Preview
@Entry
struct UserAbout{
  @State versionName:string = ''
  async onInit(){
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).then((bundleInfo)=>{
      let versionName =  bundleInfo.versionName;//应用版本名
      console.log("versionName为："+versionName)
      let versionNo = bundleInfo.versionCode;//应用版本号
      this.versionName = versionName
    })
    //   .catch((error:BusinessError )=>{
    //   console.error("get bundleInfo failed,error is "+error)
    // })
  }

  onPageShow(){
    this.onInit()
  }

  build(){
    Column(){

      /*这里是标题栏相关组件内容*/

      Row(){
        Image($r('app.media.ui_back_white'))
          .width(50)
          .height(50)
          .padding(15)
        Text($r('app.string.user_about_desc'))
          .fontColor($r('app.color.colorWhite'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      .width('100%')
      .height(50)
      /*这里是展示icon+appName+appVersion的组件内容*/

      Stack(){
        Image($r('app.media.ui_rectangle_bg_white'))
          .width(150)
          .height(150)
        Image($r('app.media.app_icon'))
          .width(100)
          .height(100)
      }
      .margin({top:150})
      Text($r('app.string.app_name'))
        .fontColor($r('app.color.colorWhite'))
        .fontSize(25)
        .margin({top:10})
        .fontWeight(FontWeight.Bold)
      Text('测试版 v' + this.versionName)
        .fontColor($r('app.color.colorWhite'))
        .fontSize(20)
        .margin({top:10})

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.colorGreen'))
  }
}