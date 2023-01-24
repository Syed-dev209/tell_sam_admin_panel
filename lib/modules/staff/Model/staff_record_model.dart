class StaffRecord {
  String? name;
  String? date;
  String? branchName;
  String? clockIn;
  String? clockOut;
  int? clockInRecordId, clockOutRecordId;
  String? totalHrsSpent;

  StaffRecord(
      {this.branchName,
      this.clockIn,
      this.clockOut,
      this.date,
      this.name,
      this.totalHrsSpent,
      this.clockInRecordId,
      this.clockOutRecordId});
}
