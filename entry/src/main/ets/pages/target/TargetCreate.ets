import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import TargetData from '../../common/database/data/TargetData'
import TargetTable from '../../common/database/tables/TargetTable'
import { logger } from '../../common/utils/logger'
import { PageEventBus } from '../../common/utils/PageEventBus'
import { CommonConstants } from '../../common/contants/CommonConstants'

@Entry
@Component
@Preview
struct TargetCreate {
  @State targetImgResource:Resource = $r('app.media.ui_icon_sleep')
  @State targetTitleValue:string = ''
  @State targetContentValue:string = ''
  @State targetStatusString:string = ''
  @State targetStartTime:number = Date.now()
  @State targetStartDate:Date = new Date()
  @State targetEndTime:number = 0;
  @State targetEndDate:Date = new Date()
  @State targetImgArr: Resource[] = [$r('app.media.ui_icon_sleep'), $r('app.media.ui_icon_sun'),$r('app.media.ui_icon_breakfast'),$r('app.media.ui_icon_lunch'),
    $r('app.media.ui_icon_dinner'), $r('app.media.ui_icon_study'), $r('app.media.ui_icon_write'), $r('app.media.ui_icon_work'), $r('app.media.ui_icon_running'),
      $r('app.media.ui_icon_ride'), $r('app.media.ui_icon_swimming'), $r('app.media.ui_icon_soccer')]
  @State chooseImgIndex:number = 0
  @State targetStatusArr:string[] = ['暂不设置','早晨','上午','中午','下午','晚上','深夜']
  @State chooseStatusIndex:number = 0
  @State mTargetData:TargetData = {id:0,targetImg:'',targetTitle:'',targetContent:'',targetStatus:0,targetStartTime:0,targetEndTime:0,targetIsRemind:false}
  private TargetTable = new TargetTable(() => {});
  @State isCreate:boolean = true;


  onPageShow(): void {
    const params = router.getParams() as Record<string, TargetData>; // 获取传递过来的参数对象
    if (params) {
      this.isCreate = false
      const data:TargetData = params.data as TargetData; // 获取data属性的值
      this.targetTitleValue = data.targetTitle
      this.targetContentValue = data.targetContent
      this.targetStartTime = data.targetStartTime
      this.targetEndTime = data.targetEndTime
      this.chooseStatusIndex = data.targetStatus
      this.chooseImgIndex = this.getTargetImgIndex(data.targetImg)
    }
  }

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
        Text(this.isCreate?$r('app.string.target_create_title_new_desc'):$r('app.string.target_create_title_edit_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      /*这里是icon的部分*/
      Stack({alignContent:Alignment.Center}){
        Circle()
          .stroke($r('app.color.colorGrayLight'))
          .strokeWidth(2)
          .fill($r('app.color.colorWhite'))
          .width(50)
          .height(50)
        Image(this.targetImgResource)
          .width(50)
          .height(50)
          .padding(10)
      }.margin({top:18})
      /*这里是目标名称输入框的部分*/
      TextInput({ placeholder: $r('app.string.target_create_title_default_desc'), text: this.targetTitleValue })
        .width('auto')//TODO:宽度处理自适应问题，目前自适应的话会默认直接填满宽度，高度是ok的.解决：使用auto
        .fontSize(14)
        .borderRadius(5)
        .backgroundColor($r('app.color.colorGrayLight'))
        .margin({top:18})
        .onChange((value: string) => {
          this.targetTitleValue = value
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
      List({space:0, initialIndex:0}){
        //数据源，item和下标
        ForEach(this.targetImgArr, (item:Resource,index) => {
          ListItem() {
            Stack({alignContent:Alignment.Center}){
              Circle()
                .stroke($r('app.color.colorGray'))
                .strokeWidth(1)
                .fill($r('app.color.colorWhite'))
                .width(50)
                .height(50)
                .padding(5)
                .visibility(this.chooseImgIndex === index ?Visibility.Visible:Visibility.None)
              Image(item)
                .width(40)
                .height(40)
                .padding(8)
            }
            .width(50)
            .height(50)
          }
          .onClick(()=>{
            this.getImgResourceFromIndex(index)
          })
        })
      }
      .width('100%')
      .height(50)
      .scrollBar(BarState.Off)
      .margin({top:10,left:10,right:10})
      .listDirection(Axis.Horizontal)
      /*这里是目标开始时间组件ui部分*/
      Row(){
        Image($r('app.media.ui_small_icon_start_time'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_start_time_desc'))
          .fontSize(14)
          .margin({left:4})
          .layoutWeight(1)
        Text(this.getStartTimeString(this.targetStartTime))
          .fontSize(14)
          .fontColor($r('app.color.colorGray'))
        Image($r('app.media.ui_right_arrow_green'))
          .width(12)
          .margin({left:6})
      }.width('100%').height(50).margin({top:10}).padding({left:10,right:10})
      .onClick(()=>{
        //时间选择器，选择目标的开始时间
        CalendarPickerDialog.show({
          selected: this.targetStartDate,
          onAccept: (value) => {
            this.targetStartDate = value
            this.targetStartTime = value.getTime()
          },
        })
      })
      /*这里是目标结束时间组件ui部分*/
      Row(){
        Image($r('app.media.ui_small_icon_end_time'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_end_time_desc'))
          .fontSize(14)
          .margin({left:4})
          .layoutWeight(1)
        Text(this.getEndTimeString(this.targetEndTime))
          .fontSize(14)
          .fontColor($r('app.color.colorGray'))
        Image($r('app.media.ui_right_arrow_green'))
          .width(12)
          .margin({left:6})
      }.width('100%').height(50).margin({top:10}).padding({left:10,right:10})
      .onClick(()=>{
        //时间选择器，选择目标的结束时间
        CalendarPickerDialog.show({
          selected: this.targetEndDate,
          onAccept: (value) => {
            this.targetEndDate = value
            this.targetEndTime = value.getTime()
          },
        })
      })
      /*这里是目标状态组件ui部分*/
      Row(){
        Image($r('app.media.ui_small_icon_calendar'))
          .width(20)
          .height(20)
        Text($r('app.string.target_create_state_desc'))
          .fontSize(14)
          .margin({left:4})
          .layoutWeight(1)
        Text(this.targetStatusArr[this.chooseStatusIndex])
          .fontSize(14)
          .fontColor($r('app.color.colorGray'))
        Image($r('app.media.ui_right_arrow_green'))
          .width(12)
          .margin({left:6})
          .visibility(Visibility.Hidden)
      }.width('100%').height(50).margin({top:10}).padding({left:10,right:10})
      List({space:10, initialIndex:0}){
        //数据源，item和下标
        ForEach(this.targetStatusArr, (item:string, index) => {
          ListItem() {
            //布局方向，item对齐方式
            Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
              Text(item)
                .fontSize(14)
                .fontColor(this.chooseStatusIndex === index ?$r('app.color.colorWhite'):$r('app.color.colorBlack'))
                .textAlign(TextAlign.Center)
                .flexShrink(1)
            }
          }
          .onClick(()=>{
            this.chooseStatusIndex = index
          })
          .backgroundColor(this.chooseStatusIndex === index ?$r('app.color.colorBlack'):$r('app.color.colorGrayLight'))
          .borderRadius(5)
          .borderWidth(0.5)
          .borderColor($r('app.color.colorBlack'))
          .padding({top:4,bottom:4,left:8,right:8})
          .margin({top:4})
        }, (item:string) => item)
      }
      .width('100%')
      .height(30)
      .scrollBar(BarState.Off)
      .margin({ left: 20})
      .listDirection(Axis.Horizontal)
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
      TextInput({ placeholder: $r('app.string.target_create_content_default_desc'), text: this.targetContentValue })
        .height(100)
        .fontSize(12)
        .borderRadius(5)
        .backgroundColor($r('app.color.colorGrayLight'))
        .align(Alignment.TopStart)//TODO:设置对齐后，顶部直接没有空间边距，后续优化
        .onChange((value: string) => {
          this.targetContentValue = value
        })
        .margin({left:10,right:10})
      /*这里是保存按钮的部分*/
      Button($r('app.string.save_desc'),{ type: ButtonType.Normal, stateEffect: true })
        .backgroundColor($r('app.color.colorGreen'))
        .borderRadius(6)
        .width('95%')
        .margin(10)//TODO:设置宽度为100%后，左右的margin同时设置就会互相抵消从而不生效了
        .onClick(()=>{
          try{
            console.log('点击了按钮');
            if (this.targetTitleValue.trim().length == 0) {
              promptAction.showToast({message: $r('app.string.target_create_title_null_desc'),duration: 2000})
              return;
            }
            if (this.targetEndTime != 0 && this.targetEndTime < this.targetStartTime){//0L代表永不结束
              promptAction.showToast({message: $r('app.string.target_time_choose_error_desc'),duration: 2000})
              return
            }
            this.mTargetData.targetTitle = this.targetTitleValue
            this.mTargetData.targetContent = this.targetContentValue
            this.mTargetData.targetStartTime = this.targetStartTime
            this.mTargetData.targetEndTime = this.targetEndTime
            this.mTargetData.targetImg = this.getImgString()
            if (this.isCreate) {
              this.TargetTable.insertData(this.mTargetData, (id: number) => {
                logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'新建目标插入成功')
                PageEventBus.getInstance().publish('refreshTargetComp');
                router.back()
              });
            }else {
              this.TargetTable.updateData(this.mTargetData, (id: number) => {
                logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'修改目标更新成功'+JSON.stringify(this.mTargetData))
                PageEventBus.getInstance().publish('refreshTargetComp');
                router.back()
              });
            }
          }catch (e){
            logger.error(e)
          }
        })
    }
  }
  private getImgString():string{
    let imgString = ''
    switch (this.chooseImgIndex) {
      case 0:
        imgString = 'ui_icon_sleep'
        break;
      case 1:
        imgString = 'ui_icon_sun'
        break;
      case 2:
        imgString = 'ui_icon_breakfast'
        break;
      case 3:
        imgString = 'ui_icon_lunch'
        break;
      case 4:
        imgString = 'ui_icon_dinner'
        break;
      case 5:
        imgString = 'ui_icon_study'
        break;
      case 6:
        imgString = 'ui_icon_write'
        break;
      case 7:
        imgString = 'ui_icon_work'
        break;
      case 8:
        imgString = 'ui_icon_running'
        break;
      case 9:
        imgString = 'ui_icon_ride'
        break;
      case 10:
        imgString = 'ui_icon_swimming'
        break;
      case 11:
        imgString = 'ui_icon_soccer'
        break;
      default:
        imgString = 'ui_icon_sleep'
        break;
    }
    return imgString
  }

  private getTargetImgIndex(imgString:string):number{
    let index:number = 0;
    switch (imgString) {
      case 'ui_icon_sleep':
        index = 0
        break;
      case 'ui_icon_sun':
        index = 1
        break;
      case 'ui_icon_breakfast':
        index = 2
        break;
      case 'ui_icon_lunch':
        index = 3
        break;
      case 'ui_icon_dinner':
        index = 4
        break;
      case 'ui_icon_study':
        index = 5
        break;
      case 'ui_icon_write':
        index = 6
        break;
      case 'ui_icon_work':
        index = 7
        break;
      case 'ui_icon_running':
        index = 8
        break;
      case 'ui_icon_ride':
        index = 9
        break;
      case 'ui_icon_swimming':
        index = 10
        break;
      case 'ui_icon_soccer':
        index = 11
        break;
      default:
        index = 0
        break;
    }
    return index
  }

  private getImgResourceFromIndex(index:number){
    this.targetImgResource = this.targetImgArr[index]
    this.chooseImgIndex = index
  }

  private getStartTimeString(targetStartTime:number):string{
    return this.getTimeString(targetStartTime,'yyyy-MM-dd')
  }

  private getEndTimeString(targetEndTime:number):string{
    if (targetEndTime === 0) {
      return '永不结束'
    }
    return this.getTimeString(targetEndTime,'yyyy-MM-dd')
  }

  private getTimeString(time:number, type:string):string{
    let date = new Date()
    if (time) {
      date = new Date(time)
    }
    // 获取时间
    const year = date.getFullYear().toString()
    let month = (date.getMonth() + 1).toString()
    let day = date.getDate().toString()
    let hour = date.getHours().toString()
    let min = date.getMinutes().toString()
    let seconds = date.getSeconds().toString()
    // 补位
    month = month.length === 1 ? `0${month}` : month
    day = day.length === 1 ? `0${day}` : day
    hour = hour.length === 1 ? `0${hour}` : hour
    min = min.length === 1 ? `0${min}` : min
    seconds = seconds.length === 1 ? `0${seconds}` : seconds
    // 默认格式:年月日
    type = type ? type : 'yyyy-MM-dd'
    // 格式转换
    let timeStr = `${year}-${month}-${day}` // 默认 yyyy-mm-dd
    if (type === 'yyyy-MM-dd HH:mm:ss') {
      timeStr = `${year}-${month}-${day} ${hour}:${min}:${seconds}`
    } else if (type === 'yyyy-MM-dd HH:mm') {
      timeStr = `${year}-${month}-${day} ${hour}:${min}`
    } else if (type === 'yyyy-MM-dd') {
      timeStr = `${year}-${month}-${day}`
    } else if (type === 'yyyy-MM') {
      timeStr = `${year}-${month}`
    } else if (type === 'HH:mm:ss') {
      timeStr = `${hour}:${min}:${seconds}`
    } else if (type === 'HH:mm') {
      timeStr = `${hour}:${min}`
    }
    // callback
    return timeStr
  }
}