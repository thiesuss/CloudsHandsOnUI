import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
import 'package:openapi/api.dart';

class NewCustomer extends StatefulWidget {
  const NewCustomer({super.key});

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  CustomerService customerService =
      (LoginStateContext.getInstance().state as LoggedInState).customerService;

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController familyStatusController = TextEditingController();
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

  TextEditingController customerStatusFamilyContoller = TextEditingController();
  TextEditingController customerStatusTitleContoller = TextEditingController();
  CustomerReqFamilyStatusEnum selectedFamilyStatus =
      CustomerReqFamilyStatusEnum.ledig;
  CustomerReqTitleEnum? selectedTitleEnum;

  Future<void> save() async {
    if (!newCustomerFormKey.currentState!.validate()) {
      return;
    }
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
        familyStatus: selectedFamilyStatus,
        birthDate: birthDate,
        socialSecurityNumber: socialSecurityNumberController.text,
        taxId: taxIdController.text,
        address: address,
        bankDetails: bankDetails,
        title: selectedTitleEnum);

    final customer = await customerService.createCustomer(customerReq);
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
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        controller: taxIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Steuer-ID"),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    //dropdown menu für enum
                    height: 50,
                    width: 230,
                    child: DropdownMenu<CustomerReqTitleEnum?>(
                      initialSelection: selectedTitleEnum,
                      controller: customerStatusTitleContoller,
                      requestFocusOnTap: true,
                      label: const Text('Titel'),
                      onSelected: (CustomerReqTitleEnum? titleStatus) {
                        setState(() {
                          selectedTitleEnum = titleStatus;
                        });
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: null, label: ""),
                        ...CustomerReqTitleEnum.values
                            .map<DropdownMenuEntry<CustomerReqTitleEnum>>(
                                (CustomerReqTitleEnum titleStatus) {
                          return DropdownMenuEntry<CustomerReqTitleEnum>(
                            value: titleStatus,
                            label: CustomerService.titleEnumToString(
                                titleStatus), // familienstatusenum.ledig
                          );
                        })
                      ],
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
                  Container(
                    //dropdown menu für enum
                    height: 50,
                    width: 230,
                    child: DropdownMenu<CustomerReqFamilyStatusEnum>(
                      initialSelection: selectedFamilyStatus,
                      controller: customerStatusFamilyContoller,
                      requestFocusOnTap: true,
                      label: const Text('Familienstatus'),
                      onSelected: (CustomerReqFamilyStatusEnum? familyStatus) {
                        setState(() {
                          if (familyStatus == null) return;
                          selectedFamilyStatus = familyStatus;
                        });
                      },
                      dropdownMenuEntries: CustomerReqFamilyStatusEnum.values
                          .map<DropdownMenuEntry<CustomerReqFamilyStatusEnum>>(
                              (CustomerReqFamilyStatusEnum familyStatus) {
                        return DropdownMenuEntry<CustomerReqFamilyStatusEnum>(
                          value: familyStatus,
                          label: CustomerService.familienStatustoString(
                              familyStatus), // familienstatusenum.ledig
                        );
                      }).toList(),
                    ),
                  ),
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
                  Container(
                      height: 50,
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
                                border: OutlineInputBorder(), labelText: "BIC"),
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
              Row(
                children: [
                  Expanded(child: Container()),
                  LoadingButton(
                      label: "Anlegen",
                      onPressed: () async {
                        await save();
                        Navigator.pop(context);
                      }),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
