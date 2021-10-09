import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
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
  CheckoutMethod _method = CheckoutMethod.selectable;

  // properties
  String? _selectedPlan;
  PaystackPlugin? _paystackPlugin = new PaystackPlugin();

  @override
  void initState() {
    super.initState();
    initiatePage();
  }

  Future initiatePage() async {
    Subscription subscription = context.read<Subscription>();
    StudentSubscription studentSubscription =
        context.read<StudentSubscription>();

    _selectedPlan = studentSubscription.subscriptionPlan;
    await subscription.getPaymentKey();
    _paystackPlugin!.initialize(publicKey: subscription.paystackPublicKey!);
  }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: '',
      cvc: '',
      expiryMonth: 0,
      expiryYear: 0,
    );
  }

  _handleCheckout(
      BuildContext context,
      Student student,
      Subscription subscription,
      StudentSubscription studentSubscription) async {
    Charge charge = Charge()
      ..amount = subscription.price! // In base currency
      ..email = student.email
      ..card = _getCardFromUI();

    charge.accessCode = subscription.accessCode;

    try {
      CheckoutResponse response = await _paystackPlugin!.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: true,
        logo: SvgPicture.asset(
          "assets/imgs/icons/spicy_guitar_logo.svg",
          width: 40.0,
          matchTextDirection: true,
        ),
      );

      if (response.verify == true) {
        await subscription.verifySubscriptionPayment(studentSubscription);
        Navigator.pop(context);
        if (subscription.subscriptionPaymentStatus == true) {
          Navigator.popAndPushNamed(context, "/successful_transaction");
        } else {
          Navigator.pushNamed(context, "/failed_transaction");
        }
      } else {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/failed_transaction");
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
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
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                onPressed: () =>
                                    studentSubscription.isSubscribed == false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![0]['plan_id'])
                                        : null,
                                color: _selectedPlan ==
                                        subscription.plans![0]['plan_id']
                                    ? brown
                                    : Colors.white,
                                textColor: _selectedPlan ==
                                        subscription.plans![0]['plan_id']
                                    ? Colors.white
                                    : brown,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                    side: BorderSide(color: brown, width: 2.0)),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                          "NGN ${subscription.plans![0]['price']}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: SvgPicture.asset(
                                          "assets/imgs/icons/1MS_icon.svg",
                                          matchTextDirection: true,
                                        ),
                                      ),
                                      Text(subscription.plans![0]['plan'],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                    ]),
                              ),
                            ),
                            Container(
                              width: screen(context).width * 0.4,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                onPressed: () =>
                                    studentSubscription.isSubscribed == false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![1]['plan_id'])
                                        : null,
                                color: _selectedPlan ==
                                        subscription.plans![1]['plan_id']
                                    ? brown
                                    : Colors.white,
                                textColor: _selectedPlan ==
                                        subscription.plans![1]['plan_id']
                                    ? Colors.white
                                    : brown,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                    side: BorderSide(color: brown, width: 2.0)),
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
                                        margin:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: SvgPicture.asset(
                                          "assets/imgs/icons/3MS_icon.svg",
                                          matchTextDirection: true,
                                        ),
                                      ),
                                      Text(subscription.plans![1]['plan'],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                    ]),
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
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                onPressed: () =>
                                    studentSubscription.isSubscribed == false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![2]['plan_id'])
                                        : null,
                                color: _selectedPlan ==
                                        subscription.plans![2]['plan_id']
                                    ? brown
                                    : Colors.white,
                                textColor: _selectedPlan ==
                                        subscription.plans![2]['plan_id']
                                    ? Colors.white
                                    : brown,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                    side: BorderSide(color: brown, width: 2.0)),
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
                                        margin:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: SvgPicture.asset(
                                          "assets/imgs/icons/6MS_icon.svg",
                                          matchTextDirection: true,
                                        ),
                                      ),
                                      Text(subscription.plans![2]['plan'],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                    ]),
                              ),
                            ),
                            Container(
                              width: screen(context).width * 0.4,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                onPressed: () =>
                                    studentSubscription.isSubscribed == false
                                        ? setState(() => _selectedPlan =
                                            subscription.plans![3]['plan_id'])
                                        : null,
                                color: _selectedPlan ==
                                        subscription.plans![3]['plan_id']
                                    ? brown
                                    : Colors.white,
                                textColor: _selectedPlan ==
                                        subscription.plans![3]['plan_id']
                                    ? Colors.white
                                    : brown,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                    side: BorderSide(color: brown, width: 2.0)),
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
                                        margin:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: SvgPicture.asset(
                                          "assets/imgs/icons/1YS_icon.svg",
                                          matchTextDirection: true,
                                        ),
                                      ),
                                      Text(subscription.plans![3]['plan'],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                    ]),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 20.0),

                        studentSubscription.isSubscribed == false
                            // && Student.isLoaded == false
                            ? Container(
                                // alignment: Alignment.center,
                                // margin: const EdgeInsets.symmetric(vertical: 20.0),
                                width: screen(context).width * 0.8,
                                child: Text(
                                  "Tap Continue to watch free lessons or to buy Special Courses.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 0.6),
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
                                width: screen(context).width - 40,
                                child: RaisedButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 20),
                                    textColor: Colors.white,
                                    disabledColor: Colors.white,
                                    onPressed: _selectedPlan == "0"
                                        ? null
                                        : () async {
                                            try {
                                              loading(context);
                                              await subscription
                                                  .initiateSubscriptionPayment(
                                                      _selectedPlan!, student);
                                              Navigator.pop(context);

                                              // complete payment with paystack
                                              Navigator.pushNamed(
                                                  context, '/pay_with_paypal');
                                              // Navigator.pushNamed(
                                              //     context, '/pay_with_paystack',
                                              //     arguments: {
                                              //       'type': 'subscription'
                                              //     });
                                            } catch (e) {
                                              Navigator.pop(context);
                                              error(
                                                  context, stripExceptions(e));
                                            }
                                          },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.credit_card, size: 25.0),
                                        SizedBox(width: 10.0),
                                        Text("Continue Payment",
                                            style: TextStyle(fontSize: 20.0)),
                                      ],
                                    )),
                              )
                            : Container(),

                        SizedBox(height: 20),

                        // if student subscription is expired, offer free
                        studentSubscription.isSubscribed == false
                            // && Student.isLoaded == false
                            ? Container(
                                width: screen(context).width - 40,
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 20),
                                  textColor: Colors.white,
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
