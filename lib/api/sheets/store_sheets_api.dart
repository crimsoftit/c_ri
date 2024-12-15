import 'package:c_ri/api/sheets/creds/gsheets_creds.dart';
import 'package:c_ri/features/store/models/gsheet_models/inv_sheet_fields.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';

//CHECK OUT THE GOOGLE APPS SCRIPT APPROACH -- FROM A PUBLISHED SHEET
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

  /// -- update data (entire row) in google sheets --
  static Future<bool> updateInvData(
      int id, Map<String, dynamic> itemModel) async {
    try {
      if (invSheet == null) return false;
      return invSheet!.values.map.insertRowByKey(id, itemModel);
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error updating sheet data',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  /// -- update data (a single cell) in google sheets --
  static Future<bool> updateCell({
    required int id,
    required String key,
    required dynamic value,
  }) async {
    try {
      if (invSheet == null) return false;
      return invSheet!.values.insertValueByKeys(
        value,
        columnKey: key,
        rowKey: id,
      );
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error updating cell data in google sheet',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  /// -- delete data in google sheets by its id --
  static Future<bool> deleteById(int id, String sheetName) async {
    try {
      // ignore: prefer_typing_uninitialized_variables
      var returnCmd;
      if (sheetName == 'inventory') {
        if (invSheet == null) return false;

        final invItemIndex =
            await invSheet!.values.rowIndexOf(id.toString().toLowerCase());

        if (invItemIndex.isNegative) {
          returnCmd = false;
          return false;
        } else {
          returnCmd = invSheet!.deleteRow(invItemIndex);
        }
      } else if (sheetName == 'txns') {
        if (txnsSheet == null) return false;

        final txnItemIndex = await txnsSheet!.values.rowIndexOf(id);

        returnCmd = txnsSheet!.deleteRow(txnItemIndex);
      }

      return returnCmd;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error deleting data in google sheet',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  // static Future<bool> deleteInvItemById(int id) async {
  //   if (invSheet == null) return false;

  //   final ss = await gsheets.spreadsheet(spreadsheetId);

  //   final sheet = await getWorkSheet(
  //     ss,
  //     title: 'InventorySheet',
  //   );

  //   final range = await sheet!.values.getRange
  // }
}
