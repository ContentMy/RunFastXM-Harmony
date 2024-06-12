import router from '@ohos.router'
@Entry
@Component
@Preview
struct UserInformation {
  @State message: string = 'Hello World'

  build() {
    Column(){
      /*这里是标题栏相关组件内容*/
      Row(){
        Image($r('app.media.ui_back_black'))
          .width(50)
          .height(50)
          .padding(15)
          .onClick(()=>{
            router.back()
          })
        Text($r('app.string.user_information_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      .width('100%')
      .height(50)

      /*这里是提醒功能使用说明*/
      Button($r('app.string.user_information_remind_desc'), { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(6)
        .backgroundColor($r('app.color.colorGreen'))
        .width('90%')
        .height(50)
        .onClick(() => {//TODO:发布Release时需要修改
          console.log('待跳转，release发布时使用web加载网页展示功能说明')
        })
        .margin({top:20})

      /*这里是目标功能使用说明*/
      Button($r('app.string.user_information_target_desc'), { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(6)
        .backgroundColor($r('app.color.colorGreen'))
        .width('90%')
        .height(50)
        .onClick(() => {
          console.log('待跳转，release发布时使用web加载网页展示功能说明')
        })
        .margin({top:20})

      /*这里是记录生活功能使用说明*/
      Button($r('app.string.user_information_memorandum_desc'), { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(6)
        .backgroundColor($r('app.color.colorGreen'))
        .width('90%')
        .height(50)
        .onClick(() => {
          console.log('待跳转，release发布时使用web加载网页展示功能说明')
        })
        .margin({top:20})
    }
    .width('100%')
    .height('100%')
  }
}