import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class LoadingButton extends StatefulWidget {
  LoadingButton({required this.label, required this.onPressed});

  String label;
  Future<void> Function() onPressed;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }
    return TextButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          widget.onPressed().onError((error, stackTrace) {
            setState(() {
              _isLoading = false;
              _isError = true;
              Logger().e(error.toString());
              Logger().e(stackTrace.toString());
            });
          }).then((value) {
            setState(() {
              _isLoading = false;
              _isError = false;
            });
          });
        },
        child: Text(widget.label),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              _isError ? Colors.red : Colors.transparent),
        ));
  }
}
