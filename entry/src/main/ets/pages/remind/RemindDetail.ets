import router from '@ohos.router'
import RemindData from '../../common/database/data/RemindData'
import systemDateTime from '@ohos.systemDateTime'
import { logger } from '../../common/utils/logger'
import { CommonConstants } from '../../common/constants/CommonConstants'
import { JSON } from '@kit.ArkTS'

@Entry
@Component
@Preview
struct RemindDetail {
  @State remindDetailTitle: string = ''
  @State remindTime:number = 0
  @State isDefaultTextShow:boolean = true
  private format: string = 'HH:mm:ss.SS'
  textTimerController: TextTimerController = new TextTimerController()

  aboutToAppear(): void {
    const params = router.getParams() as Record<string,RemindData>;
    if (params) {
      const data = params.data as RemindData
      logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,JSON.stringify(data))
      this.remindDetailTitle = data.remindTitle
      this.remindTime = data.remindEndTime - systemDateTime.getTime() //计算剩余时间
      if(this.remindTime > 0){
        this.isDefaultTextShow = false;
      }

    }
  }

  aboutToDisappear(): void {

  }

  onPageShow(): void {
    this.textTimerController.start()
  }


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
        Text(this.remindDetailTitle)
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      Stack(){
        /*这里是倒计时组件的部分*/
        TextTimer({ isCountDown: true, count: this.remindTime, controller: this.textTimerController })//优化方向，如果已经通知，那么这个布局不加载
          .format(this.format)
          .fontColor(Color.Black)
          .fontSize(50)
          .onTimer((utc: number, elapsedTime: number) => {
            // if(this.remindTime === elapsedTime){//elapsedTime是计时器经过的时间，如果他们两个相等证明倒计时结束，让remindTime归零执行ui的变化逻辑
            //   this.remindTime = 0;
            // }
            console.info('textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime + '，剩余时间：' + this.remindTime)
          })
          .visibility(this.remindTime > 0 ? Visibility.Visible:Visibility.None)

        /*这部分是没有列表数据时的默认占位内容*/
        Text($r('app.string.remind_default_desc'))
          .fontColor($r('app.color.colorGreen'))
          .textAlign(TextAlign.Center)
          .visibility(this.remindTime <= 0 ? Visibility.Visible : Visibility.None)
      }.layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}