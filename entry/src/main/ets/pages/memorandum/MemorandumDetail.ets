import router from '@ohos.router'
import MemorandumData from '../../common/database/data/MemorandumData';
import MemorandumDataWithImg from '../../common/database/data/MemorandumDataWithImg';
import MemorandumImgData from '../../common/database/data/MemorandumImgData';
import MemorandumImgTable from '../../common/database/tables/MemorandumImgTable';
import MemorandumTable from '../../common/database/tables/MemorandumTable';

@Entry
@Component
@Preview
struct MemorandumDetail {
  @State memorandumTitleValue:string = ''
  @State memorandumContentValue:string = ''
  @State memorandumCreateTime:number = 0
  @State memorandumUpdateTime:number = 0
  @State imgPathList : string[] = []

  onPageShow(): void {
    const params = router.getParams() as Record<string, MemorandumDataWithImg>; // 获取传递过来的参数对象
    if (params) {
      const data:MemorandumDataWithImg = params.data as MemorandumDataWithImg; // 获取info属性的值
      this.memorandumTitleValue = data.memorandumData.memorandumTitle
      this.memorandumContentValue = data.memorandumData.memorandumTitle
      this.memorandumCreateTime = data.memorandumData.memorandumCreateTime
      this.memorandumUpdateTime = data.memorandumData.memorandumUpdateTime
      this.imgPathList = data.memorandumImgList
    }
  }

  build() {
    Column() {
      /*这里是标题栏相关组件内容*/
      //TODO：后续优化统一对这些标题栏进行复用
      Row() {
        Image($r('app.media.ui_back_black'))
          .width(50)
          .height(50)
          .padding(15)
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.memorandum_detail_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Blank().width(50)
      }
      .width('100%')
      .height(50)

      Column() {
        /*这里是title组件内容*/
        Text(this.memorandumTitleValue)
          .width('100%')
          .fontColor($r('app.color.colorBlack'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        /*这里是创建时间组件*/
        Text(`创建时间：${this.memorandumCreateTime}`)
          .fontColor($r('app.color.colorGray'))
          .fontSize(12)
          .width('100%')
          .margin({ top: 10 })
        /*这里是修改时间组件*/
        Text(`修改时间：${this.memorandumUpdateTime}`)
          .fontColor($r('app.color.colorGray'))
          .fontSize(12)
          .width('100%')
          .margin({ top: 10 })
        /*这里是内容组件*/
        Text(this.memorandumContentValue)
          .width('100%')
          .height(200)
          .align(Alignment.TopStart)
          .fontColor($r('app.color.colorWhite'))
          .backgroundColor($r('app.color.colorGreen'))
          .padding(10)
          .borderRadius(6)
          .margin({ top:10 })
        /*这里是添加图片列表提示的组件*/
        Text($r('app.string.memorandum_resource_img_desc'))
          .fontColor($r('app.color.colorGray'))
          .fontSize(12)
          .width('100%')
          .margin({ top: 10 })
          .visibility(this.imgPathList.length === 0 ? Visibility.None : Visibility.Visible)
        /*这里是添加图片列表组件*/
        //首先是一个加载9宫格的图片列表组件
        //然后是如果图片地址的数组长度为0，那么添加一个默认的图片用于点击添加下一个图片
        //首先删除最后一个图片（这个是用于添加图片的默认图片按钮），添加完图片后，如果数组长度小于9，那么追加一个默认图片
        Flex({
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center,
          wrap: FlexWrap.Wrap,
        }) {
          // 遍历图片地址数组，显示图片
          ForEach(this.imgPathList, (imgPath: string, index) => {
            Image(imgPath)
              .width(100)
              .height(100)
              .margin(5)
          });
        }
      }.width('100%')
      .padding({ left: 10, right: 10 })
      .margin({top:20})
    }.width('100%')
  }
}