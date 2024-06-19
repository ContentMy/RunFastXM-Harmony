export default class RemindData{
  id: number = -1;
  remindImg: string = '';
  remindTitle: string = '';
  remindContent: string = '';
  remindTime: number = 0;
  remindStartTime: number = 0;
  remindEndTime: number = 0;
  remindCompleteStatus: boolean = false;

  // 添加 toString 方法
  toString(): string {//TODO：日志输出为[object,object],找一下原因
    return `RemindData {
      id: ${this.id},
      remindImg: '${this.remindImg}',
      remindTitle: '${this.remindTitle}',
      remindContent: '${this.remindContent}',
      remindTime: ${this.remindTime},
      remindStartTime: ${this.remindStartTime},
      remindEndTime: ${this.remindEndTime},
      remindCompleteStatus: ${this.remindCompleteStatus}
    }`;
  }
}