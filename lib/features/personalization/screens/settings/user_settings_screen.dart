import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CUserSettingsScreen extends StatelessWidget {
  const CUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Container()],
        ),
      ),
    );
  }
}
