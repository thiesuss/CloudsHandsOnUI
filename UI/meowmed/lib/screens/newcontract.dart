import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/catinfoservice.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/debouncer.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';

enum PriceReloadingState { idle, loading, done }

class NewContract extends StatefulWidget {
  NewContract(this.customerRes);
  CachedObj<CustomerRes> customerRes;
  @override
  State<NewContract> createState() => _NewContractState();
}

class _NewContractState extends State<NewContract> {
  final contractService =
      (LoginStateContext.getInstance().state as LoggedInState).contractService;

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
  // TextEditingController neuteredController = TextEditingController();             Nicht mehr relevant wegen checkbox(?)
  bool isNeutered = false;
  TextEditingController personalityController = TextEditingController();
  TextEditingController environmentController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  CatBreedEnum selectedBreed = CatBreedEnum.bengal;
  CatColorEnum selectedColor = CatColorEnum.braun;
  CatEnvironmentEnum selectedEnvironment = CatEnvironmentEnum.drinnen;
  CatPersonalityEnum selectedPersonality = CatPersonalityEnum.anhaenglich;

  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  Future<bool> save() async {
    error.add(null);
    if (!newContractFormKey.currentState!.validate()) {
      return false;
    }
    final oldPrice = this.price;
    final price = await reloadPrice();

    if (oldPrice != price) {
      return false;
    }
    final coverage = int.parse(coverageController.text);
    final weight = double.parse(weightController.text);
    final contractReq = ContractReq(
      startDate: startDate,
      endDate: endDate,
      coverage: coverage,
      catName: catNameController.text,
      breed: breedController.text,
      color: colorController.text,
      birthDate: birthDate,
      neutered: isNeutered, //checkbox setState
      personality: personalityController.text,
      environment: environmentController.text,
      weight: weight,
      customerId: widget.customerRes.getId(),
    );
    try {
      final contractRes = await contractService.createContract(contractReq);
      print("Created contract: ${contractRes.getId()}");
      return true;
    } catch (e) {
      print("Failed to create contract: $e");
      error.add(e.toString());
      throw e;
    }
  }

  GlobalKey<FormState> newContractFormKey = GlobalKey<FormState>();

  double price = 0;
  BehaviorSubject<PriceReloadingState> priceReloadingState =
      BehaviorSubject.seeded(PriceReloadingState.idle);

  Future<double> reloadPrice() async {
    error.add(null);
    priceReloadingState.add(PriceReloadingState.loading);
    try {
      final coverage = int.parse(coverageController.text);
      final weight = double.parse(weightController.text);
      final zipCode = widget.customerRes.getObj().address.zipCode;
      final rateReq = RateCalculationReq(
          coverage: coverage,
          breed: breedController.text,
          color: colorController.text,
          birthDate: birthDate,
          neutered: isNeutered,
          personality: personalityController.text,
          environment: environmentController.text,
          weight: weight,
          zipCode: zipCode);
      final rateRes = await contractService.getRate(rateReq);
      double price = rateRes.rate!.toDouble();
      this.price = price;
      priceReloadingState.add(PriceReloadingState.done);
      return price;
    } catch (e) {
      priceReloadingState.add(PriceReloadingState.idle);
      error.add(e.toString());
      print("Failed to reload price: $e");
    }
    return 0;
  }

  final debouncer = Debouncer(delay: Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        onChanged: () {
          debouncer.run(() async {
            try {
              await reloadPrice();
            } catch (e) {
              print("Reloaded price failed: $e");
            }
          });
        },
        key: newContractFormKey,
        child: Container(
          padding: EdgeInsets.all(kDefaultSitePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header("Neuen Vertrag Anlegen", []),
              Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: StreamBuilder<PriceReloadingState>(
                          stream: priceReloadingState,
                          builder: (context, snapshot) {
                            if (snapshot.data == PriceReloadingState.loading) {
                              return CircularProgressIndicator();
                            }
                            return Text(
                              "$price€",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            );
                          })),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kDefaultMargin),
                      child: Column(
                        children: [
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
                                  return null;
                                },
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 900)),
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
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kDefaultMargin),
                      child: Column(
                        children: [
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
                                    border: OutlineInputBorder(),
                                    labelText: "Name"),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //dropdown menu für enum
                            height: 50,
                            width: 230,
                            child: DropdownMenu<CatBreedEnum>(
                              initialSelection: selectedBreed,
                              controller: breedController,
                              requestFocusOnTap: true,
                              label: const Text('Rasse'),
                              onSelected: (CatBreedEnum? breed) async {
                                setState(() {
                                  if (breed == null) return;
                                  selectedBreed = breed;
                                });
                                await reloadPrice();
                              },
                              dropdownMenuEntries: CatBreedEnum.values
                                  .map<DropdownMenuEntry<CatBreedEnum>>(
                                      (CatBreedEnum breed) {
                                return DropdownMenuEntry<CatBreedEnum>(
                                  value: breed,
                                  label: CatBreedEnum.breedToString(
                                      breed), // familienstatusenum.ledig
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //dropdown menu für enum
                            height: 50,
                            width: 230,
                            child: DropdownMenu<CatColorEnum>(
                              initialSelection: selectedColor,
                              controller: colorController,
                              requestFocusOnTap: true,
                              label: const Text('Farbe'),
                              onSelected: (CatColorEnum? color) async {
                                setState(() {
                                  if (color == null) return;
                                  selectedColor = color;
                                });
                                await reloadPrice();
                              },
                              dropdownMenuEntries: CatColorEnum.values
                                  .map<DropdownMenuEntry<CatColorEnum>>(
                                      (CatColorEnum color) {
                                return DropdownMenuEntry<CatColorEnum>(
                                  value: color,
                                  label: CatColorEnum.colorToString(
                                      color), // familienstatusenum.ledig
                                );
                              }).toList(),
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
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kDefaultMargin),
                      child: Column(
                        children: [
                          Container(
                            //dropdown menu für enum
                            height: 50,
                            width: 230,
                            child: DropdownMenu<CatPersonalityEnum>(
                              initialSelection: selectedPersonality,
                              controller: personalityController,
                              requestFocusOnTap: true,
                              label: const Text('Persönlichkeit'),
                              onSelected:
                                  (CatPersonalityEnum? personality) async {
                                setState(() {
                                  if (personality == null) return;
                                  selectedPersonality = personality;
                                });
                                await reloadPrice();
                              },
                              dropdownMenuEntries: CatPersonalityEnum.values
                                  .map<DropdownMenuEntry<CatPersonalityEnum>>(
                                      (CatPersonalityEnum personality) {
                                return DropdownMenuEntry<CatPersonalityEnum>(
                                  value: personality,
                                  label: CatPersonalityEnum.personalityToString(
                                      personality), // familienstatusenum.ledig
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //dropdown menu für enum
                            height: 50,
                            width: 230,
                            child: DropdownMenu<CatEnvironmentEnum>(
                              initialSelection: selectedEnvironment,
                              controller: environmentController,
                              requestFocusOnTap: true,
                              label: const Text('Umgebung'),
                              onSelected:
                                  (CatEnvironmentEnum? environment) async {
                                setState(() {
                                  if (environment == null) return;
                                  selectedEnvironment = environment;
                                });
                                await reloadPrice();
                              },
                              dropdownMenuEntries: CatEnvironmentEnum.values
                                  .map<DropdownMenuEntry<CatEnvironmentEnum>>(
                                      (CatEnvironmentEnum environment) {
                                return DropdownMenuEntry<CatEnvironmentEnum>(
                                  value: environment,
                                  label: CatEnvironmentEnum.environmentToString(
                                      environment), // familienstatusenum.ledig
                                );
                              }).toList(),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: weightController,
                              decoration: InputDecoration(
                                  suffixText: "g",
                                  border: OutlineInputBorder(),
                                  labelText: "Gewicht"),
                            ),
                          ),
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
                                  onChanged: (bool? value) async {
                                    setState(() {
                                      isNeutered = value!;
                                    });
                                    await reloadPrice();
                                  })
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
                        "Fehler: ", snapshot.data!),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingButton(
                    label: "Vertrag Abschließen",
                    onPressed: () async {
                      if (!newContractFormKey.currentState!.validate()) {
                        return;
                      }
                      final result = await save();
                      if (result) Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Abbrechen")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
