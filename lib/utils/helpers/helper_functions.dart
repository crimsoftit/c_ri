import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CHelperFunctions {
  static Color? getColor(String value) {
    // -- define products' specific colors and it will match the attribute colors and show specific colors
    if (value == 'red' || value == 'Red') {
      return Colors.red;
    } else if (value == 'green' || value == 'Green') {
      return Colors.green;
    } else if (value == 'green' || value == 'Green') {
      return Colors.green;
    } else if (value == 'blue' || value == 'Blue') {
      return Colors.blue;
    } else if (value == 'pink' || value == 'Pink') {
      return Colors.pink;
    } else if (value == 'grey' || value == 'Grey') {
      return Colors.grey;
    } else if (value == 'purple' || value == 'Purple') {
      return Colors.purple;
    } else if (value == 'black' || value == 'Black') {
      return Colors.black;
    } else if (value == 'white' || value == 'White') {
      return Colors.white;
    } else if (value == 'brown' || value == 'Brown') {
      return Colors.brown;
    } else if (value == 'teal' || value == 'Teal') {
      return Colors.teal;
    } else if (value == 'indigo' || value == 'Indigo') {
      return Colors.indigo;
    } else if (value == 'orange' || value == 'Orange') {
      return Colors.orange;
    } else if (value == 'yellow' || value == 'Yellow') {
      return Colors.yellow;
    } else {
      return null;
    }
  }

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
