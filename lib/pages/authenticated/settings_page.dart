import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  // properties
  List<Widget> _searchResult = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: IconThemeData(color: brown),
        backgroundColor: grey,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
              color: brown,
              fontSize: 30,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Column(
          children: _searchResult,
        )
      ])),
    );
  }
}
