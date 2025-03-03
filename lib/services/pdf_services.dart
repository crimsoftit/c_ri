import 'dart:io';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/models/cart_item_model.dart';
import 'package:c_ri/features/store/models/receipt_headers.dart';
import 'package:c_ri/utils/computations/price_calculator.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widget;

class CPdfServices extends GetxController {
  CPdfServices.init();

  static CPdfServices instance = CPdfServices.init();

  //static CPdfServices get instance => Get.find();

  /// -- variables --
  final cartController = Get.put(CCartController());

  final userController = Get.put(CUserController());

  Future<Uint8List> createHelloWorld() {
    final pdfDoc = pdf_widget.Document();

    pdfDoc.addPage(
      pdf_widget.Page(
        build: (pdf_widget.Context context) {
          return pdf_widget.Center(
            child: pdf_widget.Text(
              'Hello world',
            ),
          );
        },
      ),
    );

    return pdfDoc.save();
  }

  Future<Uint8List> generateReceipt(List<CCartItemModel> itemsInCart) async {
    final receipt = pdf_widget.Document();
    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);
    final List<CReceiptHeaders> elements = [
      CReceiptHeaders(
        'item name',
        'item price',
        'qty',
        'total',
        'vat',
      ),
      for (var receiptItem in itemsInCart)
        CReceiptHeaders(
          receiptItem.pName,
          receiptItem.price.toStringAsFixed(2),
          receiptItem.quantity.toString(),
          (receiptItem.quantity * receiptItem.price).toStringAsFixed(2),
          (receiptItem.price * .19).toStringAsFixed(2),
        ),
      CReceiptHeaders(
        'sub total',
        '',
        '',
        '',
        '${(double.parse(CPriceCalculator.instance.computeCartItemsSubTotal(itemsInCart)))}',
      ),
      CReceiptHeaders(
        'VAT total',
        '',
        '',
        '',
        '$currencySymbol.${(double.parse(CPriceCalculator.instance.computeVatTotals(itemsInCart)))}',
      ),
      CReceiptHeaders(
        'total amount',
        '',
        '',
        '',
        '$currencySymbol.${(double.parse(CPriceCalculator.instance.computeVatTotals(itemsInCart))) * (double.parse(CPriceCalculator.instance.computeCartItemsSubTotal(itemsInCart)))}',
      ),
    ];

    final receiptLogo =
        (await rootBundle.load(CImages.darkAppLogo)).buffer.asUint8List();

    receipt.addPage(
      pdf_widget.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pdf_widget.Context context) {
          return pdf_widget.Column(
            children: [
              pdf_widget.Image(
                pdf_widget.MemoryImage(receiptLogo),
                width: 50.0,
                height: 50.0,
                fit: pdf_widget.BoxFit.cover,
              ),
              pdf_widget.Row(
                mainAxisAlignment: pdf_widget.MainAxisAlignment.spaceBetween,
                children: [
                  pdf_widget.Column(
                    children: [
                      pdf_widget.Text(
                        'customer name',
                      ),
                      pdf_widget.Text(
                        'customer address',
                      ),
                      pdf_widget.Text(
                        'customer city',
                      ),
                    ],
                  ),
                  pdf_widget.Column(
                    children: [
                      pdf_widget.Text(
                        'Simiyu Sindani',
                      ),
                      pdf_widget.Text(
                        'Kisumu Dala',
                      ),
                      pdf_widget.Text(
                        'customer city',
                      ),
                      pdf_widget.Text(
                        'VAT-id: 4219384',
                      ),
                      pdf_widget.Text(
                        'txn id: 01234',
                      ),
                    ],
                  ),
                ],
              ),
              pdf_widget.Divider(),
              pdf_widget.Text(elements.first.itemName),
              pdf_widget.Text((double.parse(
                      CPriceCalculator.instance.computeVatTotals(itemsInCart))
                  .toStringAsFixed(2))),
            ],
          );
        },
      ),
    );

    return receipt.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final receiptOutput = await getTemporaryDirectory();
    var filePath = '${receiptOutput.path}/$fileName.pdf';
    final pdfFile = File(filePath);

    await pdfFile.writeAsBytes(byteList);

    await OpenFile.open(filePath);
  }
}
