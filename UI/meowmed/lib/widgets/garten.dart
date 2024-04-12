import 'package:flutter/material.dart';

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

final dataTableHeading = TextStyle(fontWeight: FontWeight.bold);
final dataTableBorder = TableBorder(
    borderRadius: BorderRadius.circular(10),
    top: BorderSide(),
    horizontalInside: BorderSide(),
    verticalInside: BorderSide(),
    bottom: BorderSide(),
    left: BorderSide(),
    right: BorderSide());

final logo = Container(
  width: 350,
  height: 50,
  child: Image(
    image: AssetImage('assets/images/MeowcroservicesLogoNew.png'),
  ),
);

String dateTimeToString(DateTime dateTime) {
  return "${dateTime.day}.${dateTime.month}.${dateTime.year}";
}

ExpansionTile buildErrorTile(String title, String error) {
  return ExpansionTile(
    leading: Icon(
      Icons.error,
      color: Colors.redAccent,
    ),
    title: Text(title),
    children: [
      Text(error),
    ],
  );
}

const double kDefaultPadding = 20.0;
const double kDefaultPaddingSmall = 10.0;
const double kDefaultMargin = 20.0;
const double kDefaultMarginSmall = 10.0;
const double kDefaultSitePadding = 30.0;
