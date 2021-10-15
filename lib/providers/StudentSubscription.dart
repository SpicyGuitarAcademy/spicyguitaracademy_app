import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class StudentSubscription extends ChangeNotifier {
  bool? isSubscribed;
  int? daysRemaining;
  String? subscriptionPlan;
  String? subscriptionPlanLabel;

  bool? hasStudentSubscriptionStatus = false;

  Future getStudentSubscriptionStatus() async {
    try {
      hasStudentSubscriptionStatus = true;

      var resp = await request('/api/subscription/status',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });

      var data = resp['data'];
      isSubscribed = data['status'] == 'ACTIVE' ? true : false;
      daysRemaining = data['days'];
      subscriptionPlan = resp['status'] == true ? data['plan'] : '0';

      subscriptionPlanLabel = [
        "No Subscription Plan",
        "1 Month",
        "3 Months",
        "6 Months",
        "12 Months"
      ][int.parse(subscriptionPlan!)];

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
