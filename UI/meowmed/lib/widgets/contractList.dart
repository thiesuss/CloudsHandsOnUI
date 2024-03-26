import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
//TODO: ADD
// import 'package:meowmed/screens/contract.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';

class ContractList extends StatefulWidget {
  ContractList(this.contracts, {super.key});

  BehaviorSubject<List<CachedObj<ContractRes>>> contracts;

  @override
  State<ContractList> createState() => _ContractListState(this.contracts);
}

class _ContractListState extends State<ContractList> {
  _ContractListState(this.contracts);

  BehaviorSubject<List<CachedObj<ContractRes>>> contracts;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CachedObj<ContractRes>>>(
      stream: contracts.stream,
      initialData: [],
      builder: (BuildContext context,
          AsyncSnapshot<List<CachedObj<ContractRes>>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Not correctly initialized");
        }

        // if (snapshot.data!.isEmpty) {
        //   return Text("Keine Kunden vorhanden");
        // }

        return DataTable(
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
            border: TableBorder(
                borderRadius: BorderRadius.circular(10),
                top: BorderSide(),
                horizontalInside: BorderSide(),
                verticalInside: BorderSide(),
                bottom: BorderSide(),
                left: BorderSide(),
                right: BorderSide()),
            columns: [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Katze")),
              DataColumn(label: Text("Beginn")),
              DataColumn(label: Text("Ende")),
              DataColumn(label: Text("Deckung")),
              DataColumn(label: Text("Aktionen"))
            ],
            rows: [
              ...snapshot.data!.map((e) {
                final obj = e.getObj();
                final adr = obj.coverage;
                return DataRow(cells: [
                  DataCell(Text(obj.id.toString())),
                  DataCell(Text(obj.catName.toString())),
                  DataCell(Text(obj.startDate.toString())),
                  DataCell(Text(obj.endDate.toString())),
                  DataCell(Text(obj.coverage.toString())),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    ],
                  ))
                ]);
              }),
            ]);
      },
    );
  }
}
