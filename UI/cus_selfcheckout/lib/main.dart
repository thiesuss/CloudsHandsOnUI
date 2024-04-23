import 'package:customerapi/api.dart';
import 'package:customerapi/api.dart' as api;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:self_checkout/debouncer.dart';

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
    final weight = double.parse(weightController.text);
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
            startDate: DateFormat('dd.MM.yyyy')
                .parse(startDateController.text)
                .add(const Duration(days: 1)),
            endDate: DateFormat('dd.MM.yyyy')
                .parse(endDateController.text)
                .add(const Duration(days: 1)),
            coverage: rate,
            catName: catNameController.text,
            breed: selectedBreed!,
            color: selectedColor!,
            birthDate: DateFormat('dd.MM.yyyy')
                .parse(birthDateController.text)
                .add(const Duration(days: 1)),
            neutered: isNeutered,
            personality: selectedPersonality!,
            environment: selectedEnvironment!,
            weight: weight));

    try {
      await defaultApi.createApplication(applicationReq);
    } catch (e) {
      error.add(e.toString());
      rethrow;
    }
  }

  Future<double> reloadRate() async {
    rate.add(0.0);
    final api = ApiClient(
      basePath: _backendController.text,
    );
    final defaultApi = DefaultApi(api);
    final zipCode = int.parse(zipCodeController.text);
    final weight = double.parse(weightController.text);
    final coverage = double.parse(coverageController.text);

    final rateCalculationReq = RateCalculationReq(
        coverage: coverage,
        breed: selectedBreed!,
        color: selectedColor!,
        birthDate: DateFormat('dd.MM.yyyy')
            .parse(catBirthDateController.text)
            .add(const Duration(days: 1)),
        neutered: isNeutered,
        personality: selectedPersonality!,
        environment: selectedEnvironment!,
        weight: weight,
        zipCode: zipCode);
    try {
      final rateRaw = await defaultApi.calculateRate(rateCalculationReq);
      if (rateRaw == null || rateRaw.rate == null)
        throw Exception('Rate is null');
      final newRate = rateRaw.rate!.toDouble();
      rate.add(newRate);
      return newRate;
    } catch (e) {
      error.add(e.toString());
      rethrow;
    }
  }

  BehaviorSubject<double> rate = BehaviorSubject.seeded(0.0);
  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  TextEditingController _backendController = TextEditingController();

  api.Breed? selectedBreed = api.Breed.abyssinian;
  api.Color? selectedColor = api.Color.blau;
  api.Personality? selectedPersonality = api.Personality.anhnglich;
  api.Environment? selectedEnvironment = api.Environment.drauen;
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
  TextEditingController catBirthDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  GlobalKey _formKey = GlobalKey<FormState>();
  Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        onChanged: () {
          debouncer.run(() {
            reloadRate();
          });
        },
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: <Widget>[
            Header("Antrag", []),
            Container(
                height: 50,
                width: 230,
                margin: const EdgeInsets.only(bottom: 20),
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
            Row(
              children: [
                Text(
                  "Kundeninformationen",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              //dieses column beinhaltet die gesamten kundeninfos
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Column(
                      //dieses column für die infos --adresse --bankdetails
                      children: [
                        Row(
                          //namenrow
                          children: [
                            Container(
                                height: 50,
                                width: 230,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  controller: firstNameController,
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
                              width: 50,
                            ),
                            Container(
                                height: 50,
                                width: 230,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  controller: lastNameController,
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
                              width: 50,
                            ),
                            Container(
                              //dropdown menu für enum
                              height: 50,
                              width: 230,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: DropdownMenu<api.Title?>(
                                initialSelection: selectedTitle,
                                requestFocusOnTap: true,
                                label: const Text('Titel'),
                                onSelected: (api.Title? titleStatus) {
                                  setState(() {
                                    selectedTitle = titleStatus;
                                  });
                                },
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: null, label: ""),
                                  ...api.Title.values
                                      .map<DropdownMenuEntry<api.Title>>(
                                          (api.Title titleStatus) {
                                    return DropdownMenuEntry<api.Title>(
                                      value: titleStatus,
                                      label: titleStatus.toString(),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 330,
                              margin: const EdgeInsets.only(bottom: 20),
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
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              height: 50,
                              width: 330,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
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
                                    birthDateController.text =
                                        DateFormat('dd.MM.yyyy').format(date);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                height: 70,
                                width: 330,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  controller: socialSecurityNumberController,
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
                              width: 50,
                            ),
                            Container(
                                height: 70,
                                width: 330,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  controller: taxIdController,
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
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                Row(
                  //Reihe mit adresse und bankdetail columns
                  children: [
                    Expanded(child: Container()),
                    Column(
                      //adresse column
                      children: [
                        Row(
                          children: [
                            Text(
                              "Adresse",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Container(
                              height: 50,
                              width: 290,
                              margin: const EdgeInsets.only(bottom: 20),
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
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              height: 50,
                              width: 130,
                              margin: const EdgeInsets.only(bottom: 20),
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
                        ]),
                        Container(
                            height: 70,
                            width: 430,
                            margin: const EdgeInsets.only(bottom: 20),
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
                        Container(
                            height: 50,
                            width: 430,
                            margin: const EdgeInsets.only(bottom: 20),
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
                      width: 50,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Bankdetails",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 50,
                            width: 430,
                            margin: const EdgeInsets.only(bottom: 20),
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
                                  labelText: "IBAN",
                                  hintText: "bsp: DE12 1234 1234 1234 1234"),
                            )),
                        Container(
                            height: 70,
                            width: 430,
                            margin: const EdgeInsets.only(bottom: 20),
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
                        Container(
                            height: 50,
                            width: 430,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              controller: nameController,
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
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Vertragdetails",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )
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
                        margin: const EdgeInsets.only(bottom: 20),
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
                              startDateController.text =
                                  DateFormat('dd.MM.yyyy').format(date);
                            }
                          },
                        )),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                        height: 50,
                        width: 230,
                        margin: const EdgeInsets.only(bottom: 20),
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
                                endDateController.text =
                                    DateFormat('dd.MM.yyyy').format(date);
                              });
                            }
                          },
                        )),
                    Container(
                        height: 50,
                        width: 230,
                        margin: const EdgeInsets.only(bottom: 20),
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
                      height: 30,
                    ),
                    StreamBuilder(
                      stream: rate.stream,
                      initialData: 0,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return Text("Berechnete Rate: ${snapshot.data} €",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic));
                      },
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Katzendetails",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                            height: 50,
                            width: 230,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Eingabe darf nicht leer sein';
                                }
                                return null;
                              },
                              controller: catNameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Name"),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          height: 50,
                          width: 230,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: catBirthDateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "(der Katze)",
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
                                  catBirthDateController.text =
                                      DateFormat('dd.MM.yyyy').format(date);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // row mit zwei der katzendetail enums (rasse farbe)
                      children: [
                        Container(
                          //dropdown menu für enum
                          height: 50,
                          width: 230,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: DropdownMenu<Breed>(
                            width: 230,
                            initialSelection: selectedBreed,
                            label: const Text('Rasse'),
                            onSelected: (Breed? value) {
                              setState(() {
                                selectedBreed = value!;
                              });
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: selectedBreed!, label: ""),
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
                          width: 30,
                        ),
                        Container(
                          //dropdown menu für enum
                          height: 50,
                          width: 230,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: DropdownMenu<Color>(
                            width: 230,
                            initialSelection: selectedColor,
                            label: const Text('Farbe'),
                            onSelected: (Color? value) {
                              setState(() {
                                selectedColor = value!;
                              });
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: selectedColor!, label: ""),
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
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          //dropdown menu für enum
                          height: 50,
                          width: 230,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: DropdownMenu<Personality>(
                            width: 230,
                            initialSelection: selectedPersonality,
                            label: const Text('Persönlichkeit'),
                            onSelected: (Personality? value) {
                              setState(() {
                                selectedPersonality = value!;
                              });
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: selectedPersonality!, label: ""),
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
                          width: 30,
                        ),
                        Container(
                          //dropdown menu für enum
                          height: 50,
                          width: 230,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: DropdownMenu<Environment>(
                            width: 230,
                            initialSelection: selectedEnvironment,
                            label: const Text('Umgebung'),
                            onSelected: (Environment? env) {
                              setState(() {
                                selectedEnvironment = env!;
                              });
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: selectedEnvironment!, label: ""),
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
                      ],
                    ),
                    Row(
                      //row mit gewicht und kastriert
                      children: [
                        Container(
                            height: 55,
                            width: 230,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
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
                          width: 30,
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
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
            TextButton(
                onPressed: () {
                  firstNameController.text = "Max";
                  lastNameController.text = "Mustermann";
                  emailController.text = "max@musterman.de";
                  birthDateController.text = "01.01.1990";
                  socialSecurityNumberController.text = "12345678A123";
                  taxIdController.text = "12345678901";
                  streetController.text = "Musterstraße";
                  houseNumberController.text = "1";
                  zipCodeController.text = "12345";
                  cityController.text = "Musterstadt";
                  ibanController.text = "DE12345678901234567890";
                  bicController.text = "ABCDEF12ABC";
                  startDateController.text = "01.01.2022";
                  endDateController.text = "14.01.2022";
                  coverageController.text = "1000";
                  catNameController.text = "Minka";
                  catBirthDateController.text = "01.01.2020";
                  weightController.text = "5000";
                },
                child: Text("Fill Random")),
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

class Header extends StatelessWidget {
  Header(this.title, this.actions, {bool this.disableArrow = false});
  String title;
  List<Widget> actions;
  bool disableArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          Hero(
            tag: "SiteTitle",
            flightShuttleBuilder: flightShuttleBuilder,
            child: Text(
              title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Container()),
          logo,
        ],
      ),
    );
  }
}

final logo = Container(
  width: 350,
  height: 50,
  child: Image(
    image: AssetImage('assets/images/MeowcroservicesLogoNew.png'),
  ),
);

Widget flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
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
