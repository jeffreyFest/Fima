import 'package:intl/intl.dart';

String formatBalance(int? balance) {
    if(balance == null){
      return '----';
    }
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');

    if (balance >= 1000000) {
      final int balanceInMillions = balance ~/ 1000000;

      if (balance % 1000000 != 0) {
        return '${formatter.format(balanceInMillions)}M+'.replaceAll('.00', '');
      } else {
        return '${formatter.format(balanceInMillions)}M'.replaceAll('.00', '');
      }
    }

    return formatter.format(balance).replaceAll('.00', '');
  }

   String formatBalancefull(int? balance) {
    if(balance == null){
      return '----';
    }
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');
    return formatter.format(balance).replaceAll('.00', '');
  }


String debitBalance(balance) {
    if(balance == null){
      return '----';
    }
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');
 
    if (balance >= 1000000) {
      final int balanceInMillions = balance ~/ 1000000;

      if (balance % 1000000 != 0) {
        return '${formatter.format(balanceInMillions)}M+'.replaceAll('.00', '');
      } else {
        return '${formatter.format(balanceInMillions)}M'.replaceAll('.00', '');
      }
    }

    return formatter.format(balance).replaceAll('.00', '');
  }


///Correct formatting the number ton have comma
String formatAmountWithCommas(String value) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  final parsedValue = double.tryParse(value);
  if (parsedValue != null) {
    if (parsedValue % 1 == 0) {
      // Format as whole number without decimal places
      return formatter.format(parsedValue).split('.').first;
    } else {
      // Format with decimal places
      return formatter.format(parsedValue);
    }
  }
  return value;
}
