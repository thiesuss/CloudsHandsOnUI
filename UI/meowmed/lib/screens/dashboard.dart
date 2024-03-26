import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meowmed/data/models/cachedObj.dart';
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
  List<CachedObj<CustomerRes>> orig = [
    CachedObj<CustomerRes>(
      "1",
      CustomerRes(
          id: "1",
          familyStatus: CustomerResFamilyStatusEnum.geschieden,
          birthDate: DateTime.now(),
          socialSecurityNumber: "1234567890",
          taxId: "1234567890",
          jobStatus: CustomerResJobStatusEnum.arbeitslos,
          bankDetails: BankDetails(iban: "asd", bic: "ad", name: "asd"),
          firstName: "Max",
          lastName: "Mustermann",
          address: Address(
              city: "Musterstadt",
              houseNumber: "1",
              street: "Musterstraße",
              zipCode: 12345)),
    ),
  ];

  @override
  void initState() {
    customers = BehaviorSubject.seeded([
      orig[0],
    ]);
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
                Container(height: 15, width: 60, color: Colors.red),
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
