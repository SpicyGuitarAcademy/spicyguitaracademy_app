import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';

class HelpPage extends StatefulWidget {
  @override
  HelpPageState createState() => new HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey,
        appBar: AppBar(
          toolbarHeight: 70,
          iconTheme: IconThemeData(color: brown),
          backgroundColor: grey,
          centerTitle: true,
          title: Text(
            'FAQs',
            style: TextStyle(
                color: brown,
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.normal),
          ),
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              SizedBox(height: 20),
              Container(
                  width: screen(context).width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/helpdetail',
                          arguments: {'index': 0});
                    },
                    child: Text(
                        'Questions about learning the Guitar at Spicy Guitar Academy',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)),
                  )),
              SizedBox(height: 10),
              Container(
                  width: screen(context).width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/helpdetail',
                          arguments: {'index': 1});
                    },
                    child: Text(
                        'Questions about Spicy Guitar Academy Mobile Application',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)),
                  )),
              SizedBox(height: 10),
              Container(
                  width: screen(context).width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/helpdetail',
                          arguments: {'index': 2});
                    },
                    child: Text('Questions about playing the Guitar',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)),
                  )),
            ])));
  }
}
