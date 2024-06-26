
import router from '@ohos.router'
import { CommonConstants } from '../common/contants/CommonConstants'
import RemindData from '../common/database/data/RemindData'
import RemindTable from '../common/database/tables/RemindTable'
import { logger } from '../common/utils/logger'
import { RemindDialog } from '../dialogs/RemindDialog'
import reminderAgentManager from '@ohos.reminderAgentManager';
import { BusinessError } from '@kit.BasicServicesKit'
import { notificationManager } from '@kit.NotificationKit'

@Component
@Preview
export struct RemindComp{
  @State mList:Array<RemindData> = []
  @State mRemindData:RemindData = new RemindData()
  private RemindTable = new RemindTable(() => {});
  dialogController: CustomDialogController = new CustomDialogController({
    builder: RemindDialog({
      mRemindData: $mRemindData,
      confirm: (remindData: RemindData): void => this.onAccept(remindData)
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
    // this.dialogController = null // 将dialogController置空
  }

  /**
   * @Author: ContentMy
   * @params: remindData 返回的Remind数据
   * @Description: 这里是点击确认后关闭dialog返回的包含有效数据的RemindData，对数据进行入库操作以及加入到缓存中
   */
  onAccept(remindData: RemindData){
    logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,`入库前的数据：${JSON.stringify(remindData)}`)
    this.RemindTable.insertData(remindData, (id: number) => {
      remindData.id = id;// 将数据库生成的自增 ID 赋值给 remindData 对象的 id 属性
      this.mList.push(remindData)//数据加入当前页面的缓存
      logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,`入库后的数据：${JSON.stringify(remindData)}`)
      //TODO：这里后续在入库时，开启通知
      this.enableNotification(remindData,this.mList.indexOf(remindData))
      //TODO: 这里同步也要开始计算结束时间的状态切换

    });
  }
  async enableNotification(remindData: RemindData,index:number) {
    try {
      await notificationManager.requestEnableNotification();
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `enableNotification success`);
      this.setReminder(remindData,index)
    } catch (err) {
      logger.info(CommonConstants.RUN_FAST_XM_DB_TAG, `enableNotification err ${JSON.stringify(err)}`);
    }
  }

  // 设置提醒任务
  setReminder(remindData: RemindData,index:number) {
    logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'发送通知')
    let timer: reminderAgentManager.ReminderRequestTimer = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER,//闹钟最短的提醒时长为5分钟，满足当前的业务逻辑，后续如果出了自定义时间的设定，这里也需要跟着优化
      triggerTimeInSeconds:10,//倒计时时长/s
      title: remindData.remindTitle,
      content:'提醒时间到了哦！',
      wantAgent: {     // 点击提醒通知后跳转的目标UIAbility信息
        pkgName: 'com.existmg.runfastxm',
        abilityName: 'EntryAbility',//关于点击跳转传参的api在12才有，目前仅是点击跳转到Ability
      },
      notificationId:remindData.id
    }
    reminderAgentManager.publishReminder(timer, (err: BusinessError, reminderId: number) => {
      if (err) {
        logger.error(CommonConstants.RUN_FAST_XM_DB_TAG,"callback err code:" + err.code + " message:" + err.message);
      } else {
        logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,"callback, reminderId = " + reminderId);
        //更新数据库，将remindId同步到数据库中，用于删除时取消通知
        remindData.reminderAgentId = reminderId
        this.RemindTable.updateData(remindData, () => {
          //数据库更新成功之后，同步缓存中remind数据
          this.mList.fill(remindData,index,index+1)//使用fill进行元素的替换
          logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,`同步后的数据：${JSON.stringify(this.mList)}`)
        });
      }
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

  @Builder itemEnd(remindData:RemindData,index: number) {
    // 构建尾端滑出组件
    Button('删除',{ type: ButtonType.Normal })
      .height(80)
      .width(100)
      .fontColor($r('app.color.colorWhite'))
      .fontSize(12)
      .backgroundColor($r('app.color.colorGreen'))
      .onClick(() => {
        //从数据库中删除指定数据
        this.RemindTable.deleteData(remindData, () => {
          //从缓存删除指定数据项。
          this.mList.splice(index, 1);
          //取消通知
          reminderAgentManager.cancelReminder(remindData.reminderAgentId)
        });
      })
  }


  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Column() {
        /*这部分是顶部标题和menu的布局*/
        Row(){
          Text($r('app.string.main_page_title_remind_desc'))
            .fontColor($r('app.color.colorBlack'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .margin({left:10})
          Image($r('app.media.remind_menu'))
            .width(50)
            .height(50)
            .padding(10)
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
                .height(80)
                .backgroundColor($r('app.color.colorGreenMidNextLight'))
                .borderColor($r('app.color.colorBlack'))
                .borderWidth(1)
                .borderRadius(10)
                .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:5,offsetY:5})
                .margin({left:10,right:10})
              }
              .swipeAction({
                end: {
                  // index为该ListItem在List中的索引值。
                  builder: () => { this.itemEnd(item,index) },
                }
              })

            }, (item:string) => item)
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
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(10)
      .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:2,offsetY:2})
      .onClick(()=>{
        /*点击+号按钮进行提醒的添加*/
        this.dialogController.open()
      })
    }.width('100%')//宽度占满屏幕
    .height('100%')
    .padding({left:10,right:10})
  }
}