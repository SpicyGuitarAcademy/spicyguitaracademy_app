import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';

class ChoosePlan extends StatefulWidget {
  @override
  ChoosePlanState createState() => new ChoosePlanState();
}

class ChoosePlanState extends State<ChoosePlan> {
  // properties
  String? _selectedPlan;

  @override
  void initState() {
    super.initState();
    initiatePage();
  }

  Future initiatePage() async {
    StudentSubscription studentSubscription =
        context.read<StudentSubscription>();

    _selectedPlan = studentSubscription.subscriptionPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<Subscription>(
          builder: (BuildContext context, subscription, child) {
        return Consumer<StudentSubscription>(
            builder: (BuildContext context, studentSubscription, child) {
          return new Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              iconTheme: IconThemeData(color: brown),
              backgroundColor: grey,
              centerTitle: true,
              title: Text(
                'Choose a Plan',
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: screen(context).width * 0.4,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 30,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![0]['plan_id']
                                    ? brown
                                    : white,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![0]['plan_id']
                                    ? white
                                    : brown,
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: brown,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () =>
                                studentSubscription.isSubscribed == false
                                    ? setState(() => _selectedPlan =
                                        subscription.plans![0]['plan_id'])
                                    : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("NGN ${subscription.plans![0]['price']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: SvgPicture.asset(
                                    "assets/imgs/icons/1MS_icon.svg",
                                    matchTextDirection: true,
                                  ),
                                ),
                                Text(subscription.plans![0]['plan'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screen(context).width * 0.4,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 30,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![1]['plan_id']
                                    ? brown
                                    : white,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![1]['plan_id']
                                    ? white
                                    : brown,
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: brown,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () =>
                                studentSubscription.isSubscribed == false
                                    ? setState(() => _selectedPlan =
                                        subscription.plans![1]['plan_id'])
                                    : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("NGN ${subscription.plans![1]['price']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: SvgPicture.asset(
                                    "assets/imgs/icons/3MS_icon.svg",
                                    matchTextDirection: true,
                                  ),
                                ),
                                Text(subscription.plans![1]['plan'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 30.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: screen(context).width * 0.4,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 30,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![2]['plan_id']
                                    ? brown
                                    : white,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![2]['plan_id']
                                    ? white
                                    : brown,
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: brown,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () =>
                                studentSubscription.isSubscribed == false
                                    ? setState(() => _selectedPlan =
                                        subscription.plans![2]['plan_id'])
                                    : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("NGN ${subscription.plans![2]['price']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: SvgPicture.asset(
                                    "assets/imgs/icons/6MS_icon.svg",
                                    matchTextDirection: true,
                                  ),
                                ),
                                Text(subscription.plans![2]['plan'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screen(context).width * 0.4,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 30,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![3]['plan_id']
                                    ? brown
                                    : white,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                _selectedPlan ==
                                        subscription.plans![3]['plan_id']
                                    ? white
                                    : brown,
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: brown,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () =>
                                studentSubscription.isSubscribed == false
                                    ? setState(() => _selectedPlan =
                                        subscription.plans![3]['plan_id'])
                                    : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("NGN ${subscription.plans![3]['price']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: SvgPicture.asset(
                                    "assets/imgs/icons/1YS_icon.svg",
                                    matchTextDirection: true,
                                  ),
                                ),
                                Text(subscription.plans![3]['plan'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 50),

                    studentSubscription.isSubscribed == false
                        // && Student.isLoaded == false
                        ? Container(
                            width: screen(context).width, // * 0.8,
                            child: Text(
                              "Tap Continue to watch free lessons or to buy Special Courses.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 0.6),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0),
                              strutStyle: StrutStyle(
                                fontSize: 20.0,
                                height: 1.3,
                              ),
                            ),
                          )
                        : SizedBox(height: 30),

                    SizedBox(height: 10),

                    // if student subscription is expired, offer free
                    studentSubscription.isSubscribed == false
                        // && Student.isLoaded == false
                        ? Container(
                            width: screen(context).width - 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.all(darkgrey),
                                foregroundColor:
                                    MaterialStateProperty.all(brown),
                                backgroundColor:
                                    MaterialStateProperty.all(white),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/ready_to_play");
                              },
                              child: Text("Continue to FREE",
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          )
                        : Container(),

                    SizedBox(height: 50),

                    studentSubscription.isSubscribed == false
                        ? Container(
                            width: screen(context).width - 40,
                            child: ElevatedButton(
                                onPressed: _selectedPlan == "0"
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                            context, "/complete_payment",
                                            arguments: {
                                              'type': 'subscription',
                                              'plan': _selectedPlan
                                            });
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Payment Method"),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward_rounded)
                                  ],
                                )),
                          )
                        : Container(),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        });
      });
    });
  }
}
