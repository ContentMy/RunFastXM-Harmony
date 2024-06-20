
import router from '@ohos.router'
import { CommonConstants } from '../common/contants/CommonConstants'
import RemindData from '../common/database/data/RemindData'
import RemindTable from '../common/database/tables/RemindTable'
import { logger } from '../common/utils/logger'
import { RemindDialog } from '../dialogs/RemindDialog'
@Component
@Preview
export struct RemindComp{
  @State mList:Array<RemindData> = []
  @State mRemindData:RemindData = {id:0,remindImg:'',remindTitle:'',remindContent:'',remindTime:0,remindStartTime:0,remindEndTime:0,remindCompleteStatus:false}
  private RemindTable = new RemindTable(() => {});
  dialogController: CustomDialogController = new CustomDialogController({
    builder: RemindDialog({
      mRemindData: $mRemindData,
      confirm: (remindData: RemindData) => this.onAccept(remindData)
    }),
    cancel: this.outSideClick,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    gridCount: 4,
    customStyle: true
  })

  aboutToAppear(){
    this.RemindTable.getRdbStore(() => {
      this.RemindTable.queryAllInProgressRemind(0, (result: RemindData[]) => {
        this.mList = result;
      }, true);
    });
  }

  aboutToDisappear(){
    this.dialogController = null // 将dialogController置空
  }

  /**
   * @Author: ContentMy
   * @params: remindData 返回的Remind数据
   * @Description: 这里是点击确认后关闭dialog返回的包含有效数据的RemindData，对数据进行入库操作以及加入到缓存中
   */
  onAccept(remindData: RemindData){
    logger.info(`${CommonConstants.INDEX_TAG}`, `The remindData inserted is:  ${JSON.stringify(remindData)}`);
    this.RemindTable.insertData(remindData, (id: number) => {
      remindData.id = id;// 将数据库生成的自增 ID 赋值给 remindData 对象的 id 属性
      this.mList.push(remindData)//数据加入当前页面的缓存
      //TODO：这里后续在入库时，开启通知
    });
  }

  outSideClick(){
    console.log('点击外部收到了回调');
  }

  onPageShow(){//TODO：因为隶属于TabContent的组件而不是单独的page，所以这个回调不会生效，先将标志位改为false，后续优化此处逻辑时，在进行处理
    // if (this.arr.length > 0) {
    //   console.log('更新占位标识')
    //   this.isShowDefaultText = false
    // }
  }

  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Column() {
        /*这部分是顶部标题和menu的布局*/
        Row(){
          Text($r('app.string.remind_completed_title_desc'))
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
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/remind/RemindCompleted' // 目标url
              }, router.RouterMode.Standard, (err) => {
                if (err) {
                  console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                  return;
                }
                console.info('Invoke pushUrl succeeded.')
              })
            })
        }
        .width('100%')
        .height(50)
        /*以下部分暂定由同一个Stack来包裹，处理组件叠层的效果*/
        Stack(){
          /*这部分是后续要增加的tips，暂时不处理*/

          /*这部分是展示的列表内容*/
          List({space:20, initialIndex:0}) {//item的间隔，起始索引值
            //数据源，item和下标
            ForEach(this.mList, (item:RemindData, index) => {
              ListItem() {
                //布局方向，item对齐方式
                Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                  Image($r('app.media.remind_item_icon'))
                    .width(50)
                    .height(50)
                    .padding(8)
                    .margin({left:10})
                  Text(item.remindTitle)
                    .fontSize(20)
                    .textAlign(TextAlign.Center)
                    .flexShrink(1)
                    .margin({left:10})
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
          }.width('100%').height('100%')
          /*这部分是没有列表数据时的默认占位内容*/
          Text($r('app.string.remind_default_desc'))
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