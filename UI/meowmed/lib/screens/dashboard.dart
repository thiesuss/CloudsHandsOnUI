import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String text = "Neuer Kunde";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Mitarbeiter Dashboard",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
                Container(height: 15, width: 60, color: Colors.red),
              ],
            ),
            Row(
              children: [
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Suche..."))),
                IconButton(
                    onPressed: () {
                      setState(() {
                        text = "Hallo";
                      });
                    },
                    icon: Icon(Icons.search)),
                Expanded(child: Container()),
                TextButton(onPressed: () {}, child: Text(text))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DataTable(
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
                        DataRow(cells: [
                          DataCell(Text("Test")),
                          DataCell(Text("Test")),
                          DataCell(Text("Tes3t")),
                          DataCell(Text("Test")),
                          DataCell(Text("Test"))
                        ])
                      ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
