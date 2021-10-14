import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

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
    // final Map args = ModalRoute.of(context).settings.arguments as Map;
    // _selectedPlan = args['selectedplan'];

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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![0]
                                                    ['plan_id']
                                            ? brown
                                            : white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![0]
                                                    ['plan_id']
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
                                    onPressed: () => studentSubscription
                                                .isSubscribed ==
                                            false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![1]['plan_id'])
                                        : null,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                            "NGN ${subscription.plans![1]['price']}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600)),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![1]
                                                    ['plan_id']
                                            ? brown
                                            : white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![1]
                                                    ['plan_id']
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
                                    onPressed: () => studentSubscription
                                                .isSubscribed ==
                                            false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![1]['plan_id'])
                                        : null,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                            "NGN ${subscription.plans![1]['price']}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600)),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![2]
                                                    ['plan_id']
                                            ? brown
                                            : white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![2]
                                                    ['plan_id']
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
                                    onPressed: () => studentSubscription
                                                .isSubscribed ==
                                            false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![2]['plan_id'])
                                        : null,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                            "NGN ${subscription.plans![2]['price']}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600)),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![3]
                                                    ['plan_id']
                                            ? brown
                                            : white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        _selectedPlan ==
                                                subscription.plans![3]
                                                    ['plan_id']
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
                                    onPressed: () => studentSubscription
                                                .isSubscribed ==
                                            false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![3]['plan_id'])
                                        : null,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                            "NGN ${subscription.plans![3]['price']}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600)),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
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

                            SizedBox(height: 20.0),

                            studentSubscription.isSubscribed == false
                                // && Student.isLoaded == false
                                ? Container(
                                    width: screen(context).width, // * 0.8,
                                    child: Text(
                                      "Tap Continue to watch free lessons or to buy Special Courses.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              112, 112, 112, 0.6),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                      strutStyle: StrutStyle(
                                        fontSize: 20.0,
                                        height: 1.3,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 30.0,
                                  ),

                            SizedBox(height: 20.0),

                            studentSubscription.isSubscribed == false
                                ? Container(
                                    width: screen(context).width, // - 40,
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: _selectedPlan == "0"
                                              ? null
                                              : () async {
                                                  try {
                                                    loading(context);
                                                    await subscription
                                                        .initiateSubscriptionPayment(
                                                            _selectedPlan!,
                                                            student,
                                                            'paystack');
                                                    Navigator.pop(context);

                                                    // complete payment with paystack
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/pay_with_paystack',
                                                      arguments: {
                                                        'type': 'subscription'
                                                      },
                                                    );
                                                  } catch (e) {
                                                    Navigator.pop(context);
                                                    error(context,
                                                        stripExceptions(e));
                                                  }
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.credit_card,
                                                  size: 25.0),
                                              SizedBox(width: 10.0),
                                              Text("Pay with PayStack",
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: _selectedPlan == "0"
                                              ? null
                                              : () async {
                                                  try {
                                                    loading(context);
                                                    await subscription
                                                        .initiateSubscriptionPayment(
                                                            _selectedPlan!,
                                                            student,
                                                            'paypal');
                                                    Navigator.pop(context);

                                                    // complete payment with paystack
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/pay_with_paypal',
                                                      arguments: {
                                                        'type': 'subscription'
                                                      },
                                                    );
                                                  } catch (e) {
                                                    Navigator.pop(context);
                                                    error(context,
                                                        stripExceptions(e));
                                                  }
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(CupertinoIcons.money_dollar,
                                                  size: 25.0),
                                              SizedBox(width: 10.0),
                                              Text("Pay with PayPal",
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),

                            SizedBox(height: 20),

                            // if student subscription is expired, offer free
                            studentSubscription.isSubscribed == false
                                // && Student.isLoaded == false
                                ? Container(
                                    width: screen(context).width - 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/ready_to_play");
                                      },
                                      child: Text("Continue",
                                          style: TextStyle(fontSize: 20.0)),
                                    ),
                                  )
                                : Container(),

                            SizedBox(height: 40),
                          ]))));
        });
      });
    });
  }
}

// Payment should subscriptional
// N7000/Mo for 1 Month
// N6500/Mo for 3 Month
// N6000/Mo for 6 Month
// N5000/Mo for 12 Month
