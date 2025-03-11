import 'package:c_ri/api/sheets/creds/gsheets_creds.dart';
import 'package:c_ri/features/store/models/gsheet_models/inv_sheet_fields.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/txns_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';

//CHECK OUT THE GOOGLE APPS SCRIPT APPROACH -- FROM A PUBLISHED SHEET
class StoreSheetsApi {
  static const gsheetCredentials = GsheetsCreds.credentials;
  static const spreadsheetId = '1iUtgSjdyP3Q3cpdyhOftTAZI8_Bujv69QZpg06oMK_E';

  static final gsheets = GSheets(gsheetCredentials);

  static Worksheet? invSheet, txnsSheet;

  static Future initSpreadSheets() async {
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

      final txnsHeaders = CTxnsModel.getHeaders();
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

  static Future saveInvItemsToGSheets(
      List<Map<String, dynamic>> rowItems) async {
    if (invSheet == null) return;
    invSheet!.values.map.appendRows(rowItems);
  }

  /// -- fetch inventory item by its id from google sheets --
  static Future<CInventoryModel?> fetchInvItemById(int id) async {
    if (invSheet == null) return null;

    final invMap = await invSheet!.values.map.rowByKey(id, fromColumn: 1);

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

  /// -- fetch user's gsheet inventory data --
  // static Future<List<CInventoryModel?>?> fetchUserGsheetInvData(String userEmail) async {
  //   try {
  //     if (invSheet == null) return null;

  //     final userInvMap =
  //         await invSheet!.values.map.rowByKey(userEmail, fromColumn: 3);

  //     return userInvMap == null
  //       ? <CInventoryModel>[]
  //       : userInvMap.map(CInventoryModel.gSheetFromJson).toList()\;
  //   } catch (e) {
  //     CPopupSnackBar.errorSnackBar(
  //       title: 'error syncing inventory'.toUpperCase(),
  //       message: 'an error occurred while uploading inventory to cloud',
  //     );
  //     if (kDebugMode) {
  //       print(e.toString());
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'error syncing inventory'.toUpperCase(),
  //         message: '$e',
  //       );
  //     }
  //     throw 'ERROR SYNCING INVENTORY: $e';
  //   }
  // }

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
  static Future<bool> updateInvStockCount({
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

  /// -- update data (a single cell) in google sheets --
  static Future<bool> updateInvItemsSalesCount({
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
  static Future<bool> deleteById(int id) async {
    try {
      //initializeSpreadSheets();
      // ignore: prefer_typing_uninitialized_variables
      var returnCmd;

      if (invSheet == null) return false;

      final invItemIndex =
          await invSheet!.values.rowIndexOf(id.toString().toLowerCase());

      if (invItemIndex.isNegative) {
        returnCmd = false;
        return false;
      } else {
        returnCmd = invSheet!.deleteRow(invItemIndex);
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

  /// -- ## TRANSACTIONS - OPERATIONS ## --

  static Future<bool> saveTxnsToGSheets(
      List<Map<String, dynamic>> rowItems) async {
    try {
      if (txnsSheet == null) return false;
      txnsSheet!.values.map.appendRows(rowItems);
      return true;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error syncing txns'.toUpperCase(),
        message: 'an error occurred while uploading txns to cloud',
      );
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error syncing txns'.toUpperCase(),
          message: '$e',
        );
      }
      throw 'ERROR SYNCING TXNS: $e';
    }
  }

  static Future<List<CTxnsModel>?> fetchAllTxnsFromCloud() async {
    if (txnsSheet == null) return null;

    final txnsList = await txnsSheet!.values.map.allRows();

    if (kDebugMode) {
      print(txnsList == null
          ? <CTxnsModel>[]
          : txnsList.map(CTxnsModel.gSheetFromJson).toList());
    }

    return txnsList == null
        ? <CTxnsModel>[]
        : txnsList.map(CTxnsModel.gSheetFromJson).toList();
  }
}
