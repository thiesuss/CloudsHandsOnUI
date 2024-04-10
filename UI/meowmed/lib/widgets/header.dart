import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(this.title, this.actions, {bool this.disableArrow = false});
  String title;
  List<Widget> actions;
  bool disableArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
      height: 35,
      child: Hero(
        tag: "SiteTitle",
        flightShuttleBuilder: flightShuttleBuilder,
        child: Text(
          title,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Widget flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}
