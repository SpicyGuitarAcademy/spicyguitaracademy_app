import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:url_launcher/url_launcher.dart';

class CashOutSpicyUnitsPage extends StatefulWidget {
  @override
  CashOutSpicyUnitsPageState createState() => new CashOutSpicyUnitsPageState();
}

class CashOutSpicyUnitsPageState extends State<CashOutSpicyUnitsPage> {
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
            'Cash out Spicy Units',
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
                SizedBox(height: 20.0),
                Icon(Icons.phone, size: 70, color: brown),
                SizedBox(height: 20.0),
                Text(
                  'The value of ${student.referralUnits ?? 0} units is equivalent to ${student.referralUnits ?? 0} Nigerian Naira.\n\n' +
                      'Your bonus Spicy Units would be sent to your Nigerian bank accounts when you request to cash out.\n\n' +
                      'To cash out your Spicy Units, Call or Chat either of the numbers below via WhatsApp.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('tel:+2348057809884')) {
                          await launch(
                            'tel:+2348057809884',
                          );
                        } else {
                          snackbar(context, 'Could not open +234 805 780 9884');
                        }
                      },
                      child: Text(
                        "+234 805 780 9884, ",
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
                        "+234 807 615 9020",
                        style: TextStyle(color: brown),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
