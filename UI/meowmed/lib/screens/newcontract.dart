import 'package:flutter/material.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/debouncer.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';

class NewContract extends StatefulWidget {
  const NewContract({super.key});

  @override
  State<NewContract> createState() => _NewContractState();
}

class _NewContractState extends State<NewContract> {
  final contractService =
      (LoginStateContext.getInstance().state as LoggedInState).contractService;

  Future<void> save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final contractReq = ContractReq(
      startDate: startDateController.text,
      endDate: endDateController.text,
      coverage: coverageController.text,
      catName: catNameController.text,
      breed: breedController.text,
      color: colorController.text,
      birthDate: birthDateController.text,
      neutered: neuteredController.text,
      personality: personalityController.text,
      environment: environmentController.text,
      weight: weightController.text,
      customerId: customerIdController.text,
    );
    final contractRes = await contractService.createContract(contractReq);
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BehaviorSubject<double> priceSubject = BehaviorSubject.seeded(0);

  Future<void> reloadPrice() async {
    final rateReq = RateCalculationReq(
        coverage: coverageController.text,
        breed: breedController.text,
        color: colorController.text,
        birthDate: birthDateController.text,
        neutered: neuteredController.text,
        personality: personalityController.text,
        environment: environmentController.text,
        weight: weightController.text,
        zipCode: zipCodeController.text);
    final rateres = await contractService.getRate(rateReq);
    double price = rateres.rate!.toDouble();
    priceSubject.add(price);
  }

  final debouncer = Debouncer(delay: Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        onChanged: () {
          debouncer.run(() async {
            await reloadPrice();
          });
        },
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  Header("Neuen Vertrag Anlegen", []),
                  Expanded(child: Container()),
                  Container(
                    width: 350,
                    height: 50,
                    child: Image(
                      image: AssetImage(
                          'assets/images/MeowcroservicesLogoNew.png'),
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
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "1234", //hier die ID Value hin per API
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
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Beginn"),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Ende"),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: TextField(
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
                          onPressed: () async {
                            final price = await reloadPrice();
                            await save();
                            Navigator.pop(context);
                          },
                          child: Text("Vertrag Abschließen")),
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
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Name"),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Rasse"),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: TextField(
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
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Alter"),
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
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Kastriert"),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          width: 230,
                          child: TextField(
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
                          child: TextField(
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
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Gewicht"),
                          )),
                    ],
                  ),
                  Expanded(child: Container())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
