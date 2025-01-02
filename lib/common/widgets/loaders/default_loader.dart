import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class DefaultLoaderScreen extends StatelessWidget {
  const DefaultLoaderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CColors.rBrown,
      body: Center(
        child: CircularProgressIndicator(
          color: CColors.white,
        ),
      ),
    );
  }
}
