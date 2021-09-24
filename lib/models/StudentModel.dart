import 'package:flutter/foundation.dart';

// class StudentModel extends ChangeNotifier {}

// class Student {
//   static String id;
//   static String firstname;
//   static String lastname;
//   static String email;
//   static String telephone;
//   static String avatar;
//   static String status;
//   static bool isNewStudent;
//   static bool forgotPassword;

//   static List<dynamic> notifications;
//   static int unreadNotifications;

//   static bool subscription;
//   static int daysRemaining;
//   static String subscriptionPlan;
//   static bool hasUnreadNotifications;

//   static int studyingCategory;
//   static String studyingCategoryLabel;
//   static int takenCourses;
//   static int allCourses;
//   static int takenLessons;
//   static int allLessons;

//   static String subscriptionPlanLabel;

//   static bool isLoaded = false;

//   static pseudoSignin({bool handleClick = false}) async {
//     try {
//       // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//       final SharedPreferences prefs = await _prefs;
//       // print(prefs.getBool('authenticated'));
//       Auth.authenticated = prefs.getBool('authenticated') ?? false;
//       if (Auth.authenticated == true) {
//         id = prefs.getString('id');
//         firstname = prefs.getString('firstname');
//         lastname = prefs.getString('lastname');
//         email = prefs.getString('email');
//         telephone = prefs.getString('telephone');
//         avatar = prefs.getString('avatar');
//         status = prefs.getString('status');
//         Auth.token = prefs.getString('token');
//         isNewStudent = false;
//         forgotPassword = false;

//         if (handleClick == true) {
//           // load subscription plans
//           await Subscription.getSubscriptionPlans();

//           // get student subscription status, days remaining and subscription plan
//           await getSubscriptionStatus();

//           // get the current category and stats
//           await getStudentCategoryAndStats();
//         }

//         // print(prefs.getBool('authenticated'));
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static cacheSignin() async {
//     // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//     // store redundant values in sharedpreference
//     final SharedPreferences prefs = await _prefs;
//     prefs.setString('id', id);
//     prefs.setString('firstname', firstname);
//     prefs.setString('lastname', lastname);
//     prefs.setString('email', email);
//     prefs.setString('telephone', telephone);
//     prefs.setString('avatar', avatar);
//     prefs.setString('status', status);
//     prefs.setString('token', Auth.token);
//     prefs.setBool('authenticated', Auth.authenticated);

//     print(prefs.getBool('authenticated'));
//   }

//   static clearSigninCache() async {
//     // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//     // store redundant values in sharedpreference
//     final SharedPreferences prefs = await _prefs;
//     prefs.remove('firstname');
//     prefs.remove('lastname');
//     prefs.remove('email');
//     prefs.remove('telephone');
//     prefs.remove('avatar');
//     prefs.remove('status');
//     prefs.remove('token');
//     prefs.setBool('authenticated', false);

//     print(prefs.getBool('authenticated'));
//   }

//   static signin(Map<String, dynamic> student, String token) async {
//     try {
//       id = student['id'];
//       firstname = student['firstname'];
//       lastname = student['lastname'];
//       email = student['email'];
//       telephone = student['telephone'];
//       avatar = student['avatar'];
//       status = student['status'];
//       isNewStudent = false;
//       forgotPassword = false;

//       Auth.token = token;
//       Auth.authenticated = true;
//       await cacheSignin();

//       // load subscription plans
//       await Subscription.getSubscriptionPlans();

//       // get student subscription status, days remaining and subscription plan
//       await getSubscriptionStatus();

//       // get the current category and stats
//       await getStudentCategoryAndStats();
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static signout() {
//     Auth.token = null;
//     Auth.authenticated = false;
//     id = null;
//     firstname = null;
//     lastname = null;
//     email = null;
//     telephone = null;
//     avatar = null;
//     status = null;
//     isNewStudent = null;
//     forgotPassword = null;
//     subscription = null;
//     daysRemaining = null;
//     subscriptionPlan = null;
//     studyingCategory = null;
//     studyingCategoryLabel = null;
//     takenCourses = null;
//     allCourses = null;
//     takenLessons = null;
//     allLessons = null;
//     notifications = null;
//     unreadNotifications = 0;
//     hasUnreadNotifications = false;
//     subscriptionPlanLabel = null;
//     isLoaded = false;

//     clearSigninCache();
//   }

//   static getStudentCategoryAndStats() async {
//     try {
//       var resp = await request('/api/student/statistics',
//           method: 'GET',
//           headers: {
//             'JWToken': Auth.token,
//             'cache-control': 'max-age=0, must-revalidate'
//           });

//       if (resp['status'] == true) {
//         studyingCategory = resp['data']['category'] ?? 0;
//         takenCourses = resp['data']['takenCourses'] ?? 0;
//         allCourses = resp['data']['allCourses'] ?? 0;
//         takenLessons = resp['data']['takenLessons'] ?? 0;
//         allLessons = resp['data']['allLessons'] ?? 0;
//       } else {
//         studyingCategory = 0;
//         takenCourses = 0;
//         allCourses = 0;
//         takenLessons = 0;
//         allLessons = 0;
//       }

//       if (subscription == false) studyingCategory = 0;

//       studyingCategoryLabel = [
//         "No Category",
//         "Beginner",
//         "Amateur",
//         "Intermediate",
//         "Advanced"
//       ][studyingCategory];
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static getSubscriptionStatus() async {
//     try {
//       var resp = await request('/api/subscription/status',
//           method: 'GET',
//           headers: {
//             'JWToken': Auth.token,
//             'cache-control': 'max-age=0, must-revalidate'
//           });

//       var data = resp['data'];
//       subscription = data['status'] == 'ACTIVE' ? true : false;
//       daysRemaining = data['days'];
//       subscriptionPlan = resp['status'] == true ? data['plan'] : '0';

//       subscriptionPlanLabel = [
//         "No Subscription Plan",
//         "1 Month",
//         "3 Months",
//         "6 Months",
//         "12 Months"
//       ][int.parse(subscriptionPlan)];
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static getNotifications(context) async {
//     try {
//       var resp = await request('/api/notifications', method: 'GET', headers: {
//         'JWToken': Auth.token,
//         'cache-control': 'max-age=0, must-revalidate'
//       });

//       notifications = resp['data']['notifications'];
//       dynamic unread = resp['data']['notifications']
//           .toList()
//           .takeWhile((value) => value['status'] == 'unread');
//       unreadNotifications = unread.length;
//       print(unreadNotifications);
//       if (unreadNotifications > 0) {
//         hasUnreadNotifications = true;
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static markNotificationAsRead(context, notificationId) async {
//     try {
//       await request('/api/notification/markasread', method: 'POST', body: {
//         'notificationId': notificationId
//       }, headers: {
//         'JWToken': Auth.token,
//         'cache-control': 'max-age=0, must-revalidate'
//       });
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static chooseCategory(String category) async {
//     try {
//       var resp = await request('/api/student/category/select',
//           method: 'POST',
//           headers: {
//             'JWToken': Auth.token,
//             'cache-control': 'max-age=0, must-revalidate'
//           },
//           body: {
//             'category': category
//           });

//       if (resp['status'] == true) {
//         await getStudentCategoryAndStats();
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }

//   static rechooseCategory(context, String category) async {
//     try {
//       var resp = await request('/api/student/category/re-select',
//           method: 'POST',
//           headers: {
//             'JWToken': Auth.token,
//             'cache-control': 'max-age=0, must-revalidate'
//           },
//           body: {
//             'category': category
//           });

//       if (resp['status'] == true) {
//         snackbar(context, resp['message']);
//       } else {
//         throw Exception([resp['message']]);
//       }
//     } catch (e) {
//       throw (e);
//     }
//   }

//   updateProfilePicture() {
//     // var request = new http.MultipartRequest("POST", url);
//     // request.fields['user'] = 'someone@somewhere.com';
//     // request.files.add(http.MultipartFile.fromPath(
//     //     'package',
//     //     'build/package.tar.gz',
//     //     contentType: new MediaType('application', 'x-tar'),
//     // ));
//     // request.send().then((response) {
//     //   if (response.statusCode == 200) print("Uploaded!");
//     // });
//   }
// }
