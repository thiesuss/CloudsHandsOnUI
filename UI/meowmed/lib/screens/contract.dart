import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
import 'package:openapi/api.dart';

class Contract extends StatefulWidget {
  Contract(this.contract, {super.key});
  CachedObj<ContractRes> contract;
  @override
  State<Contract> createState() => _ContractState(contract);
}

class _ContractState extends State<Contract> {
  ContractService contractService =
      (LoginStateContext.getInstance().state as LoggedInState).contractService;
  _ContractState(this.contract) {}
  CachedObj<ContractRes> contract;

  TextEditingController startDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  TextEditingController endDateController = TextEditingController();
  DateTime endDate = DateTime.now();
  TextEditingController coverageController = TextEditingController();
  TextEditingController catNameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  DateTime birthDate = DateTime.now();
  bool isNeutered = false;
  TextEditingController personalityController = TextEditingController();
  TextEditingController environmentController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();

  bool readOnlyMode = true; //

  @override
  void initState() {
    super.initState();
    final obj = contract.getObj();
    startDate = obj.startDate;
    endDate = obj.endDate;
    coverageController.text = obj.coverage.toString();
    catNameController.text = obj.catName;
    breedController.text = obj.breed;
    colorController.text = obj.color;
    birthDate = obj.birthDate;
    isNeutered = obj.neutered;
    personalityController.text = obj.personality;
    environmentController.text = obj.environment;
    weightController.text = obj.weight.toString();
    customerIdController.text = obj.customerId.toString();
    birthDateController.text = DateFormat('dd.MM.yyyy').format(birthDate);
    startDateController.text = DateFormat('dd.MM.yyyy').format(startDate);
    endDateController.text = DateFormat('dd.MM.yyyy').format(endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      //hier noch key in zukunft
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Header("Vertrag: " + contract.getObj().catName, []),
            Row(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          controller: startDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Beginn",
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Bitte Startdatum angeben";
                            }
                            return null;
                          },
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 36500)),
                            );
                            if (date != null) {
                              setState(() {
                                startDate = date;
                                startDateController.text =
                                    DateFormat('dd.MM.yyyy').format(date);
                              });
                            }
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          controller: endDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Ende",
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Bitte Enddatum angeben";
                            }
                            return null;
                          },
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 36500)),
                            );
                            if (date != null) {
                              setState(() {
                                endDate = date;
                                endDateController.text =
                                    DateFormat('dd.MM.yyyy').format(date);
                              });
                            }
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            try {
                              int.parse(value);
                            } catch (e) {
                              return 'Ungültige Eingabe';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: coverageController,
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Zurück")),
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
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            return null;
                          },
                          controller: catNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Name"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            //check ob Rasse hier?
                            return null;
                          },
                          controller: breedController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Rasse"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            //check auf Farbe?
                            return null;
                          },
                          controller: colorController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Farbe"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 230,
                      child: TextFormField(
                        readOnly: readOnlyMode,
                        controller: birthDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Geburtstag",
                        ),
                        onTap: () async {
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
                        },
                      ),
                    ),
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
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            return null;
                          },
                          controller: personalityController,
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
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            return null;
                          },
                          controller: environmentController,
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
                        child: TextFormField(
                          readOnly: readOnlyMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: weightController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Gewicht"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Kastriert',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Checkbox(
                            value: isNeutered,
                            onChanged: (bool? value) {
                              setState(() {
                                isNeutered = value!;
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
