
import router from '@ohos.router'
@Component
@Preview
export struct MemorandumComp{
  @State title: string = '记录生活'
  @State isShowDefaultText:boolean = false
  @State arr: string[] = ['测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容',
    '测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容', '测试标题和内容']
  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Column() {
        /*这部分是顶部标题和menu的布局*/
        Row(){
          Text(this.title)
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
        .width('100%')
        .height(50)

        /*这部分是输入心情的文本框的布局*/
        Text($r('app.string.memorandum_input_default_desc'))
        .width('100%')
        .fontColor($r('app.color.colorGray'))
        .backgroundColor($r('app.color.colorGrayLight'))
        .padding(10)
        .borderRadius(6)
        .margin(10)
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
        Stack(){
          /*这部分是后续要增加的tips，暂时不处理*/

          /*这部分是展示的列表内容*/
          List() {//item的间隔，起始索引值
            //数据源，item和下标
            ForEach(this.arr, (item, index) => {
              ListItem() {
                Row(){
                  /*列表部分*/
                  /*时间轴实现部分*/
                  Column(){
                    Column()
                      .width(10)
                      .height(10)
                      .backgroundColor($r('app.color.colorGreen'))
                      .borderRadius(5)
                      .margin({top:5})
                    Column()
                      .width(1)
                      .height('100%')
                      .border({
                        width:{left:1},
                        color:{left:$r('app.color.colorGreen')}
                      })
                  }
                  Column(){
                    Text('2014-01-01').fontColor($r('app.color.colorGray'))
                    .width('95%')//TODO：宽度和下列组件保持统一，不然会ui显示异常，后续考虑优化
                    Stack(){
                      Rect()
                        .width('95%')
                        .height('95%')
                        .fill($r('app.color.colorGreen'))
                        .radius(10)
                        .margin({top:6,left:6})
                      Flex({direction: FlexDirection.Row, alignItems: ItemAlign.Center}) {
                        Image($r('app.media.ui_icon_sleep'))
                          .width(50)
                          .height(50)
                          .padding(8)
                          .margin({left:10})
                        Column(){
                          Text('' + item)
                            .fontSize(16)
                            .alignSelf(ItemAlign.Start)
                            .flexShrink(1)
                            .fontColor($r('app.color.colorBlack'))
                            .margin({left:10})
                          Text('' + item)
                            .fontSize(10)
                            .alignSelf(ItemAlign.Start)
                            .flexShrink(1)
                            .fontColor($r('app.color.colorGray'))
                            .margin({left:10,top:10})
                        }.layoutWeight(1)
                      }
                      .backgroundColor($r('app.color.colorGrayLight'))
                      .width('95%')
                      .height('95%')
                      .borderRadius(10)
                    }.layoutWeight(1).onClick(()=>{
                      router.pushUrl({
                        url: 'pages/memorandum/MemorandumDetail' // 目标url
                      }, router.RouterMode.Standard, (err) => {
                        if (err) {
                          console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                          return;
                        }
                        console.info('Invoke pushUrl succeeded.')
                      })
                    })
                  }
                }
              }
              .height(80)//TODO:目前是还原ui，后续进行逻辑和数据关联时，需要动态去设置背景的高度，因为目前把外部的高度定死了，后续展示的ui内容高度肯定是灵活的
              .margin({top:10})
            }, item => item)
          }.width('100%')
          /*这部分是没有列表数据时的默认占位内容*/
          Text($r('app.string.remind_default_desc'))
            .fontColor($r('app.color.colorGreen'))
            .textAlign(TextAlign.Center)
            .visibility(this.isShowDefaultText ? Visibility.Visible : Visibility.None)
        }
        .width('100%')//宽度占满屏幕
        .height('100%')
      }
      .width('100%')//宽度占满屏幕
      .height('100%')
      .padding({left:10,right:10})
      .backgroundColor($r('app.color.colorWhite'))


      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.base_add')).width(20).height(20).align(Alignment.Center)
      }.width(55).height(55).backgroundColor($r('app.color.colorGreen')).margin(20)
      .shadow({radius:10,color:$r('app.color.colorGray'),offsetX:2,offsetY:2})
      .visibility(Visibility.None)

      /*外层的tabs目前版本没有开放divider，所以在每个组件页面的底部增加一个divider*/
      Divider().strokeWidth(0.5).color($r('app.color.colorGray'))
    }.width('100%')//宽度占满屏幕
    .height('100%')
  }
}