import 'package:c_ri/api/sheets/creds/gsheets_creds.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';

class StoreSheetsApi {
  static const gsheetCredentials = GsheetsCreds.credentials;
  static const spreadsheetId = '1iUtgSjdyP3Q3cpdyhOftTAZI8_Bujv69QZpg06oMK_E';

  static final gsheets = GSheets(gsheetCredentials);
  static Worksheet? invSheet, txnsSheet;

  static Future init() async {
    try {
      final spreadsheet = await gsheets.spreadsheet(spreadsheetId);

      invSheet = await getWorkSheet(
        spreadsheet,
        title: 'InventorySheet',
      );

      txnsSheet = await getWorkSheet(
        spreadsheet,
        title: "TxnsSheet",
      );

      final invHeaders = CInventoryModel.getHeaders();
      invSheet!.values.insertRow(1, invHeaders);
      CPopupSnackBar.successSnackBar(
        title: 'rada safi',
        message: 'INVENTORY SHEET HEADERS SET!!',
      );

      final txnsHeaders = CSoldItemsModel.getHeaders();
      if (txnsSheet != null) {
        txnsSheet!.values.insertRow(
          1,
          txnsHeaders,
        );
      }
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error initializing gsheets!!',
        message: '$e',
      );
      if (kDebugMode) {
        print('gsheet api init error: $e');
      }
    }
  }

  static Future<Worksheet?> getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future saveToGSheets(
      List<Map<String, dynamic>> rowItems, Worksheet sheetName) async {
    sheetName.values.map.appendRows(rowItems);
  }
}
