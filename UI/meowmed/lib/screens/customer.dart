import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/services/refreshTimer.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/screens/contract.dart';
import 'package:meowmed/screens/newcontract.dart';
import 'package:meowmed/widgets/dataTableShimmer.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';

class Customer extends StatefulWidget {
  Customer(this.customer, this.readOnly, this.refreshCustomers, {super.key});
  CachedObj<CustomerRes> customer;
  bool readOnly = false;
  VoidCallback? refreshCustomers;

  @override
  State<Customer> createState() => _CustomerState(customer);
}

class _CustomerState extends State<Customer> {
  CustomerService customerService =
      (LoginStateContext.getInstance().state as LoggedInState).customerService;
  _CustomerState(this.customer) {}
  CachedObj<CustomerRes> customer;
  TextEditingController idController = TextEditingController();
  TextEditingController vornamecontroller = TextEditingController();
  TextEditingController nachnamecontroller = TextEditingController();
  TextEditingController customerStatusFamilyContoller = TextEditingController();
  CustomerResFamilyStatusEnum selectedFamilyStatus =
      CustomerResFamilyStatusEnum.ledig;
  TextEditingController customerStatusTitleContoller = TextEditingController();
  CustomerResTitleEnum? selectedTitleEnum;
  TextEditingController birthDateController = TextEditingController();
  DateTime birthDate = DateTime.now();
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
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    refreshTimer?.dispose();
    super.dispose();
  }

  Future<List<CachedObj<ContractRes>>>? contractFuture;

  @override
  void initState() {
    super.initState();
    final obj = customer.getObj();
    idController.text = obj.id;
    vornamecontroller.text = obj.firstName;
    nachnamecontroller.text = obj.lastName;
    customerStatusFamilyContoller.text = obj.familyStatus.toString();
    selectedFamilyStatus = obj.familyStatus;
    customerStatusTitleContoller.text = obj.title.toString();
    selectedTitleEnum = obj.title;
    birthDate = obj.birthDate;
    birthDateController.text = DateFormat('dd.MM.yyyy').format(obj.birthDate);
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
    emailController.text = obj.email;

    contractFuture = loadContracts();

    refreshTimer = RefreshTimer(() async {
      contractFuture = loadContracts();
    });
    refreshTimer!.init();
  }

  RefreshTimer? refreshTimer;

  final contractService =
      (LoginStateContext.getInstance().state as LoggedInState).contractService;

  Future<List<CachedObj<ContractRes>>> loadContracts() async {
    final contractResList =
        await contractService.getContractsForCustomer(customer.getId());
    contractList = contractResList;
    filteredContracts.add(contractResList);
    return contractResList;
  }

  List<CachedObj<ContractRes>> contractList = [];
  late BehaviorSubject<List<CachedObj<ContractRes>>> filteredContracts =
      BehaviorSubject.seeded([]);

  final customerFormKey = GlobalKey<FormState>();

  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  Future<void> save() async {
    error.add(null);
    final state = (LoginStateContext.getInstance().state as LoggedInState);
    final customerService = state.customerService;
    final customerRes = customer.getObj();
    final address = Address(
        street: streetController.text,
        houseNumber: houseNumberController.text,
        zipCode: int.parse(zipCodeController.text),
        city: cityController.text);
    final bankDetails = BankDetails(
        iban: ibanController.text,
        bic: bicController.text,
        name: bankNameController.text);
    final customerReq = CustomerReq(
        firstName: vornamecontroller.text,
        lastName: nachnamecontroller.text,
        familyStatus:
            CustomerService.familyStatusResToReq(selectedFamilyStatus),
        title: CustomerService.titleResToReq(selectedTitleEnum),
        birthDate: birthDate, //replace
        socialSecurityNumber: svnummercontroller.text,
        taxId: steueridcontroller.text,
        address: address,
        bankDetails: bankDetails,
        email: emailController.text); //Job nicht nötig
    final id = customer.getId();
    try {
      await customerService.updateCustomer(id, customerReq);
    } catch (e) {
      error.add(e.toString());
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(key: customerFormKey, children: [
      Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Header("Kundendetails", []),
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
                          controller: idController,
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
                          readOnly: widget.readOnly,
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
                          readOnly: widget.readOnly,
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
                      //dropdown menu für enum
                      height: 50,
                      width: 230,
                      child: DropdownMenu<CustomerResTitleEnum?>(
                        initialSelection: selectedTitleEnum,
                        controller: customerStatusTitleContoller,
                        enabled: !widget.readOnly,
                        requestFocusOnTap: true,
                        label: const Text('Titel'),
                        onSelected: (CustomerResTitleEnum? titleStatus) {
                          setState(() {
                            selectedTitleEnum = titleStatus;
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: null, label: ""),
                          ...CustomerResTitleEnum.values
                              .map<DropdownMenuEntry<CustomerResTitleEnum>>(
                                  (CustomerResTitleEnum titleStatus) {
                            return DropdownMenuEntry<CustomerResTitleEnum>(
                              value: titleStatus,
                              label: CustomerService.titleEnumToString(
                                  CustomerService.titleResToReq(titleStatus)),
                            );
                          })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        controller: emailController,
                        readOnly: widget.readOnly,
                        validator: (value) {
                          if (value == null) {
                            return "Eingabe darf nicht leer sein";
                          }
                          if (value.isEmpty) {
                            return "Bitte Email eingeben";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                      ),
                    )
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
                        readOnly: widget.readOnly,
                        controller: birthDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Geburtstag",
                        ),
                        onTap: () async {
                          if (!widget.readOnly) {
                            final date = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 40000)),
                                lastDate: DateTime.now());
                            if (date != null) {
                              setState(() {
                                birthDate = date;
                                birthDateController.text =
                                    DateFormat('dd.MM.yyyy').format(date);
                              });
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 70,
                        width: 230,
                        child: TextFormField(
                          controller: svnummercontroller,
                          readOnly: widget.readOnly,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte SV-Nummer eingeben";
                            }
                            if (value.length != 12) {
                              return "SV-Nummer muss 12 Zeichen lang sein";
                            }
                            return null;
                          },
                          maxLength: 12,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "bsp: 12345678A123",
                            labelText: "SV-Nummer",
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 70,
                        width: 230,
                        child: TextFormField(
                          controller: steueridcontroller,
                          readOnly: widget.readOnly,
                          maxLength: 11,
                          validator: (value) {
                            if (value == null) {
                              return "Eingabe darf nicht leer sein";
                            }
                            if (value.isEmpty) {
                              return "Bitte Steuer ID eingeben";
                            }
                            if (value.length != 11) {
                              return "Steuer ID muss 11 Zeichen lang sein";
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
                      //dropdown menu für enum
                      height: 50,
                      width: 230,
                      child: DropdownMenu<CustomerResFamilyStatusEnum>(
                        initialSelection: selectedFamilyStatus,
                        controller: customerStatusFamilyContoller,
                        requestFocusOnTap: true,
                        enabled: !widget.readOnly,
                        label: const Text('Familienstatus'),
                        onSelected:
                            (CustomerResFamilyStatusEnum? familyStatus) {
                          setState(() {
                            if (familyStatus == null) return;
                            selectedFamilyStatus = familyStatus;
                          });
                        },
                        dropdownMenuEntries: CustomerResFamilyStatusEnum.values
                            .map<
                                    DropdownMenuEntry<
                                        CustomerResFamilyStatusEnum>>(
                                (CustomerResFamilyStatusEnum familyStatus) {
                          return DropdownMenuEntry<CustomerResFamilyStatusEnum>(
                            value: familyStatus,
                            label: CustomerService.familienStatustoString(
                                CustomerService.familyStatusResToReq(
                                    familyStatus)), // familienstatusenum.ledig
                          );
                        }).toList(),
                      ),
                    ),
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
                                  readOnly: widget.readOnly,
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
                                  readOnly: widget.readOnly,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Eingabe darf nicht leer sein';
                                    }
                                    return null;
                                  },
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
                            height: 70,
                            width: 430,
                            child: TextFormField(
                              controller: zipCodeController,
                              readOnly: widget.readOnly,
                              maxLength: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                if (value.length != 5) {
                                  return "Zip-Code muss 5 Zeichen lang sein";
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "bsp: 12345",
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
                              readOnly: widget.readOnly,
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
                              readOnly: widget.readOnly,
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
                            height: 70,
                            width: 430,
                            child: TextFormField(
                              controller: bicController,
                              readOnly: widget.readOnly,
                              maxLength: 11,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                if (value.length != 11 && value.length != 8) {
                                  return 'BIC muss 8 oder 11 Zeichen lang sein';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "bsp: ABCDEF12ABC",
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
                              readOnly: widget.readOnly,
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
                IconButton(
                    onPressed: () {
                      contractFuture = loadContracts();
                    },
                    icon: Icon(Icons.refresh)),
                Expanded(child: Container()),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewContract(customer, loadContracts)));
                    },
                    child: Text("Neuer Vertrag"))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<List<CachedObj<ContractRes>>>(
              stream: filteredContracts.stream,
              initialData: [],
              builder: (BuildContext context,
                  AsyncSnapshot<List<CachedObj<ContractRes>>> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Not correctly initialized");
                }
                return FutureBuilder<List<CachedObj<ContractRes>>>(
                  future: contractFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CachedObj<ContractRes>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return DataTableSchimmer(
                          columns: [
                            "ID",
                            "Katze",
                            "Beginn",
                            "Ende",
                            "Deckung",
                            "Aktionen"
                          ],
                          itemsToSchimmer: 1,
                          width: double.infinity,
                          height: 100);
                    }
                    if (snapshot.hasError) {
                      return buildErrorTile(
                          "Error loading contracts", snapshot.error.toString());
                    }

                      return SizedBox(
                        width: double.infinity,
                        child: DataTable(
                            headingTextStyle: dataTableHeading,
                            border: dataTableBorder,
                            columns: [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Katze")),
                              DataColumn(label: Text("Beginn")),
                              DataColumn(label: Text("Ende")),
                              DataColumn(label: Text("Deckung")),
                              DataColumn(label: Text("Rate")),
                              DataColumn(label: Text("Aktionen"))
                            ],
                            rows: [
                              ...snapshot.data!.map((e) {
                                final obj = e.getObj();
                                return DataRow(cells: [
                                  DataCell(Text(obj.id.toString())),
                                  DataCell(Text(obj.catName.toString())),
                                  DataCell(
                                      Text(dateTimeToString(obj.startDate))),
                                  DataCell(Text(dateTimeToString(obj.endDate))),
                                  DataCell(Text(obj.coverage.toString() + "€")),
                                  DataCell(Text(obj.rate.toString() + "€")),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_red_eye),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Contract(
                                                          e, loadContracts)));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.not_interested),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ))
                                ]);
                              }),
                            ]),
                      );
                    },
                  );
                  // if (snapshot.data!.isEmpty) {
                  //   return Text("Keine Kunden vorhanden");
                  // }
                },
              ),
            ),
            StreamBuilder<String?>(
              stream: error,
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child:
                      buildErrorTile("Fehler beim speichern: ", snapshot.data!),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      widget.refreshCustomers!();
                    },
                    child: Text("Zurück")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        widget.readOnly = !widget.readOnly;
                      });
                    },
                    child: Text(
                        widget.readOnly ? "Bearbeiten" : "Bearbeiten beenden")),
                LoadingButton(
                    label: "Speichern",
                    onPressed: () async {
                      if (!customerFormKey.currentState!.validate()) {
                        return;
                      }
                      widget.readOnly = true;
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
                      widget.refreshCustomers!();
                    }),
                Expanded(child: Container())
              ],
            ),
          ],
        ),
      ),
    ]));
  }
}
