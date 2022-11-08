String formatTime(DateTime dateTime) {
  int hour = dateTime.hour % 12;
  if (hour == 0) hour = 12;
  return '$hour.${dateTime.minute.toString().padLeft(2, "0")} ${dateTime.hour >= 12 ? "pm" : "am"}';
}

String formatDate(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isToday(DateTime dateTime) {
  return isSameDay(dateTime, DateTime.now());
}

bool isYesterday(DateTime dateTime) {
  return isSameDay(dateTime, DateTime.now().subtract(Duration(days: 1)));
}

String formatTimeAgo(DateTime dateTime) {
  if (isToday(dateTime)) {
    return formatTime(dateTime);
  }
  if (isYesterday(dateTime)) {
    return 'Yesterday';
  }
  return formatDate(dateTime);
}

String timeOfDay() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Morning';
  if (hour < 18) return 'Afternoon';
  if (hour < 21) return 'Evening';
  return 'Night';
}

String timeTodayOrYesterday(DateTime dateTime) {
  String time = formatTime(dateTime);
  if (isToday(dateTime)) {
    return 'Today, $time';
  }
  if (isYesterday(dateTime)) {
    return 'Yesterday, $time';
  }
  return 'A while ago';
}