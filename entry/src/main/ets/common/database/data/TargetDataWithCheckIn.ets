import TargetData from './TargetData'
export default class TargetDataWithCheckIn{
  targetData: TargetData;
  targetCheckInStatus: boolean;
  constructor(targetData: TargetData, targetCheckInStatus: boolean) {
    this.targetData = targetData;
    this.targetCheckInStatus = targetCheckInStatus;
  }
}