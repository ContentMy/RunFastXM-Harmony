import router from '@ohos.router';
@Entry
@Component
@Preview
struct Guide {
  private timeOutId: number = 0;

  aboutToAppear() {//在此回调中添加定时器，2s后进入下一个页面
    this.timeOutId = setTimeout(() => {
      router.replaceUrl({ url: 'pages/Guide' })
        .catch((err: Error) => {
          console.error(JSON.stringify(err));
        })
    }, 2000);
  }

  aboutToDisappear() {//在此回调中销毁定时器
    clearTimeout(this.timeOutId);
  }



  build() {
    Column(){
      Blank()
      Row(){
        Image($r('app.media.icon'))
          .width(50).height(50)
        Text($r('app.string.app_name'))
          .margin(10)
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
      }.margin(10)
    }.width('100%').height('100%')
  }
}