import 'package:c_ri/api/sheets/creds/gsheets_creds.dart';
import 'package:c_ri/features/store/models/gsheet_models/inv_sheet_fields.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';
CHECK OUT THE GOOGLE APPS SCRIPT APPROACH -- FROM A PUBLISHED SHEET
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

      final invSheetHeaders = InvSheetFields.getInvSheetHeaders();
      invSheet!.values.insertRow(1, invSheetHeaders);

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
    if (invSheet == null) return;
    sheetName.values.map.appendRows(rowItems);
  }

  /// -- fetch inventory item by its id from google sheets --
  static Future<CInventoryModel?> fetchInvItemById(int id) async {
    if (invSheet == null) return null;

    final invMap = await invSheet!.values.map.rowByKey(id, fromColumn: 1);

    return CInventoryModel.gSheetFromJson(invMap!);
  }

  /// -- fetch inventory item by user's email address from google sheets --
  static Future<CInventoryModel?> fetchInvItemEmail(String email) async {
    if (invSheet == null) return null;

    final invMap = await invSheet!.values.map.rowByKey(email, fromColumn: 3);

    return CInventoryModel.gSheetFromJson(invMap!);
  }

  /// -- fetch all inventory items from google sheets --
  static Future<List<CInventoryModel?>?> fetchAllGsheetInvItems() async {
    if (invSheet == null) return null;

    final invList = await invSheet!.values.map.allRows();

    if (kDebugMode) {
      print(invList == null
          ? <CInventoryModel>[]
          : invList.map(CInventoryModel.gSheetFromJson).toList());
    }

    return invList == null
        ? <CInventoryModel>[]
        : invList.map(CInventoryModel.gSheetFromJson).toList();
  }

  /// -- update data in google sheets --
  static Future<bool> updateInvData(
      int id, Map<String, dynamic> itemModel) async {
    try {
      return invSheet!.values.map.insertRowByKey(id, itemModel);
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error updating sheet data',
        message: e.toString(),
      );
      throw e.toString();
    }
  }
}
