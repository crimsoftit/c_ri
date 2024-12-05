import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GsheetsInvScreen extends StatelessWidget {
  const GsheetsInvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () {
                return Table(
                  border: TableBorder.all(
                    width: 1,
                    color: CColors.rBrown,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
