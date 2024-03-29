import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  ContactUsPageState createState() => new ContactUsPageState();
}

class ContactUsPageState extends State<ContactUsPage> {
  // properties
  TextEditingController _subject = TextEditingController();
  TextEditingController _message = TextEditingController();

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
            'Contact Us',
            style: TextStyle(
                color: brown,
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.normal),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'You can reach us with the form below if you have any inquiry or encounter any issue. Or you can send a mail to',
                  // textAlign: TextAlign.center,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () async {
                      if (await canLaunch(
                          'mailto:info@spicyguitaracademy.com')) {
                        await launch(
                          'mailto:info@spicyguitaracademy.com',
                        );
                      } else {
                        snackbar(context,
                            'Could not open info@spicyguitaracademy.com');
                      }
                    },
                    child: Text(
                      "info@spicyguitaracademy.com",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: brown),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('Or call: ', textAlign: TextAlign.center),
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('tel:+2348169000486')) {
                          await launch(
                            'tel:+2348169000486',
                          );
                        } else {
                          snackbar(context, 'Could not open +2348169000486');
                        }
                      },
                      child: Text(
                        "+2348169000486, ",
                        style: TextStyle(color: brown),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('tel:+2347080861654')) {
                          await launch(
                            'tel:+2347080861654',
                          );
                        } else {
                          snackbar(context, 'Could not open +2347080861654');
                        }
                      },
                      child: Text(
                        "+2347080861654, ",
                        style: TextStyle(color: brown),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('tel:+2348076159020')) {
                          await launch(
                            'tel:+2348076159020',
                          );
                        } else {
                          snackbar(context, 'Could not open +2348076159020');
                        }
                      },
                      child: Text(
                        "+2348076159020",
                        style: TextStyle(color: brown),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),

                // Email field
                TextField(
                  controller: _subject,
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    contactUs(student);
                  },
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration:
                      InputDecoration(labelText: "Subject", hintText: ""),
                ),
                SizedBox(height: 20.0),
                // Email field
                TextField(
                  controller: _message,
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  maxLines: 3,
                  onSubmitted: (value) {
                    contactUs(student);
                  },
                  style: TextStyle(fontSize: 20.0, color: brown),
                  decoration: InputDecoration(
                      labelText: "Message", hintText: "Write your message..."),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).copyWith().size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      contactUs(student);
                    },
                    child: Text("Submit"),
                  ),
                ),

                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      );
    });
  }

  void contactUs(Student student) async {
    try {
      loading(context, message: 'Sending');

      var resp = await request('/api/contactus', method: 'POST', body: {
        'email': student.email,
        'subject': _subject.text,
        'message': _message.text
      });

      Navigator.pop(context);
      if (resp['status'] == true) {
        success(context, resp['message']);
        _message.text = "";
        _subject.text = "";
      } else {
        throw Exception(resp['message']);
      }
    } catch (e) {
      error(context, stripExceptions(e), title: 'Request failed');
    }
  }
}
