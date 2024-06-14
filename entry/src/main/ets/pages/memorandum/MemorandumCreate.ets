import router from '@ohos.router'
@Entry
@Component
@Preview
struct MemorandumCreate {
  @State title: string = ''
  @State content: string = ''
  build() {
    Column(){
      /*这里是标题栏相关组件内容*/
      //TODO：后续优化统一对这些标题栏进行复用
      Row(){
        Image($r('app.media.ui_back_black'))
          .width(50)
          .height(50)
          .padding(15)
          .onClick(()=>{
            router.back()
          })
        Text($r('app.string.memorandum_create_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.save_desc'), { type: ButtonType.Normal, stateEffect: true })
          .backgroundColor($r('app.color.colorGreen'))
          .width(50)
          .borderRadius(6)
          .margin(10)
      }
      .width('100%')
      .height(50)
      /*这里是输入框组件内容*/
      TextInput({placeholder:$r('app.string.memorandum_input_default_desc'),text:this.title})
        .width('100%')
        .fontColor($r('app.color.colorGray'))
        .backgroundColor($r('app.color.colorGrayLight'))
        .padding(10)
        .borderRadius(6)
        .margin(10)
      /*这里是内容输入提示的组件*/
      Text($r('app.string.memorandum_content_desc'))
        .fontColor($r('app.color.colorGray'))
        .fontSize(12)
        .width('95%')
        .margin({ top:10 })
      /*这里是内容输入框组件*/
      TextInput({placeholder:$r('app.string.memorandum_content_default_desc'),text:this.content})
        .width('100%')
        .height(200)
        .align(Alignment.TopStart)
        .fontColor($r('app.color.colorGray'))
        .backgroundColor($r('app.color.colorGrayLight'))
        .padding(10)
        .borderRadius(6)
        .margin(10)
      /*这里是添加图片列表提示的组件*/
      Text($r('app.string.memorandum_resource_img_desc'))
        .fontColor($r('app.color.colorGray'))
        .fontSize(12)
        .width('95%')
        .margin({ top:10 })
      /*这里是添加图片列表组件*/

    }
  }
}