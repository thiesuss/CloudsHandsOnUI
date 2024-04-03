import 'package:flutter/material.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/screens/newcontract.dart';
import 'package:meowmed/widgets/contractList.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';

class Customer extends StatefulWidget {
  Customer(this.customer, {super.key});
  CachedObj<CustomerRes> customer;
  @override
  State<Customer> createState() => _CustomerState(customer);
}

class _CustomerState extends State<Customer> {
  _CustomerState(this.customer) {}
  CachedObj<CustomerRes> customer;
  TextEditingController vornamecontroller = TextEditingController();
  TextEditingController nachnamecontroller = TextEditingController();
  TextEditingController familienstatuscontroller = TextEditingController();
  TextEditingController titelcontroller = TextEditingController();
  TextEditingController geburtsdatumcontroller = TextEditingController();
  TextEditingController svnummercontroller = TextEditingController();
  TextEditingController steueridcontroller = TextEditingController();
  TextEditingController bruttocontroller = TextEditingController();
  TextEditingController adressecontroller = TextEditingController();
  TextEditingController bankverbindungcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    vornamecontroller.text = customer.getObj().firstName;
    nachnamecontroller.text = customer.getObj().lastName;
    familienstatuscontroller.text = customer.getObj().familyStatus.toString();
    titelcontroller.text = customer.getObj().title.toString();
    geburtsdatumcontroller.text = customer.getObj().birthDate.toString();
    svnummercontroller.text = customer.getObj().socialSecurityNumber;
    steueridcontroller.text = customer.getObj().taxId;
    adressecontroller.text = customer.getObj().address.toString();
    bankverbindungcontroller.text = customer.getObj().bankDetails.toString();

    loadContracts();
  }

  Future<void> loadContracts() async {
    final state = (LoginStateContext.getInstance().state as LoggedInState);
    final repo = state.contractService.repo;
    final cached = repo.getAll();
    final cachedContracts = cached.where((element) {
      final obj = element.getObj();
      return obj.id == customer.getObj().id;
    }).toList();
    contractList = cachedContracts;
    filteredContracts.add(cachedContracts);

    // TODO: teil oben kann weg, sobald api geht

    final contractResList =
        await state.contractService.getContractsForCustomer(customer.getId());
    contractList = contractResList;
    filteredContracts.add(contractResList);
  }

  List<CachedObj<ContractRes>> contractList = [];
  late BehaviorSubject<List<CachedObj<ContractRes>>> filteredContracts =
      BehaviorSubject.seeded([]);

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
                // TODO: Extract Logo
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
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Vorname eingeben";
                            }
                            return null;
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
                          controller: nachnamecontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Nachname eingeben";
                            }
                            return null;
                          },
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
                          controller: titelcontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Titel eingeben";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Titel",
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
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
                          controller: geburtsdatumcontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Geburtsdatum eingeben";
                            }
                            return null;
                          },
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
                          controller: svnummercontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte SV-Nummer eingeben";
                            }
                            return null;
                          },
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
                          controller: steueridcontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Steuer ID eingeben";
                            }
                            return null;
                          },
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
                          controller: familienstatuscontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Familienstatus eingeben";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Familienstatus",
                          ),
                        )),
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
                          controller: adressecontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Nachname eingeben";
                            }
                            return null;
                          },
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
                          controller: bankverbindungcontroller,
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Bankverbindung eingeben";
                            }
                            return null;
                          },
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
                            border: OutlineInputBorder(),
                            hintText: "Suche..."))),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                Expanded(child: Container()),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewContract()));
                    },
                    child: Text("Neuer Vertrag"))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ContractList(filteredContracts),
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
                TextButton(
                    onPressed: () {
                      setState(() {
                        editMode = true;
                      });
                    },
                    child: Text("Bearbeiten")),
                TextButton(
                    onPressed: () {
                      if (_FormKey.currentState!.validate()) {
                        editMode = false;
                      }
                    },
                    child: Text("Speichern")),
                TextButton(onPressed: () {}, child: Text("Löschen")),
                Expanded(child: Container())
              ],
            )
          ],
        ),
      ),
    ));
  }
}
