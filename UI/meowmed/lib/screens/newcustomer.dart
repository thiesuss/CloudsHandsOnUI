import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';

class NewCustomer extends StatefulWidget {
  const NewCustomer({super.key});

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

TextEditingController emailController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController familyStatusController = TextEditingController();
TextEditingController birthDateController = TextEditingController();
DateTime birthDate = DateTime.now();
TextEditingController socialSecurityNumberController = TextEditingController();
TextEditingController taxIdController = TextEditingController();
TextEditingController jobStatusController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController bankDetailsController = TextEditingController();

TextEditingController customerStatusFamilyContoller =
      new TextEditingController();
  TextEditingController customerStatusTitleContoller =
      new TextEditingController();
  CustomerReqFamilyStatusEnum selectedFamilyStatus =
      CustomerReqFamilyStatusEnum.ledig;
  CustomerReqTitleEnum? selectedTitleEnum = null;

// Future<void> save() async {
//   if(!formKey.currentState!.validate()) {
//     return;
//   }
//   final customerReq = CustomerReq(
//     email: emailController.text, 
//     firstName: firstNameController.text, 
//     lastName: lastNameController.text, 
//     familyStatus: selectedFamilyStatus, 
//     birthDate: birthDate, 
//     socialSecurityNumber: socialSecurityNumberController.text, 
//     taxId: taxIdController.text, 
//     jobStatus: jobStatusController.text, 
//     address: addressController.text, 
//     bankDetails: bankDetailsController.text,
//     title: selectedTitleEnum
//     );
// }

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _NewCustomerState extends State<NewCustomer> {
  CustomerService customerService =
      (LoginStateContext.getInstance().state as LoggedInState).customerService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        key: formKey,
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
                          border: OutlineInputBorder(), labelText: "Vorname"),
                    )),
                SizedBox(
                  width: 100,
                ),
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Nachname"),
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
                          border: OutlineInputBorder(), labelText: "Steuer-ID"),
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
                          child: DateTimeFormField(
                            dateFormat: DateFormat('dd.MM.yyyy'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Geburtstag"),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 9300)),
                            lastDate:
                                DateTime.now(),
                            initialPickerDateTime: DateTime.now(),
                            onChanged: (DateTime? value) {
                              birthDate = value!;
                            },
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
