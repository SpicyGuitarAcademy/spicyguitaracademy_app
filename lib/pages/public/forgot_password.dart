import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordPageState createState() => new ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // properties
  TextEditingController _email = TextEditingController();

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
              'Forget Password',
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
                    TextField(
                      controller: _email,
                      autofocus: true,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        forgotPassword(student);
                      },
                      style: TextStyle(fontSize: 20.0, color: brown),
                      decoration: InputDecoration(
                          labelText: "Email Address",
                          hintText: "email@address.com"),
                    ),

                    SizedBox(height: 40.0),

                    Container(
                      width: MediaQuery.of(context).copyWith().size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          forgotPassword(student);
                        },
                        child: Text("Submit"),
                      ),
                    ),

                    SizedBox(height: 20.0),
                  ]))));
    });
  }

  void forgotPassword(Student student) async {
    try {
      loading(context);

      var resp = await student.forgotPassword(_email.text);

      Navigator.pop(context);
      if (resp['status'] == true) {
        Navigator.popAndPushNamed(context, "/verify");
      } else {
        throw Exception(resp['message']);
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }
}
