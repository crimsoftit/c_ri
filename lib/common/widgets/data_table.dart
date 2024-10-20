import 'package:flutter/material.dart';

class DataTableExample extends StatelessWidget {
  const DataTableExample({
    super.key,
    required this.header,
    required this.name,
  });
  final String header, name;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              header,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        // DataColumn(
        //   label: Expanded(
        //     child: Text(
        //       'Role',
        //       style: TextStyle(fontStyle: FontStyle.italic),
        //     ),
        //   ),
        // ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(name)),
            //DataCell(Text('Student')),
          ],
        ),
        // DataRow(
        //   cells: <DataCell>[
        //     DataCell(Text('Janine')),
        //     DataCell(Text('43')),
        //     DataCell(Text('Professor')),
        //   ],
        // ),
        // DataRow(
        //   cells: <DataCell>[
        //     DataCell(Text('William')),
        //     DataCell(Text('27')),
        //     DataCell(Text('Associate Professor')),
        //   ],
        // ),
      ],
    );
  }
}
