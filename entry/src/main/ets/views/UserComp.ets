
@Component
@Preview
export struct UserComp{
  @State title: string = '个人设置'
  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Column() {
        /*这部分是顶部标题和menu的布局*/
        Row(){
          Text(this.title)
            .fontColor($r('app.color.colorBlack'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
          Image($r('app.media.remind_menu'))
            .width(50)
            .height(50)
            .padding(10)
            .visibility(Visibility.None)
        }
        .width('100%')
        .height(50)

        /*这部分是icon+appName的ui组件展示*/
        Column(){
          Image($r('app.media.app_icon'))
            .width(50)
            .height(50)
            .margin({top:80})
          Text($r('app.string.app_name'))
            .fontSize(20)
            .fontColor($r('app.color.colorBlack'))
            .margin({top:10})
        }

        /*这部分是设置功能项的ui组件展示*/


      }
      .width('100%')//宽度占满屏幕
      .height('100%')
      .padding({left:20,right:10})

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.base_add')).width(20).height(20).align(Alignment.Center)
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(20)
      .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:2,offsetY:2})
      .visibility(Visibility.None)

      /*外层的tabs目前版本没有开放divider，所以在每个组件页面的底部增加一个divider*/
      Divider().strokeWidth(0.5).color($r('app.color.colorGray'))
    }.width('100%')//宽度占满屏幕
    .height('100%')
  }
}