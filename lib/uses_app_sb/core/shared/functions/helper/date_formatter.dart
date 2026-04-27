import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  // Formats a DateTime object into a date string.
  static String formatDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('EEE dd MMM ', Get.locale.toString());
    return dateFormat.format(dateTime.toLocal());
  }

  // Formats a DateTime object into a time string.
  static String formatTime(DateTime dateTime) {
    DateFormat timeFormat = DateFormat('h:mm a', Get.locale.toString());
    return timeFormat.format(dateTime.toLocal());
  }

  // Returns only the year from a DateTime object.
  static String getYear(DateTime dateTime) {
    DateFormat yearFormat = DateFormat('yyyy', Get.locale.toString());
    return yearFormat.format(dateTime);
  }

  static String formatPostTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'seconds_ago'.trParams({'count': '${difference.inSeconds}'});
    } else if (difference.inMinutes < 60) {
      return 'minutes_ago'.trParams({'count': '${difference.inMinutes}'});
    } else if (difference.inHours < 24) {
      return 'hours_ago'.trParams({'count': '${difference.inHours}'});
    } else if (difference.inDays == 1) {
      return 'yesterday'.tr;
    } else if (difference.inDays < 7) {
      return 'days_ago'.trParams({'count': '${difference.inDays}'});
    } else if (difference.inDays < 30) {
      return 'weeks_ago'.trParams({'count': '${(difference.inDays / 7).floor()}'});
    } else if (difference.inDays < 365) {
      return 'months_ago'.trParams({'count': '${(difference.inDays / 30).floor()}'});
    } else {
      return 'years_ago'.trParams({'count': '${(difference.inDays / 365).floor()}'});
    }
  }
}

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  if (currentDate.month < birthDate.month ||
      (currentDate.month == birthDate.month &&
          currentDate.day < birthDate.day)) {
    age--;
  }
  return age;
}
