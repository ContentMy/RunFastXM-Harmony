import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import TargetCheckInData from '../common/database/data/TargetCheckInData'
import TargetData from '../common/database/data/TargetData'
import TargetCheckInTable from '../common/database/tables/TargetCheckInTable'
import TargetTable from '../common/database/tables/TargetTable'
import { PageEventBus } from '../common/utils/PageEventBus'
import { logger } from '../common/utils/logger'
import { CommonConstants } from '../common/constants/CommonConstants'
import TargetDataWithCheckIn from '../common/database/data/TargetDataWithCheckIn'
import { JSON } from '@kit.ArkTS'

@Component
@Preview
export struct TargetComp{
  @State checkInString:string = ''
  @State checkInInterval:number = 0
  @State mList:Array<TargetDataWithCheckIn> = []
  @State mTargetData:TargetData = new TargetData()
  @State mTargetCheckInData:TargetCheckInData = new TargetCheckInData()
  private TargetTable = TargetTable.getInstance(() => {});
  private TargetCheckInTable = TargetCheckInTable.getInstance(() => {});

  aboutToAppear(){//TODO:从目标新建页面返回时，这个回调不会被调用
    PageEventBus.getInstance().subscribe('refreshTargetComp', this.refreshPage.bind(this));
    this.refreshPage()
  }

  aboutToDisappear(){
    PageEventBus.getInstance().unsubscribe('refreshTargetComp', this.refreshPage.bind(this));
  }

  refreshPage(){
    try{
      this.TargetTable.queryWithCheckInStatus(0, (result: TargetDataWithCheckIn[]) => {
        logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'刷新数据' + JSON.stringify(result))
        this.mList = result;
      }, true);
    }catch (e){
      logger.error(CommonConstants.RUN_FAST_XM_DB_TAG,e)
    }
  }

  checkInTarget(index:number,item:TargetDataWithCheckIn){
    this.TargetCheckInTable.insertData(this.mTargetCheckInData,() => {
      console.log('Check-in data inserted successfully' + JSON.stringify(item) + `\n${this.checkInString}`);
      this.mList[index] = item
    })
  }

  @Builder itemEnd(targetData:TargetData,index: number) {
    // 构建尾端滑出组件
    Button('删除',{ type: ButtonType.Normal })
      .height(80)
      .width(100)
      .fontColor($r('app.color.colorWhite'))
      .fontSize(12)
      .backgroundColor($r('app.color.colorGreen'))
      .onClick(() => {
        //从数据库中删除指定数据
        this.TargetTable.deleteData(targetData, () => {
          //从缓存删除指定数据项。
          this.mList.splice(index, 1);
        });
      })
  }

  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Column() {
        /*这部分是顶部标题和menu的布局*/
        Row(){
          Text($r('app.string.main_page_title_target_desc'))
            .fontColor($r('app.color.colorBlack'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .margin({left:10})
          Image($r('app.media.remind_menu'))
            .width(50)
            .height(50)
            .padding(10)
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
            ForEach(this.mList, (item:TargetDataWithCheckIn, index) => {
              ListItem() {
                //布局方向，item对齐方式
                Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                  Image(this.getImgResourceFromString(item.targetData.targetImg))
                    .width(50)
                    .height(50)
                    .padding(8)
                    .margin({left:10})
                  Column(){
                    Text(item.targetData.targetTitle)
                      .fontSize(16)
                      .alignSelf(ItemAlign.Start)
                      .flexShrink(1)
                      .fontColor($r('app.color.colorBlack'))
                      .margin({left:10})
                    Text(item.targetData.targetContent)
                      .fontSize(10)
                      .alignSelf(ItemAlign.Start)
                      .flexShrink(1)
                      .fontColor($r('app.color.colorGray'))
                      .margin({left:10,top:10})
                  }.layoutWeight(1)
                  Button(this.checkInString = item.targetCheckInStatus ? '已打卡' : '打卡',{type: ButtonType.Normal, stateEffect: true })
                    .fontSize(14)
                    .fontColor($r('app.color.colorBlack'))
                    .backgroundColor($r('app.color.colorYellow'))
                    .borderColor($r('app.color.colorGreen'))
                    .borderWidth(1)
                    .borderRadius(10)
                    .margin({right:20})
                    .onClick(()=>{
                      // this.checkInString = '已打卡'
                      // TODO:已测试更改数据源也无法影响button的文本变化，猜想1：在作为参数设置的文本优先级最高，即使State修饰的可变参数变化后，依然无法影响。猜想2：在此处与更新数据源的方法处都进行了测试，均无法响应，所以考虑有没有类似Android adapter局部更新的实现
                      let time = new Date().getTime()
                      if(this.checkInInterval > 0 && time - this.checkInInterval > 1000){//限制打卡与取消打卡的间隔时间为1s
                        promptAction.showToast({message: '打卡要认真，一步一脚印', duration: 2000})
                        return;
                      }
                      item.targetCheckInStatus = this.checkInString == '打卡'? true : false
                      this.mTargetCheckInData.targetId = item.targetData.id
                      this.mTargetCheckInData.targetCheckIn = item.targetCheckInStatus
                      if (item.targetCheckInStatus) {
                        this.mTargetCheckInData.targetCheckInTime = time
                      }else{
                        this.mTargetCheckInData.targetCancelCheckInTime = time
                      }
                      logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,`打卡数据包：${JSON.stringify(this.mTargetCheckInData)}`)
                      this.checkInTarget(index,item)

                    })
                }
                .height(80)
                .backgroundColor($r('app.color.colorGreenMidNext'))
                .borderColor($r('app.color.colorBlack'))
                .borderWidth(1)
                .borderRadius(10)
                .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:5,offsetY:5})
                .margin({left:10,right:10})
                .onClick(()=>{
                  router.pushUrl({
                    url: 'pages/target/TargetCreate', // 目标url
                    params: {
                      data: item.targetData
                    }
                  }, router.RouterMode.Standard, (err) => {
                    if (err) {
                      console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                      return;
                    }
                    console.info('Invoke pushUrl succeeded.')
                  })
                })
              }
              .swipeAction({
                end: {
                  // index为该ListItem在List中的索引值。
                  builder: () => { this.itemEnd(item.targetData,index) },
                  //TODO：需要处理在左滑状态下，如果切换到其他页面，左滑状态无法结束的问题
                }
              })
            }, (item:string) => item)
          }.width('100%').height('100%').scrollBar(BarState.Off)
          /*这部分是没有列表数据时的默认占位内容*/
          Text($r('app.string.target_default_desc'))
            .fontColor($r('app.color.colorGreen'))
            .textAlign(TextAlign.Center)
            .visibility(this.mList.length == 0 ? Visibility.Visible : Visibility.None)
        }
        .width('100%')//宽度占满屏幕
        .height('100%')
      }
      .width('100%')//宽度占满屏幕
      .height('100%')

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.base_add')).width(20).height(20).align(Alignment.Center)
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(10)
      .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:2,offsetY:2})
      .onClick((event:ClickEvent)=>{
        router.pushUrl({
          url: 'pages/target/TargetCreate' // 目标url
        }, router.RouterMode.Standard, (err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.')
        })
      })
    }.width('100%')//宽度占满屏幕
    .height('100%')
    .padding({left:10,right:10})
  }
  private getImgResourceFromString(imgString:string):Resource{
    let resource:Resource
    switch (imgString) {
      case 'ui_icon_sleep':
        resource = $r('app.media.ui_icon_sleep')
        break;
      case 'ui_icon_sun':
        resource = $r('app.media.ui_icon_sun')
        break;
      case 'ui_icon_breakfast':
        resource = $r('app.media.ui_icon_breakfast')
        break;
      case 'ui_icon_lunch':
        resource = $r('app.media.ui_icon_lunch')
        break;
      case 'ui_icon_dinner':
        resource = $r('app.media.ui_icon_dinner')
        break;
      case 'ui_icon_study':
        resource = $r('app.media.ui_icon_study')
        break;
      case 'ui_icon_write':
        resource = $r('app.media.ui_icon_write')
        break;
      case 'ui_icon_work':
        resource = $r('app.media.ui_icon_work')
        break;
      case 'ui_icon_running':
        resource = $r('app.media.ui_icon_running')
        break;
      case 'ui_icon_ride':
        resource = $r('app.media.ui_icon_ride')
        break;
      case 'ui_icon_swimming':
        resource = $r('app.media.ui_icon_swimming')
        break;
      case 'ui_icon_soccer':
        resource = $r('app.media.ui_icon_soccer')
        break;
      default:
        resource = $r('app.media.ui_icon_sleep')
        break;
    }
    return resource
  }
}