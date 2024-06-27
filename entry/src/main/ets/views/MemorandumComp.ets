
import router from '@ohos.router'
import { CommonConstants } from '../common/contants/CommonConstants';
import MemorandumData from '../common/database/data/MemorandumData';
import MemorandumDataWithImg from '../common/database/data/MemorandumDataWithImg';
import MemorandumTable from '../common/database/tables/MemorandumTable';
import { logger } from '../common/utils/logger';
import { PageEventBus } from '../common/utils/PageEventBus';
import { systemDateTime } from '@kit.BasicServicesKit';

@Component
@Preview
export struct MemorandumComp{
  @State mList:Array<MemorandumData> = []
  @State mMemorandumData:MemorandumData = {id:0,memorandumIcon:'',memorandumTitle:'',memorandumContent:'',memorandumCreateTime:0,memorandumUpdateTime:0}
  private MemorandumTable = new MemorandumTable(() => {});
  @State isLongClick:boolean = false;
  @State isShowDelete:boolean = false;
  private touchTime:number = 0

  aboutToAppear(){//TODO:从目标新建页面返回时，这个回调不会被调用
    PageEventBus.getInstance().subscribe('refreshMemorandumComp', this.refreshPage.bind(this));
    this.refreshPage()
  }

  aboutToDisappear(){
    PageEventBus.getInstance().unsubscribe('refreshMemorandumComp', this.refreshPage.bind(this));
  }

  refreshPage(){
    this.MemorandumTable.getRdbStore(() => {
      this.MemorandumTable.query(0, (result: MemorandumData[]) => {
        this.mList = result;
      }, true);
    });
  }

  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Column() {
        /*这部分是顶部标题和menu的布局*/
        Row(){
          Text($r('app.string.main_page_title_memorandum_desc'))
            .fontColor($r('app.color.colorBlack'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
          Image($r('app.media.remind_menu'))
            .width(50)
            .height(50)
            .padding(10)
            .visibility(Visibility.None)
        }
        .width('95%')
        .height(50)
        .margin({left:10,right:10})


        /*这部分是输入心情的文本框的布局*/
        Text($r('app.string.memorandum_input_default_desc'))
          .width('95%')
          .fontColor($r('app.color.colorGray'))
          .backgroundColor($r('app.color.colorGrayLight'))
          .padding(10)
          .borderRadius(6)
          .onClick((event:ClickEvent)=>{
            router.pushUrl({
              url: 'pages/memorandum/MemorandumCreate' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.')
            })
          })


        /*这部分是展示列表的ui布局*/
        Stack({alignContent:Alignment.Start}){
          /*这部分是后续要增加的tips，暂时不处理*/

          /*这部分是展示的列表内容*/
          List() {//item的间隔，起始索引值
            //数据源，item和下标
            ForEach(this.mList, (item:MemorandumDataWithImg, index) => {
              ListItem() {//这里的布局高度目前没有办法像Android一样包裹，使用auto会直接撑满,所以暂时的方案为根据有图或者无图的情况去加载不同的高度
                Row(){
                  /*列表部分*/
                  /*时间点实现部分*/
                  Column()
                    .width(10)
                    .height(10)
                    .backgroundColor($r('app.color.colorGreen'))
                    .borderRadius(5)
                    .margin({top:5,left:10})
                  Column(){
                    Text(this.getTimeString(item.memorandumData.memorandumCreateTime,'yyyy-MM-dd')).fontColor($r('app.color.colorGray'))
                    .width('90%')//TODO：宽度和下列组件保持统一，不然会ui显示异常，后续考虑优化
                    Stack({alignContent:Alignment.TopEnd}){
                      Stack(){
                        Rect()
                          .width('90%')
                          .height('90%')
                          .fill($r('app.color.colorGreen'))
                          .radius(10)
                          .margin({top:6,left:6})
                        Flex({direction: FlexDirection.Row,alignItems: ItemAlign.Start}) {
                          Image($r('app.media.ui_icon_sleep'))
                            .width(50)
                            .height(50)
                            .padding(5)
                            .margin({left:10,top:10})
                          Column(){
                            Text(item.memorandumData.memorandumTitle)
                              .fontSize(16)
                              .alignSelf(ItemAlign.Start)
                              .flexShrink(1)
                              .fontColor($r('app.color.colorBlack'))
                              .margin({left:10,top:5})
                            Text(item.memorandumData.memorandumContent)
                              .fontSize(12)
                              .alignSelf(ItemAlign.Start)
                              .flexShrink(1)
                              .fontColor($r('app.color.colorGray'))
                              .margin({left:10,top:5})

                            Flex({
                              justifyContent: FlexAlign.SpaceBetween,
                              alignItems: ItemAlign.Center,
                              wrap: FlexWrap.Wrap,
                            }) {
                              // 遍历图片地址数组，显示图片，仅显示前三张图片，如果小于3张，就显示全部
                              ForEach(item.memorandumImgList.length > 3 ? item.memorandumImgList.slice(0, 3) : item.memorandumImgList, (imgPath:string, index) => {
                                Image(imgPath)
                                  .width(50)
                                  .height(50)
                                  .margin(5)
                              });
                            }
                          }.layoutWeight(1).margin({left:10,top:10})
                        }
                        .backgroundColor($r('app.color.colorGrayLight'))
                        .width('90%')
                        .height('90%')
                        .borderRadius(10)
                      }.margin({right:10,top:10})

                      Image($r('app.media.ui_close'))
                        .width(20)
                        .height(20)
                        .margin({top:5,right:5})
                        .visibility(this.isShowDelete?Visibility.Visible:Visibility.None)
                        .onClick(()=>{
                          this.MemorandumTable.deleteData(item.memorandumData, () => {
                            this.mList.splice(index,1);
                          });
                        })
                    }.layoutWeight(1).onClick(()=>{
                      if(this.isLongClick){
                        return
                      }

                      if(this.isShowDelete){
                        this.isShowDelete = false;
                        return
                      }
                      router.pushUrl({
                        url: 'pages/memorandum/MemorandumDetail', // 目标url
                        params: {
                          data: item
                        }
                      }, router.RouterMode.Standard, (err) => {
                        if (err) {
                          console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                          return;
                        }
                        console.info('Invoke pushUrl succeeded.')
                      })
                    })
                    .onTouch((event: TouchEvent) =>{//通过触摸事件处理长按
                      switch (event.type){
                        case TouchType.Down:
                          this.touchTime = systemDateTime.getTime();
                          logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'按下'+ this.touchTime)
                          this.isLongClick = false;
                          break;
                        case TouchType.Move:
                          break;
                        case TouchType.Up:
                          let upTime = systemDateTime.getTime()
                          if(upTime - this.touchTime > 1000){//如果按住超过1s，认为是长按
                            logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'长按事件'+upTime + '-' +  this.touchTime + '差为：' + (upTime -  this.touchTime))
                            this.isLongClick = true;
                            this.isShowDelete = true;
                          }else{
                            logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'抬起' + (upTime - this.touchTime))
                          }
                          break;
                      }
                    })
                  }.margin({left:10})
                }.alignItems(VerticalAlign.Top)
              }
              .height(item.memorandumImgList.length === 0 ? 100 : 150)//TODO:目前是还原ui，后续进行逻辑和数据关联时，需要动态去设置背景的高度，因为目前把外部的高度定死了，后续展示的ui内容高度肯定是灵活的
              .margin({top:10})
            }, (item:string) => item)
          }.width('100%').height('100%').scrollBar(BarState.Off)
          /*时间轴 - 时间线部分*/
          Line()
            .width(10)
            .height('100%')
            .border({
              width:{left:1},
              color:{left:$r('app.color.colorGreen')}
            })
            .margin({left:15})
            .visibility(this.mList.length == 0 ? Visibility.None : Visibility.Visible)

          /*这部分是没有列表数据时的默认占位内容*/
          Text($r('app.string.memorandum_default_desc'))
            .width('100%')
            .fontColor($r('app.color.colorGreen'))
            .textAlign(TextAlign.Center)
            .visibility(this.mList.length == 0 ? Visibility.Visible : Visibility.None)
        }
        .width('100%')//宽度占满屏幕
        .height('100%')
      }
      .width('100%')//宽度占满屏幕
      .height('100%')
      .backgroundColor($r('app.color.colorWhite'))


      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.base_add')).width(20).height(20).align(Alignment.Center)
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(20)
      .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:2,offsetY:2})
      .visibility(Visibility.None)
    }.width('100%')//宽度占满屏幕
    .height('100%')
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