import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<bool> save() async {
    if (!newContractFormKey.currentState!.validate()) {
      return false;
    }
    final oldPrice = priceSubject.value;
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
    final contractRes = await contractService.createContract(contractReq);
    print("Created contract: ${contractRes.getId()}");
    return true;
  }

  GlobalKey<FormState> newContractFormKey = GlobalKey<FormState>();

  BehaviorSubject<double> priceSubject = BehaviorSubject.seeded(0);

  Future<double> reloadPrice() async {
    final coverage = int.parse(coverageController.text);
    final weight = double.parse(weightController.text);
    final zipCode = 99999;
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
    priceSubject.add(price);
    return price;
  }

  final debouncer = Debouncer(delay: Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,

        // onChanged: () {
        //   debouncer.run(() async {
        //     try {
        //       await reloadPrice();
        //     } catch (e) {
        //       print("Reloaded price failed: $e");
        //     }
        //   });
        // },
        key: newContractFormKey,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  Header("Neuen Vertrag Anlegen", []),
                  Expanded(child: Container()),
                  logo
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                      color: Colors.grey,
                      padding: EdgeInsets.all(10),
                      child: StreamBuilder<double>(
                          stream: priceSubject,
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data!.toString(),
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            );
                          })),
                  SizedBox(
                    width: 70,
                  ),
                  Column(
                    children: [
                      Container(
                          height: 50,
                          width: 230,
                          child: DateTimeFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Bitte Startdatum angeben";
                              }
                              return null;
                            },
                            dateFormat: DateFormat('dd.MM.yyyy'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Beginn"),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 36500)),
                            onDateSelected: (DateTime? value) {
                              startDate = value!;
                            },
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: DateTimeFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Bitte Enddatum angeben";
                              }
                              return null;
                            },
                            dateFormat: DateFormat('dd.MM.yyyy'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Ende"),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 36500)),
                            onDateSelected: (DateTime? value) {
                              endDate = value!;
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
                      LoadingButton(
                        label: "Vertrag Abschließen",
                        onPressed: () async {
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
                      // Container(
                      //     height: 50,
                      //     width: 230,
                      //     child: TextFormField(
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Eingabe darf nicht leer sein';
                      //         }
                      //         //check ob Rasse hier?
                      //         return null;
                      //       },
                      //       controller: breedController,
                      //       decoration: InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Rasse"),
                      //     )),
                      Container(
                        //dropdown menu für enum
                        height: 50,
                        width: 230,
                        child: DropdownMenu<CatBreedEnum>(
                          initialSelection: selectedBreed,
                          controller: breedController,
                          requestFocusOnTap: true,
                          label: const Text('Rasse'),
                          onSelected: (CatBreedEnum? breed) {
                            setState(() {
                              if (breed == null) return;
                              selectedBreed = breed;
                            });
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
                          height: 50,
                          width: 230,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eingabe darf nicht leer sein';
                              }
                              //check auf Farbe?
                              return null;
                            },
                            controller: colorController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Farbe"),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: DateTimeFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Eingabe darf nicht leer sein';
                              }
                              return null;
                            },
                            dateFormat: DateFormat('dd.MM.yyyy'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Geburtstag"),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 9300)),
                            lastDate: DateTime.now(),
                            onDateSelected: (DateTime? value) {
                              birthDate = value!;
                            },
                          )),
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
                  TextButton(
                      onPressed: () async {
                        await reloadPrice();
                      },
                      child: Text("Reload Rate"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
