import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactForSpicyUnitsPage extends StatefulWidget {
  @override
  ContactForSpicyUnitsPageState createState() =>
      new ContactForSpicyUnitsPageState();
}

class ContactForSpicyUnitsPageState extends State<ContactForSpicyUnitsPage> {
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
            'Buy more Spicy Units',
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
                  'You get 2% Bonus when you purchase Spicy Units. \n\n' +
                      'You can purchase Spicy Units with local Bank transfers or USSD Code\n\n' +
                      'You can purchase Spicy Units with either: Crypto Currency, Chipper Cash, Skrill\n\n' +
                      'Call or Send a WhatsApp message to any of the numbers below to buy more Spicy Units',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('tel:+2348173165202')) {
                          await launch(
                            'tel:+2348173165202',
                          );
                        } else {
                          snackbar(context, 'Could not open +234 817 316 5202');
                        }
                      },
                      child: Text(
                        "+234 817 316 5202, ",
                        style: TextStyle(color: brown),
                      ),
                    ),
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
                        "+234 805 780 9884",
                        style: TextStyle(color: brown),
                      ),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      "+234 807 615 9020, ",
                      style: TextStyle(color: brown),
                    ),
                  ),
                ]),
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
