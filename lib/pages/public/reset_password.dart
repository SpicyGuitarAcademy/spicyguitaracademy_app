import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  ResetPasswordPageState createState() => new ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _pass = TextEditingController();
  TextEditingController _cpass = TextEditingController();

  // properties
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
              'Reset Password',
              style: TextStyle(
                  color: brown,
                  fontSize: 30,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal),
            ),
            elevation: 0,
          ),
          body: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text('Choose another password that you can remember.',
                    textAlign: TextAlign.center),
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
                SizedBox(height: 20.0),
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
                  'Your secured password must contain lessters, numbers and must be atleast 8 characters long.',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).copyWith().size.width,
                  child: RaisedButton(
                    onPressed: () {
                      resetpassword(student);
                    },
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        side: BorderSide(color: brown)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Reset", style: TextStyle(fontSize: 20.0)),
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

  void resetpassword(Student student) async {
    try {
      loading(context);

      var resp = await student.resetPassword(_pass.text, _cpass.text);

      Navigator.pop(context);

      if (resp['status'] == true) {
        Navigator.pop(context);
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
        }
        throw Exception("$msg");
      }
    } catch (e) {
      error(context, stripExceptions(e), title: "Reset Password failed");
    }
  }
}
