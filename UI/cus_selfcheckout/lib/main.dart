import 'package:customerapi/api.dart';
import 'package:customerapi/api.dart' as api;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runApp(const MyApp());
  await initializeDateFormatting('de_DE', null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _apply() async {
    if (!(_formKey.currentState as FormState).validate()) return;
    error.add(null);
    final api = ApiClient(
      basePath: _backendController.text,
    );
    final defaultApi = DefaultApi(api);
    final rate = await reloadRate();

    final adress = Address(
      street: streetController.text,
      houseNumber: houseNumberController.text,
      zipCode: int.parse(zipCodeController.text),
      city: cityController.text,
    );
    final bankDetails = BankDetails(
      iban: ibanController.text,
      bic: bicController.text,
      name: nameController.text,
    );

    final applicationReq = ApplicationReq(
        customer: CustomerReq(
          email: emailController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          title: selectedTitle,
          birthDate: DateFormat('dd.MM.yyyy').parse(birthDateController.text),
          socialSecurityNumber: socialSecurityNumberController.text,
          taxId: taxIdController.text,
          address: adress,
          bankDetails: bankDetails,
        ),
        contract: Contract(
            startDate: DateFormat('dd.MM.yyyy').parse(startDateController.text),
            endDate: DateFormat('dd.MM.yyyy').parse(endDateController.text),
            coverage: rate,
            catName: catNameController.text,
            breed: selectedBreed!,
            color: selectedColor!,
            birthDate: DateFormat('dd.MM.yyyy').parse(birthDateController.text),
            neutered: isNeutered,
            personality: selectedPersonality!,
            environment: selectedEnvironment!,
            weight: double.parse(weightController.text)));

    try {
      await defaultApi.createApplication(applicationReq);
    } catch (e) {
      error.add(e.toString());
      rethrow;
    }
  }

  Future<double> reloadRate() async {
    final api = ApiClient(
      basePath: _backendController.text,
    );
    final defaultApi = DefaultApi(api);

    final rateCalculationReq = RateCalculationReq(
        coverage: double.parse(coverageController.text),
        breed: selectedBreed!,
        color: selectedColor!,
        birthDate: DateFormat('dd.MM.yyyy').parse(birthDateController.text),
        neutered: isNeutered,
        personality: selectedPersonality!,
        environment: selectedEnvironment!,
        weight: double.parse(weightController.text),
        zipCode: int.parse(zipCodeController.text));
    try {
      final rateRaw = await defaultApi.calculateRate(rateCalculationReq);
      if (rateRaw == null) throw Exception('Rate is null');
      final rate = double.parse(rateRaw.rate.toString());
      return rate;
    } catch (e) {
      error.add(e.toString());
      rethrow;
    }
  }

  BehaviorSubject<double> rate = BehaviorSubject.seeded(0.0);
  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  TextEditingController _backendController = TextEditingController();

  api.Breed? selectedBreed;
  api.Color? selectedColor;
  api.Personality? selectedPersonality;
  api.Environment? selectedEnvironment;
  api.Title? selectedTitle;
  bool isNeutered = false;

  TextEditingController streetController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController bicController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController socialSecurityNumberController =
      TextEditingController();
  TextEditingController taxIdController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController coverageController = TextEditingController();
  TextEditingController catNameController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        onChanged: () {
          reloadRate();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 50,
                width: 230,
                child: TextFormField(
                  controller: _backendController,
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
                    labelText: "BackendUrl",
                  ),
                )),
            Container(
                height: 50,
                width: 230,
                child: TextFormField(
                  controller: vornamecontroller,
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
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 230,
              child: TextFormField(
                controller: emailController,
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
                  if (!widget.readOnly) {
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
                      border: OutlineInputBorder(), labelText: "Straße"),
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
                      border: OutlineInputBorder(), labelText: "Hausnummer"),
                )),
            Container(
                height: 80,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      border: OutlineInputBorder(), labelText: "Stadt"),
                )),
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
                      border: OutlineInputBorder(), labelText: "IBAN"),
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
            Container(
                height: 50,
                width: 230,
                child: TextFormField(
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
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.parse("2006-01-02"),
                        lastDate:
                            DateTime.now().add(const Duration(days: 36500)),
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
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.parse("2006-01-02"),
                        lastDate:
                            DateTime.now().add(const Duration(days: 36500)),
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: rateController,
                  decoration: InputDecoration(
                      prefixText: "€ ",
                      border: OutlineInputBorder(),
                      labelText: "Rate"),
                )),
            Container(
                height: 50,
                width: 230,
                child: TextFormField(
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
                    selectedBreedController.text = selectedColor.toString();
                  });
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: selectedBreed, label: ""),
                  ...Breed.values
                      .map<DropdownMenuEntry<Breed>>((Breed titleStatus) {
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
                    selectedColorController.text = selectedColor.toString();
                  });
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: selectedColor, label: ""),
                  ...Color.values
                      .map<DropdownMenuEntry<Color>>((Color titleStatus) {
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
                controller: birthDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Geburtstag",
                ),
                onTap: () async {
                  if (editMode) {
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
                  }
                },
              ),
            ),
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
                  DropdownMenuEntry(value: selectedPersonality, label: ""),
                  ...Personality.values.map<DropdownMenuEntry<Personality>>(
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
                  DropdownMenuEntry(value: selectedEnvironment, label: ""),
                  ...Environment.values.map<DropdownMenuEntry<Environment>>(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Eingabe darf nicht leer sein';
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: weightController,
                  decoration: InputDecoration(
                      suffixText: "g",
                      border: OutlineInputBorder(),
                      labelText: "Gewicht"),
                )),
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
            StreamBuilder<String?>(
              stream: error,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return buildErrorTile("Fehler", snapshot.data!);
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _apply,
        tooltip: 'Apply',
        child: const Icon(Icons.add),
      ),
    );
  }
}

ExpansionTile buildErrorTile(String title, String error) {
  return ExpansionTile(
    leading: Icon(
      Icons.error,
      color: Colors.redAccent,
    ),
    title: Text(title),
    children: [
      Text(error),
    ],
  );
}
