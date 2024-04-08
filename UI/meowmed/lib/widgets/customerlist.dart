import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/screens/customer.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/link.dart';

class CustomerList extends StatefulWidget {
  CustomerList(this.customers, {super.key});

  BehaviorSubject<List<CachedObj<CustomerRes>>> customers;

  @override
  State<CustomerList> createState() => _CustomerListState(this.customers);
}

class _CustomerListState extends State<CustomerList> {
  _CustomerListState(this.customers);

  BehaviorSubject<List<CachedObj<CustomerRes>>> customers;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CachedObj<CustomerRes>>>(
      stream: customers.stream,
      initialData: [],
      builder: (BuildContext context,
          AsyncSnapshot<List<CachedObj<CustomerRes>>> snapshot) {
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
              DataColumn(label: Text("Nachname")),
              DataColumn(label: Text("Vorname")),
              DataColumn(label: Text("Adresse")),
              DataColumn(label: Text("Aktionen"))
            ],
            rows: [
              ...snapshot.data!.map((e) {
                final obj = e.getObj();
                final adr = obj.address;
                return DataRow(cells: [
                  DataCell(Text(obj.id.toString())),
                  DataCell(Text(obj.lastName)),
                  DataCell(Text(obj.firstName)),
                  DataCell(Text(
                      adr.street + " " + adr.houseNumber + ", " + adr.city)),
                  DataCell(Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Customer(e)));
                          },
                          icon: Icon(Icons.edit)),
                      Link(
                        uri: Uri.parse('https://youtu.be/dQw4w9WgXcQ'),
                        target: LinkTarget.self,
                        builder: (context, followLink) => IconButton(
                            onPressed: () {
                              followLink;
                            },
                            icon: Icon(Icons.delete)),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.remove_red_eye))
                    ],
                  ))
                ]);
              }),
            ]);
      },
    );
  }
}
