import 'package:flutter/material.dart';
import '../../services/app.dart';

class ReadyToPlayTransaction extends StatelessWidget {
  
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
     
      body: Stack(
        children: <Widget>[
          Container (
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver,),
                image: AssetImage('assets/imgs/pictures/ready_to_play.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(top: 10.0, bottom: 100.0),
              
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  
                  Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 5.0),
                    child: Text(
                      "Ready to Play?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0, 
                        fontWeight: FontWeight.w600,
                      )
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                    child: Text(
                      "Are you ready to become a professional guitar player?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      )
                    ),
                  ),
                  
                  Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(top: 30.0, right: 10),
                    child: SizedBox(
                      child: RaisedButton(
                        onPressed: () async {
                          bool status;
                          status = await App.getAllCourses();
                          status = await App.studyingCourses();
                          status = await App.quicklessons();
                          status = await App.freelesson();
                          
                          status == true
                          ? Navigator.popAndPushNamed(context, "/start_loading")
                          : Navigator.pop(context);
                        },
                        color: Color.fromRGBO(107, 43, 20, 1.0),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                        child: Text("Start now",style: TextStyle( fontSize: 16.0))
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ),
        ],
      )
    );
    
  }

}       