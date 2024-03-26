import 'package:flutter/material.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/screens/newcontract.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';

class Customer extends StatefulWidget {
  Customer(this.customer, {super.key});
  CachedObj<CustomerRes> customer;
  @override
  State<Customer> createState() => _CustomerState(customer);
}

class _CustomerState extends State<Customer> {
  _CustomerState(this.customer){}
  CachedObj<CustomerRes> customer;
  TextEditingController vornamecontroller = TextEditingController();
  TextEditingController nachnamecontroller = TextEditingController();
  TextEditingController familienstatuscontroller = TextEditingController();
  TextEditingController titelcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    vornamecontroller.text = customer.getObj().firstName;
  }
  bool editMode = false;
  final _FormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _FormKey,
          child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
          children: [
            Row(
              children: [
                Header("Kundendetails", []),
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: !editMode,
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
                          controller: vornamecontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if(value==null){return "Eingabe darf nicht leer sein";}
                            if(value.isEmpty){return "Bitte Name eingeben";}
                          },
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                          readOnly: !editMode,
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
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NewContract()));
                    },
                    child: Text("Neuer Vertrag"))
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
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Zurück")),
                TextButton(onPressed: () {
                  setState(() {
                    editMode = true;
                  });
                }, child: Text("Bearbeiten")),
                TextButton(onPressed: () {}, child: Text("Löschen")),
                TextButton(onPressed: () {if (_FormKey.currentState!.validate()){}}, child: Text("Speichern")),
                Expanded(child: Container())
              ],
            )
          ],
                ),
              ),
        ));
  }
}
