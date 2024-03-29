import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // properties
  bool _obscurePwd = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<Student>(
        builder: (BuildContext context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (context, studentStats, child) {
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                iconTheme: IconThemeData(color: brown),
                backgroundColor: grey,
                centerTitle: true,
                title: Text(
                  'Login',
                  style: TextStyle(
                      color: brown,
                      fontSize: 30,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal),
                ),
                elevation: 0,
              ),
              body: SafeArea(
                  minimum: EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        SizedBox(height: 40.0),

                        // Email field
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(fontSize: 20.0, color: brown),
                          decoration: InputDecoration(
                              labelText: "Email Address",
                              hintText: "yourname@domain.com"),
                        ),

                        SizedBox(height: 20.0),

                        // Password field
                        TextFormField(
                            controller: _pass,
                            obscureText: _obscurePwd,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            autofillHints: [AutofillHints.password],
                            style: TextStyle(fontSize: 20.0, color: brown),
                            decoration: InputDecoration(
                                labelText: "Password",
                                suffix: IconButton(
                                    onPressed: () => setState(() {
                                          _obscurePwd = !_obscurePwd;
                                        }),
                                    icon: Icon(_obscurePwd == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined)))),

                        SizedBox(height: 40.0),

                        Container(
                          width: MediaQuery.of(context).copyWith().size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              login(student, studentSubscription, studentStats);
                            },
                            child: Text("Login"),
                          ),
                        ),

                        SizedBox(height: 20.0),

                        Row(
                          // alignment: Alignment.centerLeft,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: brown),
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/forgot_password');
                                },
                                child: Text(
                                  'Forgot Password',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: brown),
                                ))
                          ],
                        )
                      ]))));
        });
      });
    });
  }

  void login(Student student, StudentSubscription studentSubscription,
      StudentStudyStatistics studentStats) async {
    try {
      loading(context);

      await student.signin(_email.text, _pass.text);
      _pass.text = "";

      dynamic resp = await student.verifyDevice();

      if (resp['status'] == false) {
        error(context, resp['message']);
        Navigator.pushNamed(context, '/verify-device');
      } else {
        await studentSubscription.getStudentSubscriptionStatus();
        await studentStats.getStudentCategoryAndStats(studentSubscription);

        Navigator.pop(context);
        if (student.status != 'active') {
          Navigator.pushNamed(context, "/verify");
        } else {
          if (Auth.reAuthenticate == true) {
            Auth.reAuthenticate = false;
            Navigator.pop(context);
          } else {
            Navigator.pushNamed(context, "/welcome_note");
          }
        }
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e), title: 'Login failed');
    }
  }
}
