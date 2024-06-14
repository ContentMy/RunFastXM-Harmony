import router from '@ohos.router'
@Entry
@Component
@Preview
struct RemindDetail {
  @State message: string = 'Hello World'
  @State format: string = 'HH:mm:ss.SS'
  textTimerController: TextTimerController = new TextTimerController()
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
        Text(this.message)
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      /*这里是倒计时组件的部分*/
      TextTimer({ isCountDown: true, count: 30000, controller: this.textTimerController })
        .format(this.format)
        .fontColor(Color.Black)
        .fontSize(50)
        .onTimer((utc: number, elapsedTime: number) => {
          console.info('textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime)
        }).layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}