// core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _shortDateFormat = DateFormat('MMM dd');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, MMMM dd, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy • h:mm a');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dayMonthFormat = DateFormat('dd MMM');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');

  static String shortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String fullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  static String dateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String time(DateTime date) {
    return _timeFormat.format(date);
  }

  static String dayMonth(DateTime date) {
    return _dayMonthFormat.format(date);
  }

  static String monthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String iso(DateTime date) {
    return _isoFormat.format(date);
  }

  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static String formatBookingDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today at ${time(date)}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow at ${time(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE').format(date)} at ${time(date)}';
    } else {
      return dateTime(date);
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
           date.isBefore(weekEnd.add(const Duration(days: 1)));
  }
}
