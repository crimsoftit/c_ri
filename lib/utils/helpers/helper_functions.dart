import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CHelperFunctions {
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String getFormattedPrice(String value) {
    NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

    // NumberFormat currencyFormat = NumberFormat.simpleCurrency(
    //     locale: 'hi_KE', name: Intl.defaultLocale, decimalDigits: 2);

    // Locale locale = Localizations.localeOf(Get.overlayContext!);

    // NumberFormat autoCurrencyFormat = NumberFormat.simpleCurrency(
    //     locale: Platform.localeName, decimalDigits: 2);

    //formattedBp.value = numberFormat.format(double.parse(value));
    // formattedBp.value = currencyFormat.format(double.parse(value));
    // formattedBp_1.value = autoCurrencyFormat.format(double.parse(value));

    // var formatter = NumberFormat.simpleCurrency(locale: locale.toString());
    // currencySymbol.value = formatter.currencySymbol;

    // CountryDetails details = CountryCodes.detailsForLocale(
    //     Localizations.localeOf(Get.overlayContext!));
    // countryCode.value = details.alpha2Code!;
    return numberFormat.format(double.parse(value));
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(
        children: rowChildren,
      ));
    }
    return wrappedList;
  }
}
