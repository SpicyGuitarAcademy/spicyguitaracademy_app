import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

void loading(BuildContext context, {String message: 'Loading'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
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

void message(BuildContext context, String message, {String title: 'Message'}) {
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.lightBlueAccent),
            SizedBox(width: 2.0),
            Text("$title", style: TextStyle(color: Colors.lightBlueAccent)),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        content: Column(
          children: [
            Text(message, style: TextStyle(color: Colors.lightBlueAccent)),
          ],
        ),
        backgroundColor: Colors.white,
        // actions: [
        //   MaterialButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     child: Text('Ok'),
        //   )
        // ],
      );
    },
  );
}

void success(BuildContext context, String message, {String title: 'Message'}) {
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Row(
          children: [
            Icon(Icons.done, color: brown),
            SizedBox(width: 2.0),
            Text("$title", style: TextStyle(color: brown)),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        content: Text(message, style: TextStyle(color: brown)),
        backgroundColor: Colors.white,
        // actions: [
        //   MaterialButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     child: Text('Ok'),
        //   )
        // ],
      );
    },
  );
}

void error(BuildContext context, String message,
    {String title: 'Unknown Error'}) {
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 2.0),
            Text("$title", style: TextStyle(color: Colors.red)),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        content: Text(message, style: TextStyle(color: Colors.red)),
        backgroundColor: Colors.white,
        // actions: [
        //   MaterialButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     child: Text('Ok'),
        //   )
        // ],
      );
    },
  );
  // SnackBar(
  //   content: Text(message, style: TextStyle(color: Colors.red)),
  //   backgroundColor: Colors.white
  // );
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
        title: Row(
          children: [
            // Icon(Icons.done, color: brown),
            // SizedBox(width: 2.0),
            // Text("$title", style: TextStyle(color: brown)),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
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
