import MemorandumData from './MemorandumData';

export default class MemorandumDataWithImg{
  memorandumData: MemorandumData;
  memorandumImgList: string[];
  constructor(memorandumData: MemorandumData, memorandumImgList: string[]) {
    this.memorandumData = memorandumData;
    this.memorandumImgList = memorandumImgList;
  }
}