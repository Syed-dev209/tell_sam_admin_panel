class StaffRecord {
  String? name;
  String? date;
  String? LocationName;
  int? LocationId;
  String? clockIn, rawClockIn;
  String? clockOut, rawClockOut;
  int? clockInRecordId, clockOutRecordId;
  String? totalHrsSpent, rawDate;

  StaffRecord(
      {this.LocationName,
      this.clockIn,
      this.clockOut,
      this.date,
      this.name,
      this.totalHrsSpent,
      this.clockInRecordId,
      this.clockOutRecordId,
      this.rawClockIn,
      this.rawClockOut,
      this.rawDate,
      this.LocationId});
}
