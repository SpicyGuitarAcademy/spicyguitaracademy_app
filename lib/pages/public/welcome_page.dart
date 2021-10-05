import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (context, student, child) {
      try {
        student.signinWithCachedData();
      } catch (e) {
        error(context, stripExceptions(e));
      }

      return new Scaffold(
          backgroundColor: Color.fromRGBO(107, 43, 20, 0.5),
          body: Stack(children: <Widget>[
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    // Colors.accents,
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(1.0)
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.srcOver,
              child: Container(
                decoration: BoxDecoration(
                  // color: brown,
                  image: DecorationImage(
                    image:
                        AssetImage('assets/imgs/pictures/welcome_picture.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment(-0.5, 6.0),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 10.0, bottom: 100.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text("Hi, Welcome to Spicy Guitar Academy",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0))),
                  Auth.authenticated == false
                      ? Column(
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).copyWith().size.width -
                                      30.0,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/login");
                                },
                                color: Colors.transparent,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.white)),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Login",
                                    style: TextStyle(fontSize: 20.0)),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width:
                                  MediaQuery.of(context).copyWith().size.width -
                                      30.0,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/register");
                                },
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.white)),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Signup",
                                    style: TextStyle(fontSize: 20.0)),
                              ),
                            ),
                          ],
                        )
                      : Column(children: [
                          Container(
                            width:
                                MediaQuery.of(context).copyWith().size.width -
                                    30.0,
                            child: RaisedButton(
                              onPressed: () async {
                                try {
                                  loading(context);
                                  await student.signinWithCachedData(
                                      handleClick: true);

                                  dynamic resp = await student.verifyDevice();
                                  if (resp['status'] == false) {
                                    error(context, resp['message']);
                                    Navigator.pushNamed(
                                        context, '/verify-device');
                                  }

                                  Navigator.pop(context);
                                  if (student.status != 'active') {
                                    Navigator.pushNamed(context, "/verify");
                                  } else {
                                    Navigator.pushNamed(
                                        context, "/welcome_note");
                                  }
                                } catch (e) {
                                  Navigator.pop(context);
                                  error(context, stripExceptions(e));
                                }
                              },
                              color: Colors.transparent,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.white)),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                  "Continue as ${student.firstname ?? 'Guest'}",
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width:
                                MediaQuery.of(context).copyWith().size.width -
                                    30.0,
                            child: ElevatedButton(
                              onPressed: () {
                                student.signout();
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 10),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text("Logout",
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          )
                        ])
                ],
              ),
            )
          ]));
    });
  }
}
