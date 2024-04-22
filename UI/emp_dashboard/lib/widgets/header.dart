import 'package:flutter/material.dart';
import 'package:meowmed/widgets/garten.dart';

class Header extends StatelessWidget {
  Header(this.title, this.actions, {bool this.disableArrow = false});
  String title;
  List<Widget> actions;
  bool disableArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kDefaultMarginSmall, bottom: kDefaultMargin),
      child: Row(
        children: [
          Hero(
            tag: "SiteTitle",
            flightShuttleBuilder: flightShuttleBuilder,
            child: Text(
              title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Container()),
          ...actions,
          SizedBox(width: 10),
          logo,
        ],
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
