import 'package:flutter/material.dart';
import 'dart:async';

class StartLoading extends StatefulWidget {
  
  @override
  StartLoadingState createState() => new StartLoadingState();
}

class StartLoadingState extends State<StartLoading> {

  @override
  void initState() {
    super.initState();
    
    _initializeTimer();
  }

  void _initializeTimer() {
    // push to new root page
    Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(context, "/dashboard"));
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            
            Image.asset("assets/imgs/icons/loading_icon.png"),
            
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: Text(
                "Loading...",
                style: TextStyle(
                  color: Color.fromRGBO(107, 43, 20, 1.0),
                  fontSize: 20
                ),
              )
            )
            
          ],
        ),
      ),
    );
  }

}