import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/icon_buttons/search_icon_btn.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      /// -- app bar --
      appBar: CAppBar(
        showBackArrow: true,
        backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
        title: Text(
          'inventory',
          style: Theme.of(context).textTheme.headlineSmall!.apply(
                fontSizeFactor: 0.7,
              ),
        ),
        actions: [
          // -- search button
          CCustomIconBtn(
            iconColor: CColors.white,
            onPressed: () {},
          ),
        ],
      ),

      /// -- body --
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key('omo'),
                    onDismissed: (direction) {
                      String strName = 'omo';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$strName deleted"),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 1.0,
                      child: ListTile(
                        title: Text('omo'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown[300],
                          child: Text('0'),
                          //const Icon(Icons.keyboard_arrow_right),
                        ),
                        subtitle: Text(
                          '14th Feb 2022',
                        ),
                        onTap: () {},
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 153, 113, 98),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
