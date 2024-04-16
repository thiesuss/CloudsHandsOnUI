import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  RoundedBox({super.key, required this.widget});
  Widget widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(70))),
          child: widget,
    );
  }
}
