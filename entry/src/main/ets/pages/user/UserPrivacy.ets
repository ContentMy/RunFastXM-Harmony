@Entry
@Component
@Preview
struct UserPrivacy{
  @State content:string = '暂无'
  build(){
    Column(){
      /*这里是标题栏相关组件内容*/
      Row(){
        Image($r('app.media.ui_back_black'))
          .width(50)
          .height(50)
          .padding(15)
        Text($r('app.string.user_privacy_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      .width('100%')
      .height(50)

      Text(this.content)
    }
    .width('100%')
    .height('100%')
  }
}