import router from '@ohos.router'
import TargetData from '../common/database/data/TargetData'
import TargetTable from '../common/database/tables/TargetTable'

@Component
@Preview
export struct TargetComp{
  @State isCheckIn:boolean = false
  @State checkInString:string = '打卡'
  @State mList:Array<TargetData> = []
  @State mTargetData:TargetData = {id:0,targetImg:'',targetTitle:'',targetContent:'',targetStatus:0,targetStartTime:0,targetEndTime:0,targetIsRemind:false}
  private TargetTable = new TargetTable(() => {});

  aboutToAppear(){//TODO:从目标新建页面返回时，这个回调不会被调用
    this.TargetTable.getRdbStore(() => {
      this.TargetTable.query(0, (result: TargetData[]) => {
        this.mList = result;
      }, true);
    });
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
            ForEach(this.mList, (item:TargetData, index) => {
              ListItem() {
                //布局方向，item对齐方式
                Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                  Image(this.getImgResourceFromString(item.targetImg))
                    .width(50)
                    .height(50)
                    .padding(8)
                    .margin({left:10})
                  Column(){
                    Text(item.targetTitle)
                      .fontSize(16)
                      .alignSelf(ItemAlign.Start)
                      .flexShrink(1)
                      .fontColor($r('app.color.colorBlack'))
                      .margin({left:10})
                    Text(item.targetContent)
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
          }.width('100%').height('100%')
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
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(20)
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
      /*外层的tabs目前版本没有开放divider，所以在每个组件页面的底部增加一个divider*/
      Divider().strokeWidth(0.5).color($r('app.color.colorGray'))
    }.width('100%')//宽度占满屏幕
    .height('100%')
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