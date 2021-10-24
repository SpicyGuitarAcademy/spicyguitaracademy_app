import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _cpass = TextEditingController();
  TextEditingController _refCode = TextEditingController();

  // properties
  bool _agreeToTermsAndCondition = false;
  bool _obscurePwd = true;
  bool _obscureCPwd = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            iconTheme: IconThemeData(color: brown),
            backgroundColor: grey,
            centerTitle: true,
            title: Text(
              'Create Account',
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

                // Firstname field
                TextField(
                  controller: _fname,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration: InputDecoration(
                    labelText: "First Name",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Lastname field
                TextField(
                  controller: _lname,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration: InputDecoration(
                    labelText: "Last Name",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Email field
                TextField(
                  controller: _email,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration: InputDecoration(
                      labelText: "Email Address",
                      hintText: "yourname@domain.com"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Telephone field
                TextField(
                  controller: _tel,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration:
                      InputDecoration(labelText: "Telephone", hintText: "+234"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Password field
                TextField(
                    controller: _pass,
                    obscureText: _obscurePwd,
                    textInputAction: TextInputAction.next,
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
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                    controller: _cpass,
                    obscureText: _obscureCPwd,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 20.0, color: brown),
                    decoration: InputDecoration(
                        labelText: "Confirm Password",
                        suffix: IconButton(
                            onPressed: () => setState(() {
                                  _obscureCPwd = !_obscureCPwd;
                                }),
                            icon: Icon(_obscureCPwd == true
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined)))),
                Text(
                  'Password must contain letters, numbers and must be atleast 8 characters.',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Referral Code
                TextField(
                  controller: _refCode,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration: InputDecoration(
                      labelText: "Invite Code (optional)",
                      hintText: "Enter your invite code"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
                  Checkbox(
                    onChanged: (value) => setState(() {
                      _agreeToTermsAndCondition = !_agreeToTermsAndCondition;
                    }),
                    checkColor: Colors.white,
                    activeColor: brown,
                    value: _agreeToTermsAndCondition,
                  ),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/terms_and_condition");
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("I have carefully read and agreed to the"),
                              InkWell(
                                onTap: () async {
                                  if (await canLaunch(
                                      'https://spicyguitaracademy.com/terms')) {
                                    await launch(
                                      'https://spicyguitaracademy.com/terms',
                                      enableJavaScript: true,
                                      enableDomStorage: true,
                                    );
                                  } else {
                                    snackbar(context,
                                        'Could not launch the URL https://spicyguitaracademy.com/terms');
                                  }
                                },
                                child: Text("Terms and Conditions",
                                    style: TextStyle(color: brown)),
                              ),
                            ],
                          )))
                ]),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).copyWith().size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      register(student);
                    },
                    child: Text("Signup"),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            )),
          ));
    });
  }

  void register(Student student) async {
    try {
      loading(context);

      if (_agreeToTermsAndCondition == false) {
        throw Exception('Please agree to the Terms and Condition.');
      }

      var resp = await student.signup(_fname.text, _lname.text, _email.text,
          _tel.text, _pass.text, _cpass.text, _refCode.text);

      if (resp['status'] == true) {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, "/verify");
        success(context, 'Registeration Successful');
      } else {
        Map<String, dynamic> data = {};
        String msg = "";
        if (resp['data'] != null) {
          data = resp['data'];
          int count = 1;
          data.forEach((key, value) {
            msg += "$count. $value\n";
            count++;
          });
        } else {
          msg = resp['message'];
        }
        throw Exception("$msg");
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }
}
