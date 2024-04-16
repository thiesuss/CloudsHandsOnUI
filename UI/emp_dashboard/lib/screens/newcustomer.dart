import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internalapi/api.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
import 'package:rxdart/rxdart.dart';
import 'package:internalapi/api.dart' as api;

class NewCustomer extends StatefulWidget {
  NewCustomer(this.reloadCustomers, {super.key});
  VoidCallback? reloadCustomers;
  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  CustomerService customerService =
      (LoginStateContext.getInstance().state as LoggedInState).customerService;

  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  DateTime birthDate = DateTime.now();
  TextEditingController socialSecurityNumberController =
      TextEditingController();
  TextEditingController taxIdController = TextEditingController();
  TextEditingController jobStatusController = TextEditingController();
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

  TextEditingController customerStatusTitleContoller = TextEditingController();

  api.Title? selectedTitle;

  Future<void> save() async {
    error.add(null);
    final address = Address(
      street: streetController.text,
      houseNumber: houseNumberController.text,
      zipCode: int.parse(zipCodeController.text),
      city: cityController.text,
    );
    final bankDetails = BankDetails(
      iban: ibanController.text,
      bic: bicController.text,
      name: bankNameController.text,
    );
    final customerReq = CustomerReq(
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        birthDate: birthDate,
        socialSecurityNumber: socialSecurityNumberController.text,
        taxId: taxIdController.text,
        address: address,
        bankDetails: bankDetails,
        title: selectedTitle);
    try {
      final customer = await customerService.createCustomer(customerReq);
    } catch (e) {
      error.add(e.toString());
      throw e;
    }
  }

  GlobalKey<FormState> newCustomerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: newCustomerFormKey,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Header(
                "Neuen Kunden Anlegen",
                [],
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        controller: firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Vorname"),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        controller: lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Nachname"),
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
                      height: 70,
                      width: 230,
                      child: TextFormField(
                        controller: taxIdController,
                        maxLength: 11,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          if (value.length != 11) {
                            return "Steuer-ID muss 11 Zeichen lang sein";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Steuer-ID"),
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
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    height: 50,
                    width: 230,
                    child: TextFormField(
                      controller: birthDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Geburtstag",
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 40000)),
                            lastDate: DateTime.now());
                        if (date != null) {
                          setState(() {
                            birthDate = date;
                            birthDateController.text =
                                DateFormat('dd.MM.yyyy').format(date);
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //dropdown menu für enum
                    height: 50,
                    width: 230,
                    child: DropdownMenu<api.Title?>(
                      initialSelection: selectedTitle,
                      controller: customerStatusTitleContoller,
                      requestFocusOnTap: true,
                      label: const Text('Titel'),
                      onSelected: (api.Title? titleStatus) {
                        setState(() {
                          selectedTitle = titleStatus;
                        });
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: null, label: ""),
                        ...api.Title.values.map<DropdownMenuEntry<api.Title>>(
                            (api.Title titleStatus) {
                          return DropdownMenuEntry<api.Title>(
                            value: titleStatus,
                            label: titleStatus.toString(),
                          );
                        })
                      ],
                    ),
                  ),
                  Container(
                      height: 70,
                      width: 230,
                      child: TextFormField(
                        controller: socialSecurityNumberController,
                        maxLength: 12,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          if (value.length != 12) {
                            return "SV-Nummer muss 11 Zeichen lang sein";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "bsp: 12345678A123",
                            labelText: "SV-Nummer"),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
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
                    width: 30,
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
                          height: 70,
                          width: 430,
                          child: TextFormField(
                            controller: bicController,
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
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(child: Container()),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<String?>(
                stream: error,
                initialData: null,
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: buildErrorTile(
                        "Fehler beim speichern: ", snapshot.data!),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  LoadingButton(
                      label: "Anlegen",
                      onPressed: () async {
                        if (!newCustomerFormKey.currentState!.validate()) {
                          return;
                        }
                        await save();
                        Navigator.pop(context);
                        widget.reloadCustomers!();
                      }),
                  SizedBox(
                    width: 30,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.reloadCustomers!();
                      },
                      child: Text("Abbrechen")),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
