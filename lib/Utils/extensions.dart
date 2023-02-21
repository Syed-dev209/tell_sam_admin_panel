import 'dart:developer';

extension DateTimeExtension on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    log("Date to check===> $date");
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }

  DateTime? thisMonthStartingDate() {
    try {
      final date = this!;
      DateTime newDate = DateTime(
        date.year,
        date.month,
        1,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
      return newDate;
    } catch (e) {
      return null;
    }
  }

  DateTime? thisMonthEndingDate() {
    try {
      final date = this!;
      DateTime newDate = DateTime(
        date.year,
        date.month + 1,
        0,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
      return newDate;
    } catch (e) {
      return null;
    }
  }
}
