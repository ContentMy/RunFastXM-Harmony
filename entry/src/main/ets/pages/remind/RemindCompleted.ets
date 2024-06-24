import router from '@ohos.router';
import RemindData from '../../common/database/data/RemindData';
import RemindTable from '../../common/database/tables/RemindTable';

@Entry
@Component
@Preview
struct RemindCompleted {
  @State mList:Array<RemindData> = []
  @State mRemindData:RemindData = new RemindData()
  private RemindTable = new RemindTable(() => {});

  onPageShow(){
  }

  aboutToAppear(){
    this.RemindTable.getRdbStore(() => {
      this.RemindTable.queryAllCompletedRemind(0, (result: RemindData[]) => {
        this.mList = result;
      }, true);
    });
  }

  build() {
    Column(){
      /*这里是标题栏相关组件内容*/
      //TODO：后续优化统一对这些标题栏进行复用
      Row(){
        Image($r('app.media.ui_back_black'))
          .width(50)
          .height(50)
          .padding(15)
          .onClick(()=>{
            router.back()
          })
        Text($r('app.string.remind_completed_title_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      .width('100%')
      .height(50)
      /*这里已完成提醒的列表组件内容*/
      Stack(){
        /*这部分是展示的列表内容*/
        List({space:20, initialIndex:0}) {//item的间隔，起始索引值
          //数据源，item和下标
          ForEach(this.mList, (item:RemindData, index) => {
            ListItem() {
              //布局方向，item对齐方式
              Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                Image($r('app.media.remind_item_icon_gray'))
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
            .backgroundColor($r('app.color.colorGrayLight'))
            .borderColor($r('app.color.colorBlack'))
            .borderWidth(1)
            .borderRadius(10)
            .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:5,offsetY:5})
            .margin({left:20,right:20})

          }, (item:string) => item)//TODO：这个第三个参数的具体作用以及含义需要研究一下
        }.width('100%')
        /*这部分是没有列表数据时的默认占位内容*/
        Text($r('app.string.remind_completed_default_desc'))
          .fontColor($r('app.color.colorGreen'))
          .textAlign(TextAlign.Center)
          .visibility(this.mList.length == 0 ? Visibility.Visible : Visibility.None)
      }
      .width('100%')//宽度占满屏幕
      .height('100%')
    }
  }
}