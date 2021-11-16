import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';

void loading(BuildContext context, {String message: 'Loading'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(darkbrown),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text("$message..."),
          ],
        ),
      );
    },
  );
}

void message(BuildContext context, String message) {
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.error, color: brown),
        ),
        content: Text(
          message,
          style: TextStyle(color: brown),
        ),
        backgroundColor: Colors.white,
      );
    },
  );
}

void success(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.check_circle, color: brown),
        ),
        content: Text(
          message,
          style: TextStyle(color: brown),
        ),
        backgroundColor: Colors.white,
      );
    },
  );
}

void error(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.error, color: Colors.red),
        ),
        content: Text(
          // Utf8Decoder(allowMalformed: true).convert(codeUnits)
          parseHtmlString(message),
          // .convert(message),
          // message,
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
      );
    },
  );
}

void snackbar(BuildContext context, String message, {int timeout = 5}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: timeout),
      action: SnackBarAction(
          label: 'dismiss', textColor: Colors.white, onPressed: () {}),
    ),
  );
}

void action(BuildContext context, String message, {String title: ''}) {
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        content: Text(message, style: TextStyle(color: brown)),
        backgroundColor: Colors.white,
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          )
        ],
      );
    },
  );
}
