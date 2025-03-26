import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CDashboardController extends GetxController {
  static CDashboardController get instance => Get.find();

  /// -- variables --
  final RxList<double> weeklySales = <double>[].obs;
  final txnsController = Get.put(CTxnsController());

  @override
  void onInit() {
    // TODO: implement onInit
    calculateWeeklySales();
    super.onInit();
  }

  /// -- calculate weekly sales --
  void calculateWeeklySales() {
    // reset weeklySales values to zero
    weeklySales.value = List<double>.filled(7, 0.0);

    txnsController.fetchTransactions().then((_) {
      for (var sale in txnsController.transactions) {
        final DateTime salesWeekStart =
            CHelperFunctions.getStartOfWeek(DateTime.parse(sale.date));
        //final salesWeekStart = CHelperFunctions.getStartOfWeek(sale.date.to);


        HII MAMBO YA DATE
        // check if sale date is within the current week
        if (salesWeekStart.isBefore(DateTime.now()) &&
            salesWeekStart
                .add(const Duration(days: 7))
                .isAfter(DateTime.now())) {
          int index = (DateTime.parse(sale.date).weekday - 1) % 7;

          // ensure the index is non-negative
          index = index < 0 ? index + 7 : index;
          weeklySales[index] += (sale.unitSellingPrice * sale.quantity);

          if (kDebugMode) {
            print(
                'date: ${sale.date}, current week day: $salesWeekStart, index: $index');
          }
        }
      }

      if (kDebugMode) {
        print('weekly sales: $weeklySales');
      }
    });
  }
}
