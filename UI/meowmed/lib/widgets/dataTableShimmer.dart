import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:shimmer/shimmer.dart';

class DataTableSchimmer extends StatelessWidget {
  DataTableSchimmer(
      {required this.columns,
      required this.itemsToSchimmer,
      required this.width,
      required this.height});

  List<String> columns;
  int itemsToSchimmer;
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: DataTable(
            columns: columns
                .map((e) => DataColumn(
                      label: Text(e),
                    ))
                .toList(),
            rows: List.generate(
              itemsToSchimmer,
              (index) => DataRow(
                  cells: columns
                      .map((e) => DataCell(Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: textSize("Das ist ein test", TextStyle())
                                  .width,
                              height: textSize("Das ist ein test", TextStyle())
                                  .height,
                              color: Colors.white,
                            ),
                          )))
                      .toList()),
            )));
  }
}

