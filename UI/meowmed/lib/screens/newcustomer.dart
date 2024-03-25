import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/widgets/header.dart';

class NewCustomer extends StatefulWidget {
  const NewCustomer({super.key});

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Header(
                  "Neuen Kunden Anlegen",
                  [],
                ),
                Expanded(child: Container()),
                Container(
                  width: 350,
                  height: 50,
                  child: Image(
                    image:
                        AssetImage('assets/images/MeowcroservicesLogoNew.png'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "ID"),
                    )),
                SizedBox(
                  width: 100,
                ),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Vorname"),
                    )),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Nachname"),
                    )),
                SizedBox(
                  width: 100,
                ),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Titel"),
                    )),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "FamilienStatus"),
                    )),
                SizedBox(
                  width: 100,
                ),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Geburtsdatum"),
                    )),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "SV-Nummer"),
                    )),
                SizedBox(
                  width: 100,
                ),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Steuer-ID"),
                    )),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 430,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Adresse"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 430,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Bankverbindung"),
                        )),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      throw UnimplementedError();
                    },
                    child: Text("Anlegen")),
                SizedBox(
                  width: 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Abbrechen")),
                Expanded(child: Container()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
