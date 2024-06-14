import router from '@ohos.router'
@Entry
@Component
@Preview
struct MemorandumDetail {
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
          .padding(20)
          .onClick(()=>{
            router.back()
          })
        Text($r('app.string.memorandum_detail_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      .width('100%')
      .height(50)
      /*这里是title组件内容*/
      Text('测试标题')
        .width('90%')
        .fontColor($r('app.color.colorBlack'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      /*这里是创建时间组件*/
      Text('创建时间：2024-01-01')
        .fontColor($r('app.color.colorGray'))
        .fontSize(12)
        .width('90%')
        .margin({ top:10 })
      /*这里是修改时间组件*/
      Text('修改时间：2024-01-01')
        .fontColor($r('app.color.colorGray'))
        .fontSize(12)
        .width('90%')
        .margin({ top:10 })
      /*这里是内容组件*/
      Text('这里还没有写内容哦')
        .width('95%')
        .height(200)
        .align(Alignment.TopStart)
        .fontColor($r('app.color.colorWhite'))
        .backgroundColor($r('app.color.colorGreen'))
        .padding(10)
        .borderRadius(6)
        .margin(10)
      /*这里是图片列表组件*/

    }
  }
}