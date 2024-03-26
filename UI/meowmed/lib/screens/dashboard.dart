import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/services/customerservice.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:meowmed/screens/newcustomer.dart';
import 'package:meowmed/widgets/customerlist.dart';
import 'package:meowmed/widgets/header.dart';
import 'package:openapi/api.dart';
import 'package:rxdart/rxdart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<CachedObj<CustomerRes>> orig;

  @override
  void initState() {
    final state = (LoginStateContext.getInstance().state as LoggedInState);
    final repo = state.customerService.repo;
    final cached = repo.getAll();
    orig = cached;
    customers = BehaviorSubject.seeded(orig);
    super.initState();
  }

  late BehaviorSubject<List<CachedObj<CustomerRes>>> customers;

  Future<void> _searchCustomer(String search) async {
    final searchLower = search.toLowerCase();
    final result = orig.where((element) {
      final obj = element.getObj();
      return obj.firstName.toLowerCase().contains(searchLower) ||
          obj.lastName.toLowerCase().contains(searchLower);
    }).toList();
    customers.add(result);
  }

  TextEditingController searchController = TextEditingController();

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
            Row(
              children: [
                Container(
                    height: 50,
                    width: 230,
                    child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Suche..."))),
                IconButton(
                    onPressed: () {
                      _searchCustomer(searchController.text);
                    },
                    icon: Icon(Icons.search)),
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
            Expanded(child: CustomerList(customers))
          ],
        ),
      ),
    );
  }
}
