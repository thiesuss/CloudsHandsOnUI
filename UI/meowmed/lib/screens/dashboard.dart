import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/debouncer.dart';
import 'package:meowmed/data/services/refreshTimer.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/screens/customer.dart';
import 'package:meowmed/screens/newcustomer.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/link.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<CachedObj<CustomerRes>> customers;
  final debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final customerService =
      (LoginStateContext.getInstance().state as LoggedInState).customerService;

  @override
  void initState() {
    super.initState();
    getCustomers();
    refreshTimer = RefreshTimer(getCustomers);
    refreshTimer!.init();
  }

  RefreshTimer? refreshTimer;

  Future<void> getCustomers() async {
    searchController.clear();
    final repo = customerService.repo;
    final cached = repo.getAll();
    customers = cached;
    filteredCustomers.add(customers);

    // TODO: teil oben kann weg, sobald api geht

    final customerResList = await customerService.getCustomers();
    customers = customerResList;
    filteredCustomers.add(customers);
  }

  late BehaviorSubject<List<CachedObj<CustomerRes>>> filteredCustomers =
      BehaviorSubject.seeded([]);

  Future<void> _searchCustomer(String search) async {
    filteredCustomers.add(await customerService.searchCustomers(search));
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    refreshTimer?.dispose();
    super.dispose();
  }
  // final Uri _rickRoll = Uri.parse('https://youtu.be/dQw4w9WgXcQ');

  // Future<void> _launchRickRoll() async {
  //   if (!await _launchRickRoll(_rickRoll)) {
  //     throw Exception('Could not launch $_rickRoll');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Header("Mitarbeiter Dashboard", []),
                // Expanded(child: Container()),
                // TODO: Extract Logo
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
              height: 20,
            ),
            Row(
              children: [
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                        onChanged: (text) async {
                          debouncer.run(() async {
                            await _searchCustomer(text);
                          });
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Suche..."))),
                IconButton(
                    onPressed: () {
                      _searchCustomer(searchController.text);
                    },
                    icon: Icon(Icons.search)),
                IconButton(
                    onPressed: () {
                      getCustomers();
                    },
                    icon: Icon(Icons.refresh)),
                // Expanded(child: Container()),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewCustomer()));
                    },
                    child: Text("Neuer Kunde"))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: StreamBuilder<void>(
              stream: filteredCustomers.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Column(
                  children: [
                    DataTable(
                        headingTextStyle:
                            TextStyle(fontWeight: FontWeight.bold),
                        border: TableBorder(
                            borderRadius: BorderRadius.circular(10),
                            top: BorderSide(),
                            horizontalInside: BorderSide(),
                            verticalInside: BorderSide(),
                            bottom: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide()),
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Nachname")),
                          DataColumn(label: Text("Vorname")),
                          DataColumn(label: Text("Adresse")),
                          DataColumn(label: Text("Aktionen"))
                        ],
                        rows: [
                          ...customerService.repo.getAll().map((e) {
                            final obj = e.getObj();
                            final adr = obj.address;
                            return DataRow(cells: [
                              DataCell(Text(obj.id.toString())),
                              DataCell(Text(obj.lastName)),
                              DataCell(Text(obj.firstName)),
                              DataCell(Text(adr.street +
                                  " " +
                                  adr.houseNumber +
                                  ", " +
                                  adr.city)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Customer(e)));
                                      },
                                      icon: Icon(Icons.edit)),
                                  Link(
                                    uri: Uri.parse(
                                        'https://youtu.be/dQw4w9WgXcQ'),
                                    target: LinkTarget.self,
                                    builder: (context, followLink) =>
                                        IconButton(
                                            onPressed: () {
                                              followLink;
                                            },
                                            icon: Icon(Icons.delete)),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.remove_red_eye))
                                ],
                              ))
                            ]);
                          }),
                        ]),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.expand_circle_down_outlined))
                  ],
                );
              },
            )))
          ],
        ),
      ),
    );
  }
}
