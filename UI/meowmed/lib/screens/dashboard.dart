import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/services/debouncer.dart';
import 'package:meowmed/data/services/refreshTimer.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/screens/newcustomer.dart';
import 'package:meowmed/widgets/customerlist.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<CachedObj<CustomerRes>> customers;
  final debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final loggedInState =
      (LoginStateContext.getInstance().state as LoggedInState);

  @override
  void initState() {
    super.initState();
    loadData();
    refreshTimer = RefreshTimer(loadData);
    refreshTimer.init();
  }

  late RefreshTimer refreshTimer;

  Future<void> loadData() async {
    searchController.clear();
    final customerService = loggedInState.customerService;
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
    final searchLower = search.toLowerCase();
    final result = customers.where((element) {
      final obj = element.getObj();
      return obj.firstName.toLowerCase().contains(searchLower) ||
          obj.lastName.toLowerCase().contains(searchLower);
    }).toList();
    filteredCustomers.add(result);

    // TODO: teil oben kann weg, sobald api geht

    final state = (LoginStateContext.getInstance().state as LoggedInState);
    final customerService = state.customerService;
    final data = await customerService.searchCustomers(search);
    customers = data;
    filteredCustomers.add(data);
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    refreshTimer.dispose();
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
                Expanded(child: Container()),
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
                      loadData();
                    },
                    icon: Icon(Icons.refresh)),
                Expanded(child: Container()),
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
            Expanded(child: CustomerList(filteredCustomers))
          ],
        ),
      ),
    );
  }
}
