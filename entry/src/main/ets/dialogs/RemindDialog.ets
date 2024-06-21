import promptAction from '@ohos.promptAction'
import systemDateTime from '@ohos.systemDateTime'
import RemindData from '../common/database/data/RemindData'
import { logger } from '../common/utils/logger'
@CustomDialog
@Preview
export struct RemindDialog{
  @Link mRemindData: RemindData
  @State arr: String[] = ['5分钟', '10分钟', '15分钟', '20分钟', '25分钟', '30分钟', '45分钟', '1小时']
  @State chooseTime:string = '5分钟'
  @State enterString:string = ''
  @State sendImgResource:Resource = $r('app.media.ui_send_gray')
  @State selectIndex:number = 0// -1表示未选中任何项，0是第一项，目前逻辑下默认为第一项
  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  confirm?: (remindData: RemindData) => void

  aboutToAppear(){
    //TODO:增加自动弹出软键盘
  }

  aboutToDisappear(){

  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }){
      Column() {
        TextInput({ placeholder: $r('app.string.remind_create_title_default_desc'), text: this.enterString })
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
            this.enterString = value
            this.sendImgResource = value.length == 0 ? $r('app.media.ui_send_gray') : $r('app.media.ui_send')
          })
        Text($r('app.string.remind_create_time_prompt_desc'))
          .fontSize(12)
          .width('100%')
          .fontColor($r('app.color.colorGray'))
          .margin({ left: 30 })
        List({space:10, initialIndex:0}){
          //数据源，item和下标
          ForEach(this.arr, (item:string, index) => {
            ListItem() {
              //布局方向，item对齐方式
              Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                Text(item)
                  .fontSize(10)
                  .fontColor(this.isSelectedItem(index)?$r('app.color.colorWhite'):$r('app.color.colorBlack'))
                  .textAlign(TextAlign.Center)
                  .flexShrink(1)
              }
            }
            .onClick(()=>{
              this.selectIndex = index
              this.chooseTime = item
            })
            .backgroundColor(this.isSelectedItem(index)?$r('app.color.colorBlack'):$r('app.color.colorGreen'))
            .borderRadius(5)
            .padding({top:4,bottom:4,left:8,right:8})
          }, item => item)
        }
        .width('100%')
        .margin({ left: 30,top:10 })
        .listDirection(Axis.Horizontal)
      }
      .width('80%')

      Stack({alignContent:Alignment.Center}){
        Image(this.sendImgResource)
          .width(50)
          .height(50)
          .padding(10)
          .onClick(()=>{
            try{
              console.log('点击了按钮');
              if (this.enterString.trim().length == 0) {
                promptAction.showToast({message: $r('app.string.remind_create_title_null_desc'),duration: 2000})
                return;
              }
              let remindStartTime = new Date().getTime()
              let remindTime = this.getTimeFromString(this.chooseTime)
              // systemDateTime.getCurrentTime(false).then((time)=>{//TODO:harmony获取时间的api是异步的，普通api Date().getTime()与systemDateTime.getCurrentTime相差6ms，后续考虑方案优化
              //   remindStartTime = time
              // })
              this.mRemindData.remindTitle = this.enterString
              this.mRemindData.remindTime = remindTime
              this.mRemindData.remindStartTime = remindStartTime
              this.mRemindData.remindEndTime = remindStartTime + remindTime
              this.mRemindData.remindCompleteStatus = false
              this.controller.close()
              this.confirm(this.mRemindData)
            }catch (e){
              logger.error(e)
            }
          })
      }.layoutWeight(1)
      .padding({left:10})
      .width('100%')
      .height('100%')
    }
    .height(120)
    .width('100%')
    .borderRadius({topLeft:10,topRight:10})
    .backgroundColor($r('app.color.colorWhite'))
  }

  isSelectedItem(index:number):boolean{
    return this.selectIndex === index//使用===减少被==被隐式转换造成的数据对比风险
  }
  /**
   * @Author: ContentMy
   * @params: chooseTime 选择的时间文本
   * @return: number 返回的转化时间戳，毫秒级
   * @Description: 将协议的时间文本转化为时间戳
   */
  getTimeFromString(chooseTime: string): number {
    switch(chooseTime){
      case '5分钟':
        return 5 * 60 * 1000
      break;
      case '10分钟':
        return 10 * 60 * 1000
        break;
      case '15分钟':
        return 15 * 60 * 1000
        break;
      case '20分钟':
        return 20 * 60 * 1000
        break;
      case '25分钟':
        return 25 * 60 * 1000
        break;
      case '30分钟':
        return 30 * 60 * 1000
        break;
      case '45分钟':
        return 45 * 60 * 1000
        break;
      case '1小时':
        return 60 * 60 * 1000
        break;
      default :
        return 5 * 60 * 1000
        break
    }
  }
}
