import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/refreshTimer.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/screens/newcontract.dart';
import 'package:meowmed/widgets/contractList.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
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
  //Adresse Controllers
  TextEditingController streetController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressIdController = TextEditingController();
  //Bankdetails Controllers
  TextEditingController ibanController = TextEditingController();
  TextEditingController bicController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankIdController = TextEditingController();

  @override
  void dispose() {
    refreshTimer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final obj = customer.getObj();

    vornamecontroller.text = obj.firstName;
    nachnamecontroller.text = obj.lastName;
    familienstatuscontroller.text = obj.familyStatus.toString();
    titelcontroller.text = obj.title.toString();
    geburtsdatumcontroller.text = obj.birthDate.toString();
    svnummercontroller.text = obj.socialSecurityNumber;
    steueridcontroller.text = obj.taxId;
    // adressecontroller.text = obj.address.toString();
    // bankverbindungcontroller.text = obj.bankDetails.toString();
    streetController.text = obj.address.street;
    houseNumberController.text = obj.address.houseNumber;
    zipCodeController.text = obj.address.zipCode.toString();
    cityController.text = obj.address.city;

    ibanController.text = obj.bankDetails.iban;
    bicController.text = obj.bankDetails.bic;
    bankNameController.text = obj.bankDetails.name;

    loadContracts();

    refreshTimer = RefreshTimer(loadContracts);
    refreshTimer.init();
  }

  late RefreshTimer refreshTimer;

  Future<void> loadContracts() async {
    final state = (LoginStateContext.getInstance().state as LoggedInState);
    final repo = state.contractService.repo;
    final cached = repo.getAll();
    final cachedContracts = cached.where((element) {
      final obj = element.getObj();
      return obj.id == obj.id;
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
  final customerFormKey = GlobalKey<FormState>();

  Future<void> save() async {
    final state = (LoginStateContext.getInstance().state as LoggedInState);
    final customerService = state.customerService;
    final customerRes = customer.getObj();
    final address = Address(
        street: streetController.text,
        houseNumber: houseNumberController.text,
        zipCode: int.parse(zipCodeController.text),
        city: cityController.text,
        id: '');
    final bankDetails = BankDetails(
        iban: ibanController.text,
        bic: bicController.text,
        name: bankNameController.text,
        id: '');
    final customerReq = CustomerReq(
        firstName: vornamecontroller.text,
        lastName: nachnamecontroller.text,
        familyStatus: ,
        title: ,
        birthDate: ,
        socialSecurityNumber: svnummercontroller.text,
        taxId: steueridcontroller.text,
        address: address,
        bankDetails: bankDetails,
        email: '',
        jobStatus: );
    await customerService.updateCustomer(customerReq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: customerFormKey,
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                height: 50,
                                width: 300,
                                child: TextFormField(
                                  controller: streetController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Eingabe darf nicht leer sein';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Straße"),
                                )),
                            Container(
                                height: 50,
                                width: 130,
                                child: TextFormField(
                                  controller: houseNumberController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Eingabe darf nicht leer sein';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Hausnummer"),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: 430,
                            child: TextFormField(
                              controller: zipCodeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Zip-Code"),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: 430,
                            child: TextFormField(
                              controller: cityController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Stadt"),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Container(
                            height: 50,
                            width: 430,
                            child: TextFormField(
                              controller: ibanController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "IBAN"),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: 430,
                            child: TextFormField(
                              controller: bicController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "BIC"),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: 430,
                            child: TextFormField(
                              controller: bankNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Name des Kontoinhabenden"),
                            )),
                      ],
                    ),
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
                IconButton(
                    onPressed: () {
                      loadContracts();
                    },
                    icon: Icon(Icons.refresh)),
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
                LoadingButton(
                    label: "Speichern",
                    onPressed: () async {
                      if (customerFormKey.currentState!.validate()) {
                        editMode = false;
                      }
                      await save();
                    }),
                LoadingButton(
                    label: "Löschen",
                    onPressed: () async {
                      final state = (LoginStateContext.getInstance().state
                          as LoggedInState);
                      final customerService = state.customerService;
                      await customerService.deleteCustomer(customer.getId());
                      Navigator.pop(context);
                    }),
                Expanded(child: Container())
              ],
            )
          ],
        ),
      ),
    ));
  }
}
