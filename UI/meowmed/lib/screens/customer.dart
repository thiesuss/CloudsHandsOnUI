import 'package:flutter/material.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
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
                "Kundendetails",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              Container(
                width: 350,
                height: 50,
                child: Image(
                  image: AssetImage('assets/images/MeowcroservicesLogoNew.png'),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: Container()),
              Column(
                children: [
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "1234", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ID",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "Max", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Vorname",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "Mustermann", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Nachname",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "Dr.", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Titel",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "ledig", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Familienstatus",
                        ),
                      )),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "12.03.2004", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Geburtsdatum",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "12 23457 W 031", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "SV-Nummer",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "12341233534647", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Steuer ID",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "50.000€", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Brutto Einkommen",
                        ),
                      )),
                  SizedBox(
                    height: 70,
                  ) //quasi placeholder
                ],
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                children: [
                  Container(
                      height: 50,
                      width: 330,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "Hauptstrasse 7, 01234 Bielefeld, Deutschland", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Adresse",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 330,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "DE12 3456 7890 1234", //hier die Value hin per API
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Bankverbindung",
                        ),
                      )),
                ],
              ),
              Expanded(child: Container())
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Container(
                  height: 50,
                  width: 230,
                  child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Suche..."))),
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              Expanded(child: Container()),
              TextButton(onPressed: () {}, child: Text("Neuer Vertrag"))
            ],
          ),
          SizedBox(
            height: 20,
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
                      DataColumn(label: Text("Katze")),
                      DataColumn(label: Text("Beginn")),
                      DataColumn(label: Text("Ende")),
                      DataColumn(label: Text("Deckung")),
                      DataColumn(label: Text("Aktionen"))
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text("Test")),
                        DataCell(Text("Test")),
                        DataCell(Text("Tes3t")),
                        DataCell(Text("Test")),
                        DataCell(Text("Test")),
                        DataCell(Text("Hier mehrere Aktionen")),
                      ])
                    ]),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: Container()),
              TextButton(onPressed: () {}, child: Text("Zurück")),
              TextButton(onPressed: () {}, child: Text("Bearbeiten")),
              TextButton(onPressed: () {}, child: Text("Löschen")),
              Expanded(child: Container())
              ],
          )
        ],
      ),
    ));
  }
}
