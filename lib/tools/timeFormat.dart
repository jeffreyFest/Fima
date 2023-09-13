import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  final originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
  final targetFormat = DateFormat("MMM dd, yyyy 'at' hh:mma");

  final dateTime = originalFormat.parse(dateTimeString);
  final formattedDateTime = targetFormat.format(dateTime);
  return formattedDateTime;
}

String DateTime(dateTimeString) {
  final originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
  final targetFormat = DateFormat("MMM dd, yyyy hh:mma", "en_NG");

  final dateTime = originalFormat.parse(dateTimeString);
  final formattedDateTime = targetFormat.format(dateTime);
  return formattedDateTime;
}

