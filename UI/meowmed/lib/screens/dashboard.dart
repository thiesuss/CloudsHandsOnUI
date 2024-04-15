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
import 'package:meowmed/widgets/dataTableShimmer.dart';
import 'package:meowmed/widgets/garten.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

enum DashboardState { loading, loaded, error, initial }

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

//TODO: Switch to enum for loading state,
class _DashboardState extends State<Dashboard> {
  final debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final customerService =
      (LoginStateContext.getInstance().state as LoggedInState).customerService;

  BehaviorSubject<DashboardState> state =
      BehaviorSubject.seeded(DashboardState.initial);
  String? error;

  @override
  void initState() {
    super.initState();
    loadCustomers();
    refreshTimer = RefreshTimer(() {
      loadCustomers();
    });
    refreshTimer!.init();
  }

  RefreshTimer? refreshTimer;

  Future<List<CachedObj<CustomerRes>>> loadCustomers() async {
    if (state.value == DashboardState.loading) {
      await state
          .firstWhere((element) => element != DashboardState.loading)
          .asStream()
          .first;
      return filteredCustomers.value;
    }
    error = null;
    state.add(DashboardState.loading);
    searchController.clear();
    try {
      final customerResList = await customerService.getCustomers();
      filteredCustomers.add(customerResList);
      state.add(DashboardState.loaded);
      return customerResList;
    } catch (e) {
      error = e.toString();
      state.add(DashboardState.error);
      throw e;
    }
  }

  late BehaviorSubject<List<CachedObj<CustomerRes>>> filteredCustomers =
      BehaviorSubject.seeded([]);

  Future<void> _searchCustomer(String search) async {
    error = null;
    if (state.value == DashboardState.loading) {
      await state
          .firstWhere((element) => element != DashboardState.loading)
          .asStream()
          .first;
    }
    if (search.isEmpty) {
      await loadCustomers();
      return;
    }
    filteredCustomers.add([]);
    state.add(DashboardState.loading);
    try {
      final result = await customerService.searchCustomers(search);
      filteredCustomers.add(result);
      state.add(DashboardState.loaded);
    } catch (e) {
      error = e.toString();
      state.add(DashboardState.error);
      throw e;
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    refreshTimer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: EdgeInsets.all(30), children: [
        Column(
          children: [
            Header("Mitarbeiter Dashboard", []),
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
                      loadCustomers();
                    },
                    icon: Icon(Icons.refresh)),
                Expanded(child: Container()),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewCustomer(loadCustomers)));
                    },
                    child: Text("Neuer Kunde"))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<void>(
              stream: CombineLatestStream.list<dynamic>(
                  [filteredCustomers.stream, state.stream]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Column(
                  children: [
                    if (state.value != DashboardState.loaded)
                      DataTableSchimmer(
                          columns: [
                            "ID",
                            "Nachname",
                            "Vorname",
                            "Adresse",
                            "Aktionen",
                          ],
                          itemsToSchimmer: 1,
                          width: double.infinity,
                          height: 100),
                    if (state.value == DashboardState.error)
                      buildErrorTile("Fehler beim Laden der Kunden", error!),
                    if (state.value == DashboardState.loaded)
                      SizedBox(
                        width: double.infinity,
                        child: DataTable(
                            headingTextStyle: dataTableHeading,
                            border: dataTableBorder,
                            columns: const [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Nachname")),
                              DataColumn(label: Text("Vorname")),
                              DataColumn(label: Text("Adresse")),
                              DataColumn(label: Text("Aktionen"))
                            ],
                            rows: [
                              ...filteredCustomers.value.map((e) {
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
                                                        Customer(e, true,
                                                            loadCustomers)));
                                          },
                                          icon: Icon(Icons.remove_red_eye)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Customer(e, false,
                                                            loadCustomers)));
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            final uri = Uri.parse(
                                                'https://youtu.be/dQw4w9WgXcQ');
                                            launchUrl(uri);
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ))
                                ]);
                              }),
                            ]),
                      ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.expand_circle_down_outlined))
                  ],
                );
              },
            )
          ],
        ),
      ]),
    );
  }
}
