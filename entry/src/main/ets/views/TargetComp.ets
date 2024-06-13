
@Component
@Preview
export struct TargetComp{
  @State title: string = '目标列表'
  @State isCheckIn:boolean = false
  @State checkInString:string = '打卡'
  @State isShowDefaultText:boolean = false
  @State arr: string[] = ['测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容',
    '测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容']
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
            .margin({left:20})
          Image($r('app.media.remind_menu'))
            .width(50)
            .height(50)
            .padding(10)
            .margin({right:10})
            .visibility(Visibility.None)
        }
        .width('100%')
        .height(50)

        /*这部分是展示列表的ui布局*/
        Stack(){
          /*这部分是后续要增加的tips，暂时不处理*/

          /*这部分是展示的列表内容*/
          List({space:20, initialIndex:0}) {//item的间隔，起始索引值
            //数据源，item和下标
            ForEach(this.arr, (item, index) => {
              ListItem() {
                //布局方向，item对齐方式
                Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                  Image($r('app.media.ui_icon_sleep'))
                    .width(50)
                    .height(50)
                    .padding(8)
                    .margin({left:10})
                  Column(){
                    Text('' + item)
                      .fontSize(16)
                      .alignSelf(ItemAlign.Start)
                      .flexShrink(1)
                      .fontColor($r('app.color.colorBlack'))
                      .margin({left:10})
                    Text('' + item)
                      .fontSize(10)
                      .alignSelf(ItemAlign.Start)
                      .flexShrink(1)
                      .fontColor($r('app.color.colorGray'))
                      .margin({left:10,top:10})
                  }.layoutWeight(1)
                  Button(this.checkInString,{type: ButtonType.Normal, stateEffect: true })
                    .fontSize(14)
                    .fontColor($r('app.color.colorBlack'))
                    .backgroundColor($r('app.color.colorYellow'))
                    .borderColor($r('app.color.colorGreen'))
                    .borderWidth(1)
                    .borderRadius(10)
                    .margin({right:20})
                    .onClick(()=>{
                      this.checkInString = this.isCheckIn ? '已打卡' : '打卡'
                    })
                }
              }
              .height(80)
              .backgroundColor($r('app.color.colorGreenMidNext'))
              .borderColor($r('app.color.colorBlack'))
              .borderWidth(1)
              .borderRadius(10)
              .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:5,offsetY:5})
              .margin({left:20,right:20})

            }, item => item)
          }.width('100%')
          /*这部分是没有列表数据时的默认占位内容*/
          Text($r('app.string.remind_default_desc'))
            .fontColor($r('app.color.colorGreen'))
            .textAlign(TextAlign.Center)
            .visibility(this.isShowDefaultText ? Visibility.Visible : Visibility.None)
        }
        .width('100%')//宽度占满屏幕
        .height('100%')
      }
      .width('100%')//宽度占满屏幕
      .height('100%')

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.base_add')).width(20).height(20).align(Alignment.Center)
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(20)
      .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:2,offsetY:2})

      /*外层的tabs目前版本没有开放divider，所以在每个组件页面的底部增加一个divider*/
      Divider().strokeWidth(0.5).color($r('app.color.colorGray'))
    }.width('100%')//宽度占满屏幕
    .height('100%')
  }
}