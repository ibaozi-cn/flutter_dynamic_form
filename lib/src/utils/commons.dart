/// date formats
const DATE_FORMATS = [
  "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
  "yyyy/MM/dd'T'HH:mm:ss.SSSZ",
  "yyyy-MM-dd HH:mm:ss",
  "yyyy/MM/dd HH:mm:ss",
  "yyyy-MM-dd",
  "yyyy/MM/dd"
];

const DEFAULT_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";

class DateFormat {

  static String formatDateStr(String dateStr, {bool isUtc, String format}) {
    return formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);
  }

  static DateTime getDateTime(
    String dateStr, {
    bool isUtc,
  }) {
    DateTime dateTime = DateTime.tryParse(dateStr);
    if (dateTime == null) return null;
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime.toUtc();
      } else {
        dateTime = dateTime.toLocal();
      }
    }
    return dateTime;
  }

  static String formatDate(DateTime dateTime, {bool isUtc, String format}) {
    if (dateTime == null) return "";
    format = format ?? DEFAULT_DATE_FORMAT;
    if (format.contains("yy")) {
      String year = dateTime.year.toString();
      if (format.contains("yyyy")) {
        format = format.replaceAll("yyyy", year);
      } else {
        format = format.replaceAll(
            "yy", year.substring(year.length - 2, year.length));
      }
    }
    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  static String _comFormat(
      int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format =
            format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  static DateTime today({hour: -1, minute: -1, second: -1, millisecond: -1, microsecond: -1}) {
    DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      hour >= 0 ? hour : 0,
      minute >= 0 ? minute : 0,
      second >= 0 ? second : 0,
      millisecond >= 0 ? millisecond : 0,
      microsecond >= 0 ? microsecond : 0,
    );
  }

  static DateTime yesterday({hour: -1, minute: -1, second: -1, millisecond: -1, microsecond: -1}) {
    DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day - 1,
      hour >= 0 ? hour : 0,
      minute >= 0 ? minute : 0,
      second >= 0 ? second : 0,
      millisecond >= 0 ? millisecond : 0,
      microsecond >= 0 ? microsecond : 0,
    );
  }

  static DateTime tomorrow({hour: -1, minute: -1, second: -1, millisecond: -1, microsecond: -1}) {
    DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day + 1,
      hour >= 0 ? hour : 0,
      minute >= 0 ? minute : 0,
      second >= 0 ? second : 0,
      millisecond >= 0 ? millisecond : 0,
      microsecond >= 0 ? microsecond : 0,
    );
  }

  static const List<int> _leapYearMonths = <int>[1, 3, 5, 7, 8, 10, 12];

  static int daysOfTheMonth(DateTime time) {
    assert(time != null);
    if (_leapYearMonths.contains(time.month)) {
      return 31;
    } else if (time.month == 2) {
      if ((time.year % 4 == 0 && time.year % 100 != 0) || time.year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }
}

class StringUtils {
  /// {@tool sample}
  /// StringUtils.isBlank(null)      = true
  /// StringUtils.isBlank("")        = true
  /// StringUtils.isBlank(" ")       = true
  /// StringUtils.isBlank("bob")     = false
  /// StringUtils.isBlank("  bob  ") = false
  /// {@end-tool}
  static bool isBlank(String text) {
    return !isNotBlank(text);
  }

  static bool isNotBlank(String text) {
    return (text?.trim()?.length ?? 0) > 0;
  }
}
