@CustomDialog
export struct RemindDialog{
  @Link textValue: string
  @Link inputValue: string
  @State arr: String[] = ['5分钟', '10分钟', '15分钟', '20分钟', '25分钟', '30分钟', '45分钟', '1小时']
  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }){
      Column() {
        TextInput({ placeholder: '请输入想要提醒的事项', text: this.textValue })
          .height(60)
          .width('100%')
          .backgroundColor($r('app.color.colorWhite'))
          .stateStyles({//TODO:按压有颜色变深效果，使用样式替换没有生效，后续优化
            pressed:{
              .backgroundColor($r('app.color.colorWhite'))
            },
            clicked:{
              .backgroundColor($r('app.color.colorWhite'))
            },
            normal:{
              .backgroundColor($r('app.color.colorWhite'))
            },
            disabled:{
              .backgroundColor($r('app.color.colorWhite'))
            },
            focused:{
              .backgroundColor($r('app.color.colorWhite'))
            }
          })
          .onChange((value: string) => {
            this.textValue = value
          })
        Text('请选择提醒时间:')
          .fontSize(12)
          .width('100%')
          .fontColor($r('app.color.colorGray'))
          .margin({ left: 30 })
        List({space:10, initialIndex:0}){
          //数据源，item和下标
          ForEach(this.arr, (item, index) => {
            ListItem() {
              //布局方向，item对齐方式
              Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                Text('' + item)
                  .fontSize(10)
                  .textAlign(TextAlign.Center)
                  .flexShrink(1)
              }
            }
            .backgroundColor($r('app.color.colorGreen'))
            .borderRadius(5)
            .padding({top:4,bottom:4,left:8,right:8})
          }, item => item)
        }
        .width('100%')
        .margin({ left: 30,top:10 })
        .listDirection(Axis.Horizontal)
      }
      .width('80%')

      Image($r('app.media.icon'))
        .width(50)
        .height(50)
        .onClick(()=>{
          console.log('点击了按钮');
          this.controller.close()
          this.confirm()
        })
    }
    .height(120)
    .borderRadius({topLeft:10,topRight:10})
    .backgroundColor($r('app.color.colorWhite'))
  }
}