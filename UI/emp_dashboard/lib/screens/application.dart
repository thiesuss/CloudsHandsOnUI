import 'package:flutter/material.dart';
import 'package:internalapi/api.dart';
import 'package:internalapi/api.dart' as api;
import 'package:intl/intl.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/applicationservice.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:meowmed/widgets/loadingButton.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationPage extends StatefulWidget {
  ApplicationPage({Key? key}) : super(key: key);

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  void initState() {
    super.initState();
  }

  ApplicationService applicationService =
      (LoginStateContext.getInstance().state as LoggedInState)
          .applicationService;
  ContractService contractService =
      (LoginStateContext.getInstance().state as LoggedInState).contractService;

  BehaviorSubject<String?> error = BehaviorSubject.seeded(null);

  @override
  Widget build(BuildContext context) {
    final reloadButton = IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () async {
        setState(() {});
      },
    );
    return Scaffold(
        body: ListView(
      children: [
        Header("Applications", [reloadButton]),
        SizedBox(height: 20),
        FutureBuilder<CachedObj<ApplicationRes>?>(
          future: applicationService.nextApplication(),
          builder: (BuildContext context,
              AsyncSnapshot<CachedObj<ApplicationRes>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return buildErrorTile(
                "Fehler bei nextApplication(): ",
                snapshot.error.toString(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text('Keine neue Application vorhanden'),
              );
            }
            CachedObj<ApplicationRes> applicationCached = snapshot.data!;
            ApplicationRes application = applicationCached.getObj();

            if (application.contract == null || application.customer == null) {
              return Text(
                  "application.contract oder application.customer ist null");
            }

            return Column(
              children: [
                Text('Application: ${applicationCached.getId()}'),
                StreamBuilder<String?>(
                  stream: error.stream,
                  initialData: null,
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    return snapshot.data == null
                        ? Container()
                        : buildErrorTile("Fehler: ", snapshot.data!);
                  },
                ),
                FutureBuilder<double>(
                  future: applicationService
                      .getRateForApplication(applicationCached),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    return snapshot.hasData
                        ? Text("Rate: ${snapshot.data!}")
                        : Container();
                  },
                ),
                ApplicationInformation(
                  title: "Vorname",
                  value: application.customer!.firstName,
                ),
                ApplicationInformation(
                    title: "Nachname", value: application.customer!.lastName),
                ApplicationInformation(
                    title: "Email", value: application.customer!.email),
                ApplicationInformation(
                  title: "Gerburtsdatum",
                  value: DateFormat("dd.MM.yyyy")
                      .format(application.customer!.birthDate),
                ),
                ApplicationInformation(
                  title: "Social Security Number",
                  value: application.customer!.socialSecurityNumber,
                ),
                ApplicationInformation(
                  title: "Tax ID",
                  value: application.customer!.taxId,
                ),
                ApplicationInformation(
                  title: "Straße",
                  value: application.customer!.address.street,
                ),
                ApplicationInformation(
                    title: "Haus Nr.",
                    value: application.customer!.address.houseNumber),
                ApplicationInformation(
                    title: "PLZ",
                    value: application.customer!.address.zipCode.toString()),
                ApplicationInformation(
                  title: "Stadt",
                  value: application.customer!.address.city,
                ),
                ApplicationInformation(
                  title: "IBAN",
                  value: application.customer!.bankDetails.iban,
                ),
                ApplicationInformation(
                  title: "BIC",
                  value: application.customer!.bankDetails.bic,
                ),
                ApplicationInformation(
                  title: "Konto Inhaber",
                  value: application.customer!.bankDetails.name,
                ),
                ApplicationInformation(
                  title: "Startdatum",
                  value: DateFormat("dd.MM.yyyy")
                      .format(application.contract!.startDate),
                ),
                ApplicationInformation(
                  title: "Enddatum",
                  value: DateFormat("dd.MM.yyyy")
                      .format(application.contract!.endDate),
                ),
                ApplicationInformation(
                    title: "Coverage",
                    value: application.contract!.coverage.toString()),
                ApplicationInformation(
                  title: "Name der Katze",
                  value: application.contract!.catName,
                ),
                ApplicationInformation(
                  title: "Rasse der Katze",
                  value: application.contract!.breed.toString(),
                ),
                ApplicationInformation(
                  title: "Farbe",
                  value: application.contract!.color.toString(),
                ),
                ApplicationInformation(
                  title: "Geburtsdatum der Katze",
                  value: DateFormat("dd.MM.yyyy")
                      .format(application.contract!.birthDate),
                ),
                ApplicationInformation(
                  title: "Kastriert",
                  value: application.contract!.neutered.toString(),
                ),
                ApplicationInformation(
                  title: "Persönlichkeit",
                  value: application.contract!.personality.toString(),
                ),
                ApplicationInformation(
                  title: "Umfeld",
                  value: application.contract!.environment.toString(),
                ),
                ApplicationInformation(
                  title: "Gewicht",
                  value: application.contract!.weight.toString(),
                ),
                Row(
                  children: [
                    LoadingButton(
                        label: "Ablehnen",
                        onPressed: () async {
                          error.add(null);
                          try {
                            await applicationService
                                .declineApplication(applicationCached);
                            setState(() {});
                          } catch (e) {
                            error.add(e.toString());
                          }
                        }),
                    LoadingButton(
                        label: "Annehmen",
                        onPressed: () async {
                          error.add(null);
                          try {
                            await applicationService
                                .acceptApplication(applicationCached);
                            setState(() {});
                          } catch (e) {
                            error.add(e.toString());
                          }
                        }),
                    LoadingButton(
                        label: "Zurück",
                        onPressed: () async {
                          error.add(null);
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            );
          },
        ),
      ],
    ));
  }
}

class ApplicationInformation extends StatelessWidget {
  ApplicationInformation({super.key, required this.title, required this.value});

  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        SizedBox(
          width: 20,
        ),
        Text(value),
      ],
    );
  }
}
