import 'package:flutter/material.dart';
import 'package:meowmed/data/services/logger.dart';

class LogPage extends StatefulWidget {
  LogPage();

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final search = TextEditingController();

  @override
  void initState() {
    logMessages = LogHandler().logMessages.reversed.toList();
    super.initState();
  }

  late List<String> logMessages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8),
        child: ListView(
          children: [
            Container(), // TODO: Replace
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search",
                        fillColor: Colors.transparent,
                      ),
                      controller: search,
                      onEditingComplete: () {
                        final logList =
                            LogHandler().logMessages.reversed.toList();
                        final searchText = search.text;
                        final filteredList = logList
                            .where((element) => element
                                .toLowerCase()
                                .contains(searchText.toLowerCase()))
                            .toList();
                        setState(() {
                          logMessages = filteredList;
                        });
                      },
                    ),
                  ),
                  Text(logMessages.length.toString())
                ],
              ),
            ),
            ...logMessages.reversed.map((e) => Container(
                  child: Text(e, style: TextStyle(fontSize: 10)),
                ))
          ],
        ),
      ),
    );
  }
}
