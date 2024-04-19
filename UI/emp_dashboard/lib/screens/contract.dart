import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:internalapi/api.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:rxdart/rxdart.dart';

class ContractPage extends StatefulWidget {
  ContractPage(this.contract, this.reloadContracts, {super.key});
  CachedObj<ContractRes> contract;
  VoidCallback reloadContracts;
  @override
  State<ContractPage> createState() => _ContractPageState(contract);
}

class _ContractPageState extends State<ContractPage> {
  ContractService contractService =
      (LoginStateContext.getInstance().state as LoggedInState).contractService;
  _ContractPageState(this.contract) {}
  CachedObj<ContractRes> contract;

  TextEditingController startDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  TextEditingController endDateController = TextEditingController();
  DateTime endDate = DateTime.now();
  TextEditingController coverageController = TextEditingController();
  TextEditingController catNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  DateTime birthDate = DateTime.now();
  bool isNeutered = false;
  TextEditingController weightController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  TextEditingController selectedBreedController = TextEditingController();
  TextEditingController selectedColorController = TextEditingController();
  TextEditingController selectedPersonalityController = TextEditingController();
  TextEditingController selectedEnvironmentController = TextEditingController();

  bool editMode = false; //erstmal kein editieren erlaubt

  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  Breed selectedBreed;
  Color selectedColor;
  Personality selectedPersonality;
  Environment selectedEnvironment;

  @override
  void initState() {
    super.initState();
    final obj = contract.getObj();
    startDate = obj.startDate.add(const Duration(days: 1));
    endDate = obj.endDate.add(const Duration(days: 1));
    coverageController.text = obj.coverage.toString();
    rateController.text = obj.rate.toString();
    catNameController.text = obj.catName;
    birthDate = obj.birthDate.add(const Duration(days: 1));
    isNeutered = obj.neutered;
    selectedBreed = obj.breed;
    selectedColor = obj.color;
    selectedPersonality = obj.personality;
    selectedEnvironment = obj.environment;
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
                          readOnly: !editMode,
                          controller: startDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Beginn",
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Bitte Startdatum angeben";
                            }
                            final date = DateFormat('dd.MM.yyyy').parse(value);
                            if (![1, 15].contains(date.day))
                              return "Nur 1. oder 15. eines Monats erlaubt";
                            return null;
                          },
                          onTap: () async {
                            if (editMode) {
                              final date = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.parse("2006-01-02"),
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
                          readOnly: !editMode,
                          controller: endDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Ende",
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Bitte Enddatum angeben";
                            }
                            final date = DateFormat('dd.MM.yyyy').parse(value);
                            if (![14, 31].contains(date.day))
                              return "Nur 14. oder 31. eines Monats erlaubt";
                            return null;
                          },
                          onTap: () async {
                            if (editMode) {
                              final date = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.parse("2006-01-02"),
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
                          readOnly: !editMode,
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
                              prefixText: "€ ",
                              border: OutlineInputBorder(),
                              labelText: "Deckung"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        child: TextFormField(
                          readOnly: !editMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe darf nicht leer sein';
                            }
                            try {
                              double.parse(value);
                            } catch (e) {
                              return 'Ungültige Eingabe';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: rateController,
                          decoration: InputDecoration(
                              prefixText: "€ ",
                              border: OutlineInputBorder(),
                              labelText: "Rate"),
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
                          readOnly: !editMode,
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
                      //dropdown menu für enum
                      height: 50,
                      width: 230,
                      child: DropdownMenu<Breed>(
                        initialSelection: selectedBreed,
                        controller: selectedBreedController,
                        enabled: false,
                        label: const Text('Color'),
                        onSelected: (Breed? value) {
                          setState(() {
                            selectedBreed = value!;
                            selectedBreedController.text =
                                selectedColor.toString();
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: null, label: ""),
                          ...Breed.values.map<DropdownMenuEntry<Breed>>(
                              (Breed titleStatus) {
                            return DropdownMenuEntry<Breed>(
                              value: titleStatus,
                              label: titleStatus.toString(),
                            );
                          })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      //dropdown menu für enum
                      height: 50,
                      width: 230,
                      child: DropdownMenu<Color>(
                        initialSelection: selectedColor,
                        controller: selectedColorController,
                        enabled: false,
                        label: const Text('Color'),
                        onSelected: (Color? value) {
                          setState(() {
                            selectedColor = value!;
                            selectedColorController.text =
                                selectedColor.toString();
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: null, label: ""),
                          ...Color.values.map<DropdownMenuEntry<Color>>(
                              (Color titleStatus) {
                            return DropdownMenuEntry<Color>(
                              value: titleStatus,
                              label: titleStatus.toString(),
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
                        readOnly: !editMode,
                        controller: birthDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Geburtstag",
                        ),
                        onTap: () async {
                          if (editMode) {
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
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    Container(
                      //dropdown menu für enum
                      height: 50,
                      width: 230,
                      child: DropdownMenu<Personality>(
                        initialSelection: selectedPersonality,
                        controller: selectedPersonalityController,
                        enabled: false,
                        label: const Text('Personality'),
                        onSelected: (Personality? value) {
                          setState(() {
                            selectedPersonality = value!;
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: null, label: ""),
                          ...Personality.values
                              .map<DropdownMenuEntry<Personality>>(
                                  (Personality titleStatus) {
                            return DropdownMenuEntry<Personality>(
                              value: titleStatus,
                              label: titleStatus.toString(),
                            );
                          })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      //dropdown menu für enum
                      height: 50,
                      width: 230,
                      child: DropdownMenu<Environment>(
                        initialSelection: selectedEnvironment,
                        controller: selectedEnvironmentController,
                        enabled: false,
                        label: const Text('Environment'),
                        onSelected: (Environment? env) {
                          setState(() {
                            selectedEnvironment = env!;
                            selectedEnvironmentController.text =
                                selectedEnvironment.toString();
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: null, label: ""),
                          ...Environment.values
                              .map<DropdownMenuEntry<Environment>>(
                                  (Environment titleStatus) {
                            return DropdownMenuEntry<Environment>(
                              value: titleStatus,
                              label: titleStatus.toString(),
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
                          readOnly: !editMode,
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
                              suffixText: "g",
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
                              if (editMode) {
                                setState(() {
                                  isNeutered = value!;
                                });
                              } else {
                                null;
                              }
                            })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
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
                Expanded(child: Container()),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
