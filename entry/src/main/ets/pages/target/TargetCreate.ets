import router from '@ohos.router'
@Entry
@Component
@Preview
struct TargetCreate {
  @State message: string = 'Hello World'
  @State textValue:string = ''
  @State arr: ResourceStr[] = ['ui_icon_sleep', 'ui_icon_sun','ui_icon_breakfast','ui_icon_lunch',
    'ui_icon_dinner', 'ui_icon_study', 'ui_icon_write', 'ui_icon_work', 'ui_icon_running',
    'ui_icon_ride', 'ui_icon_swimming', 'ui_icon_soccer']
  build() {
    Column(){
      /*这里是标题栏的组件ui部分*/
      Row(){
        Image($r('app.media.ui_back_black'))
          .width(50)
          .height(50)
          .padding(15)
          .onClick(()=>{
            router.back()
          })
        Text($r('app.string.target_create_title_new_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      /*这里是icon的部分*/
      Image($r('app.media.ui_icon_sleep'))
        .width(50)
        .height(50)
        .padding(10)
        .margin({top:18})
      /*这里是目标名称输入框的部分*/
      TextInput({ placeholder: '请输入想要提醒的事项', text: this.textValue })
        .width(200)//TODO:宽度处理自适应问题，目前自适应的话会默认直接填满宽度，高度是ok的
        .fontSize(14)
        .borderRadius(5)
        .backgroundColor($r('app.color.colorGrayLight'))
        .style(TextInputStyle.Inline)
        .onChange((value: string) => {
          this.textValue = value
        })
      /*这里是icon选择提示的部分*/
      Row(){
        Image($r('app.media.ui_small_icon_choose_icon'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_icon_desc'))
          .fontSize(14)
          .margin({left:4})
      }.width('100%').margin({top:10}).padding({left:10,right:10})
      /*这里是icon横向列表*/
      List({space:10, initialIndex:0}){
        //数据源，item和下标
        ForEach(this.arr, (item) => {
          ListItem() {
            //布局方向，item对齐方式
            Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
              // Image($r(`app.media.${item}`))//TODO：资源名称数组使用image暂时加载有问题，后续转化为model
            }
          }
        }, item => item)
      }.width('100%').margin({top:10}).padding({left:10,right:10}).listDirection(Axis.Horizontal).visibility(Visibility.None)
      /*这里是目标开始时间组件ui部分*/
      Row(){
        Image($r('app.media.ui_small_icon_start_time'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_start_time_desc'))
          .fontSize(14)
          .margin({left:4})
          .layoutWeight(1)
        Text('2024-01-01')
          .fontSize(14)
          .fontColor($r('app.color.colorGray'))
        Image($r('app.media.ui_right_arrow_green'))
          .width(12)
          .margin({left:6})
      }.width('100%').height(50).margin({top:10}).padding({left:10,right:10})
      /*这里是目标结束时间组件ui部分*/
      Row(){
        Image($r('app.media.ui_small_icon_end_time'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_end_time_desc'))
          .fontSize(14)
          .margin({left:4})
          .layoutWeight(1)
        Text('永不结束')
          .fontSize(14)
          .fontColor($r('app.color.colorGray'))
        Image($r('app.media.ui_right_arrow_green'))
          .width(12)
          .margin({left:6})
      }.width('100%').height(50).margin({top:10}).padding({left:10,right:10})
      /*这里是目标状态组件ui部分*/
      Row(){
        Image($r('app.media.ui_small_icon_calendar'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_state_desc'))
          .fontSize(14)
          .margin({left:4})
          .layoutWeight(1)
      }.width('100%').margin({top:10}).padding({left:10,right:10})
      /*这里是content提示的部分*/
      Row(){
        Image($r('app.media.ui_small_icon_record'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_content_desc'))
          .fontSize(14)
          .margin({left:4})
      }.width('100%').height(50).margin({top:10}).padding({left:10,right:10})
      /*这里是content的部分*/
      TextInput({ placeholder: $r('app.string.target_create_content_default_desc'), text: this.textValue })
        .height(100)
        .fontSize(12)
        .borderRadius(5)
        .backgroundColor($r('app.color.colorGrayLight'))
        .align(Alignment.TopStart)//TODO:设置对齐后，顶部直接没有空间边距，后续优化
        .onChange((value: string) => {
          this.textValue = value
        })
        .margin({left:10,right:10})
      /*这里是保存按钮的部分*/
      Button($r('app.string.save_desc'),{ type: ButtonType.Normal, stateEffect: true })
        .backgroundColor($r('app.color.colorGreen'))
        .borderRadius(6)
        .width('95%')
        .margin(10)//TODO:设置宽度为100%后，左右的margin同时设置就会互相抵消从而不生效了
    }
  }
}