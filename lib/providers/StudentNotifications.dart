import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class StudentNotifications extends ChangeNotifier {
  List<dynamic>? notifications;

  bool? hasUnreadNotifications = false;
  int? unreadNotifications = 0;

  Future getNotifications() async {
    try {
      var resp = await request('/api/notifications', method: 'GET', headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });

      notifications = resp['data']['notifications'];
      dynamic unread = resp['data']['notifications']
          .toList()
          .takeWhile((value) => value['status'] == 'unread');
      unreadNotifications = unread.length;
      if (unreadNotifications! > 0) {
        hasUnreadNotifications = true;
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future markNotificationAsRead(notificationId) async {
    try {
      var resp = await request('/api/notification/markasread',
          method: 'POST',
          body: {
            'notificationId': notificationId
          },
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });

      print(resp);
    } catch (e) {
      throw (e);
    }
  }
}
