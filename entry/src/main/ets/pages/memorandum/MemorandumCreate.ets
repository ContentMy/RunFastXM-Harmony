import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import MemorandumData from '../../common/database/data/MemorandumData'
import MemorandumTable from '../../common/database/tables/MemorandumTable'
import { PageEventBus } from '../../common/utils/PageEventBus'
import { logger } from '../../common/utils/logger'
import MemorandumImgTable from '../../common/database/tables/MemorandumImgTable'
import { picker } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit'
import MemorandumImgData from '../../common/database/data/MemorandumImgData'
import { CommonConstants } from '../../common/contants/CommonConstants'

@Entry
@Component
@Preview
struct MemorandumCreate {
  @State MAX_SELECT_NUM:number = 9; // 选择媒体文件的最大数目
  @State memorandumTitleValue:string = ''
  @State memorandumContentValue:string = ''
  @State memorandumCreateTime:number = 0
  @State mMemorandumData:MemorandumData = new MemorandumData()
  private MemorandumTable = new MemorandumTable(() => {});
  @State imgPathList : string[] = []
  private MemorandumImgTable = new MemorandumImgTable(() => {});
  private maxImageCount: number = 9;


  // 拉起picker选择图片/视频
  async callFilePickerSelectImage(): Promise<void> {
    let array: string[];
    try {
      // 设置photoPicker的参数
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      // 过滤选择媒体文件类型
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
      // 选择媒体文件的最大数目
      PhotoSelectOptions.maxSelectNumber = this.MAX_SELECT_NUM;
      let mediaFlag = false;
      // 使用图库选择器对象前，需要先创建PhotoViewPicker实例
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
        // 接口采用callback异步返回形式，返回PhotoSelectResult对象，故进行下一步操作前要先判断是否已经成功返回PhotoSelectResult对象了
        if (PhotoSelectResult !== null && PhotoSelectResult !== undefined) {
          // PhotoSelectResult为返回的结果集。
          // 其中包含Array<string>类型的photoUris，为返回图库选择后的媒体文件的uri数组；还包含boolean类型的isOriginalPhoto，指示返回图库选择后的媒体文件是否为原图。
          // 声明变量array，其取值为PhotoSelectResult中的数组。
          array = PhotoSelectResult['photoUris'];
          array.forEach((value) => {
            this.imgPathList.push(value);
          })
        }
        //首次可以选择9张图片，如果选择的图片小于9张，那么计算下一次可以选择的最大图片数量为最大的图片容纳量9减去当前的已选择的图片列表数量
        if (this.imgPathList.length < this.maxImageCount) {
          this.MAX_SELECT_NUM = this.maxImageCount - this.imgPathList.length;
        }
      }).catch((err: BusinessError) => {
        // Logger.error(TAG, 'PhotoViewPicker.select failed with err: ' + JSON.stringify(err));
      });
    } catch (err) {
      // Logger.error(TAG, 'PhotoViewPicker failed with err: ' + err);
    }
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
        Text($r('app.string.memorandum_create_desc'))
          .fontColor($r('app.color.colorBlack'))
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.save_desc'), { type: ButtonType.Normal, stateEffect: true })
          .backgroundColor($r('app.color.colorGreen'))
          .width(50)
          .borderRadius(6)
          .margin(10)
          .onClick(()=>{
            try{
              console.log('点击了按钮');
              if (this.memorandumTitleValue.trim().length == 0) {
                promptAction.showToast({message: $r('app.string.memorandum_create_title_null_desc'),duration: 2000})
                return;
              }
              this.memorandumCreateTime = Date.now()
              this.mMemorandumData.memorandumTitle = this.memorandumTitleValue
              this.mMemorandumData.memorandumContent = this.memorandumContentValue
              this.mMemorandumData.memorandumCreateTime = this.memorandumCreateTime
              this.MemorandumTable.insertData(this.mMemorandumData, (id: number) => {
                //根据返回的id，组装MemorandumImgData，插入数据库
                this.imgPathList.forEach((value)=>{
                  let memorandumImgData = new MemorandumImgData();
                  memorandumImgData.memorandumId = id;
                  memorandumImgData.memorandumImgFilePath = value;
                  this.MemorandumImgTable.insertData(memorandumImgData,(id:number)=>{
                    logger.debug(CommonConstants.RUN_FAST_XM_DB_TAG,'图片插入成功')
                  })
                })
                PageEventBus.getInstance().publish('refreshMemorandumComp');
                router.back()
              });
            }catch (e){
              logger.error(e)
            }
          })
      }
      .width('100%')
      .height(50)
      /*这里是输入框组件内容*/
      TextInput({placeholder:$r('app.string.memorandum_input_default_desc'),text:this.memorandumTitleValue})
        .width('100%')
        .fontColor($r('app.color.colorGray'))
        .backgroundColor($r('app.color.colorGrayLight'))
        .padding(10)
        .borderRadius(6)
        .margin(10)
        .onChange((value: string) => {
          this.memorandumTitleValue = value
        })
      /*这里是内容输入提示的组件*/
      Text($r('app.string.memorandum_content_desc'))
        .fontColor($r('app.color.colorGray'))
        .fontSize(12)
        .width('95%')
        .margin({ top:10 })
      /*这里是内容输入框组件*/
      TextInput({placeholder:$r('app.string.memorandum_content_default_desc'),text:this.memorandumContentValue})
        .width('100%')
        .height(200)
        .align(Alignment.TopStart)
        .fontColor($r('app.color.colorGray'))
        .backgroundColor($r('app.color.colorGrayLight'))
        .padding(10)
        .borderRadius(6)
        .margin(10)
        .onChange((value: string) => {
          this.memorandumContentValue = value
        })
      /*这里是添加图片列表提示的组件*/
      Text($r('app.string.memorandum_resource_img_desc'))
        .fontColor($r('app.color.colorGray'))
        .fontSize(12)
        .width('95%')
        .margin({ top:10 })
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
        ForEach(this.imgPathList, (imgPath:string, index) => {
          Image(imgPath)
            .width(100)
            .height(100)
            .margin(5)
        });

        // 如果图片数量小于最大数量，显示添加图片按钮
        if (this.imgPathList.length < this.maxImageCount) {
          Image($r('app.media.user_select'))
            .width(100)
            .height(100)
            .margin(5)
            .onClick(() => {
              this.callFilePickerSelectImage();
            });
        }
      }
      .width('100%');
    }
  }
}