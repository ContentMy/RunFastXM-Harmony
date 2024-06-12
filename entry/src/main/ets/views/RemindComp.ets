
import { RemindDialog } from '../dialogs/RemindDialog'
@Component
@Preview
export struct RemindComp{
  @State title: string = '提醒列表'
  @State isShowDefaultText:boolean = true
  @State arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State editFlag: boolean = false
  @State textValue: string = ''
  @State inputValue: string = ''
  dialogController: CustomDialogController = new CustomDialogController({
    builder: RemindDialog({
      cancel: this.onCancel,
      confirm: this.onAccept,
      textValue: $textValue,
      inputValue: $inputValue
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    gridCount: 4,
    customStyle: true
  })

  aboutToDisappear(){
    this.dialogController = null // 将dialogController置空
  }

  onCancel(){
    console.log('取消收到了回调');
  }

  onAccept(){
    console.log('外层收到了回调');
  }

  exitApp(){
    console.log('点击外部收到了回调');
  }

  onPageShow(){
    if (this.arr.length > 0) {
      this.isShowDefaultText = false
    }
  }
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
        }
        .width('100%')
        .height(50)
        /*以下部分暂定由同一个Stack来包裹，处理组件叠层的效果*/
        Stack(){
          /*这部分是后续要增加的tips，暂时不处理*/

          /*这部分是展示的列表内容*/
          List({space:20, initialIndex:0}) {//item的间隔，起始索引值
            //数据源，item和下标
            ForEach(this.arr, (item, index) => {
              ListItem() {
                //布局方向，item对齐方式
                Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                  Image($r('app.media.remind_item_icon'))
                    .width(50)
                    .height(50)
                    .padding(8)
                    .margin({left:10})
                  Text('' + item)
                    .fontSize(20)
                    .textAlign(TextAlign.Center)
                    .flexShrink(1)
                    .margin({left:10})
                  if (this.editFlag) {
                    Button() {
                      Text("delete").fontSize(16)
                    }.width('30%').height(40)
                    .onClick(() => {
                      console.info(this.arr[index] + 'Delete')
                      this.arr.splice(index, 1)
                      console.info(JSON.stringify(this.arr))
                      this.editFlag = false
                    }).stateEffect(true)
                  }
                }
              }
              .height(80)
              .backgroundColor($r('app.color.colorGreenMidNextLight'))
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
      .onClick(()=>{
        /*点击+号按钮进行提醒的添加*/
        this.dialogController.open()
      })
      /*外层的tabs目前版本没有开放divider，所以在每个组件页面的底部增加一个divider*/
      Divider().strokeWidth(0.5).color($r('app.color.colorGray'))
    }.width('100%')//宽度占满屏幕
    .height('100%')
  }
}