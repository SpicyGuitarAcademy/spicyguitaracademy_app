import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class VerifyDevicePage extends StatefulWidget {
  @override
  VerifyDevicePageState createState() => new VerifyDevicePageState();
}

class VerifyDevicePageState extends State<VerifyDevicePage> {
  // properties
  TextEditingController _token = TextEditingController();

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
              'Verify Device',
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

                    Text(
                        'A 6 digit verification token has been sent to your email.'),
                    SizedBox(height: 20.0),

                    // Email field
                    TextField(
                      controller: _token,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 20.0, color: brown),
                      decoration: InputDecoration(
                          labelText: "Authentication Token",
                          hintText: "******"),
                    ),

                    SizedBox(height: 40.0),

                    Container(
                      width: MediaQuery.of(context).copyWith().size.width,
                      child: RaisedButton(
                        onPressed: () {
                          verify(student);
                        },
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: brown)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Verify", style: TextStyle(fontSize: 20.0)),
                      ),
                    ),
                  ]))));
    });
  }

  void verify(Student student) async {
    try {
      loading(context, message: 'Verifying');

      var resp = await student.resetDevice(_token.text);

      if (resp == true) {
        Navigator.pop(context);

        // if (student.hasForgottenPassword == true) {
        //   Navigator.popAndPushNamed(context, "/resetpassword");
        // } else if (student.isNewStudent == true) {
        //   Navigator.popAndPushNamed(context, "/login");
        // } else {
        //   Navigator.popAndPushNamed(context, "/welcome_note");
        // }
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
      error(context, stripExceptions(e), title: 'Verification failed');
    }
  }
}
