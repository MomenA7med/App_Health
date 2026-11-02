import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateFormat {
  static DateFormat appDateFormat(String local) {
    return DateFormat.yMMMMd(local);
  }

  static DateFormat appDatePickerFormat(String local) {
    return DateFormat.yMMMMd(local);
  }

  static DateTime appDatePickerParse(String date, String local) {
    return appDatePickerFormat(local).parse(date);
  }

  static String formattingDatePicker(DateTime date, String local) {
    return appDatePickerFormat(local).format(date);
  }

  static String formattingDate(DateTime date, String local) {
    return appDateFormat(local).format(date);
  }

  static String formattingOnlyMonthDay(DateTime date, String local) {
    return DateFormat.MMMd(local).format(date);
  }

  static String formattingShortDayMonthYear(DateTime date, String local) {
    return DateFormat('d MMM yy', local).format(date);
  }

  static String formattingDateToMonth(DateTime date, String local) {
    return DateFormat.yMMMM(local).format(date);
  }

  static String formattingMonthDay(DateTime date, String local) {
    return DateFormat.yMMMd(local).format(date);
  }

  static String formattingApiDate(DateTime? date, String local) {
    try {
      return DateFormat("yyyy-MM-dd", local).format(date!);
    } catch (e) {
      return "";
    }
  }

  static DateTime? formattingApiDateFromString(String? date) {
    try {
      // 10/25/2023
      return DateFormat('dd/MM/yyyy').parse(date!);
    } catch (e) {
      return null;
    }
  }

  static String formattingDisplayDate(DateTime date, String local) {
    return DateFormat("MM/dd/yyyy", local).format(date);
  }

  static String tryFormattingDate(DateTime? date, String local) {
    try {
      return appDateFormat(local).format(date!);
    } catch (e) {
      return "";
    }
  }

  static String formattingTime(DateTime date, String local) {
    return DateFormat.jm(local).format(date);
  }

  static String formattingDateTime(DateTime date, String local) {
    return appDateFormat(local).add_jm().format(date);
  }

  static String formattingDateTimeUtc(DateTime date, String local) {
    return DateFormat('d-M-yyyy. hh:mm a', local).format(date.toUtc());
  }

  static String formattingDateTTimeZ(DateTime date, String local) {
    return DateFormat('yyyy-MM-ddThh:mm:ss', local).format(date);
  }

  static String formatDayMonthAndYearWithTime(DateTime date, String local) {
    return DateFormat('EEEE, d MMMM yyyy. hh:mm a', local).format(date);
  }

  static String formatDateWithTime(DateTime date, String local) {
    return DateFormat('d MMMM yyyy. hh:mm a', local).format(date);
  }

  static String formattingDayMonthTime(DateTime date, String local) {
    return DateFormat('EEEE, d MMMM, ', local).format(date) +
        formattingTime(date, local);
  }

  static String formattingTimeOfDay(TimeOfDay time, BuildContext context) {
    try {
      return time.format(context);
    } catch (e) {
      return "";
    }
  }
}
