import 'package:flutter/material.dart';
import 'package:meowmed/widgets/header.dart';

class NewContract extends StatefulWidget {
  const NewContract({super.key});

  @override
  State<NewContract> createState() => _NewContractState();
}

class _NewContractState extends State<NewContract> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Header("Neuen Vertrag Anlegen", []),
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
                    color: Colors.grey,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "%%,%%€/Monat",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  width: 70,
                ),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: true,
                          initialValue: "1234", //hier die ID Value hin per API
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
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Beginn"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Ende"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Deckung"),
                        )),
                  ],
                ),
                SizedBox(
                  width: 70,
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {}, child: Text("Vertrag Abschließen")),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Abbrechen")),
                  ],
                ),
                Expanded(child: Container())
              ],
            ),
            Row(
              children: [
                Text(
                  "Katze",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container())
              ],
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Name"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Rasse"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Farbe"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Alter"),
                        )),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Kastriert"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Persönlichkeit"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Umgebung"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Gewicht"),
                        )),
                  ],
                ),
                Expanded(child: Container())
              ],
            )
          ],
        ),
      ),
    );
  }
}
