import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:clipboard/clipboard.dart';

class InviteFriend extends StatefulWidget {
  @override
  InviteFriendState createState() => new InviteFriendState();
}

class InviteFriendState extends State<InviteFriend> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();

    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          iconTheme: IconThemeData(color: brown),
          backgroundColor: grey,
          centerTitle: true,
          title: Text(
            'Invite a friend',
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
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Spicy text

                      SizedBox(height: 30),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/imgs/icons/spicyunit.svg",
                            width: 30,
                            matchTextDirection: true,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '${student.referralUnits} Spicy Units',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: brown),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invitation Code',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(width: 7),
                          student.referralCode == ''
                              ? ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      loading(context, message: 'Requesting');
                                      await student.requestReferralCode();
                                      Navigator.pop(context);
                                    } catch (e) {
                                      Navigator.pop(context);
                                      error(context, stripExceptions(e));
                                    }
                                  },
                                  child: Text(
                                    'Request Code',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : TextButton(
                                  child: Text(
                                    '${student.referralCode}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                            '${student.referralCode}')
                                        .then(
                                      (value) => snackbar(
                                        context,
                                        "Invitation code copied!",
                                        timeout: 10,
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                      SizedBox(height: 30),

                      Text(
                        "Hi ${student.firstname}, Enter the email address of your friend and we'll send him/her an invitation mail with your invite code.",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: darkgrey, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You receive Spicy Units whenever your friend Subscribes or buys a Featured Course.",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: darkgrey, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You can use your Spicy Units to buy Featured Courses you find interesting.",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: darkgrey, fontSize: 18),
                      ),
                      SizedBox(height: 30),

                      // text box for entering emails adresses
                      TextField(
                        controller: _email,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: 20.0, color: brown),
                        decoration: InputDecoration(
                          hintText: "Email Address",
                        ),
                      ),

                      SizedBox(height: 30),

                      // invite btn
                      Container(
                        width: screen(context).width,
                        height: 60,
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/imgs/icons/invite_friend_icon.svg",
                                matchTextDirection: true,
                                color: white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "invite friend",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            try {
                              loading(context, message: 'Sending');
                              var resp = await request(
                                  '/api/student/invite-a-friend',
                                  method: 'POST',
                                  headers: {
                                    'JWToken': Auth.token!,
                                    'cache-control':
                                        'max-age=0, must-revalidate'
                                  },
                                  body: {
                                    'friend': _email.text
                                  });
                              Navigator.pop(context);
                              if (resp['status'] == false) {
                                error(context, resp['message']);
                              } else {
                                _email.clear();
                                success(context, resp['message']);
                              }
                            } on AuthException catch (e) {
                              error(context, stripExceptions(e));
                              // reAuthenticate(context);
                            } catch (e) {
                              error(context, stripExceptions(e));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
