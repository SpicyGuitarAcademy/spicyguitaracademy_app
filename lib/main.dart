import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/pages/public/verify_device.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentAssignments.dart';
import 'package:spicyguitaracademy_app/providers/StudentNotifications.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/providers/Tutorial.dart';

// pages
import 'package:spicyguitaracademy_app/pages/authenticated/completed_category.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/completed_courses.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/coursepreview_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/editpassword_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/forums_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/helpdetails_page.dart';
// import 'package:spicyguitaracademy_app/pages/authenticated/userprofile_page.dart';
import 'package:spicyguitaracademy_app/pages/public/contact.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/editprofile_page.dart';
import 'package:spicyguitaracademy_app/pages/public/forgot_password.dart';
import 'package:spicyguitaracademy_app/pages/public/reset_password.dart';

import 'package:spicyguitaracademy_app/pages/public/terms_and_condition.dart';
import 'package:spicyguitaracademy_app/pages/public/landing_page.dart';
import 'package:spicyguitaracademy_app/pages/public/verify_email.dart';
import 'package:spicyguitaracademy_app/pages/public/welcome_page.dart';
import 'package:spicyguitaracademy_app/pages/public/register_page.dart';
import 'package:spicyguitaracademy_app/pages/public/login_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/welcome_note.dart';

import 'package:spicyguitaracademy_app/pages/authenticated/choose_plan.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/successful_transaction.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/failed_transaction.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/ready_to_play.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/start_loading.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/choose_category.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/dashboard.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/search_page.dart';
// import 'package:spicyguitaracademy_app/pages/authenticated/rechoose_plan.dart';
// import 'package:spicyguitaracademy_app/pages/authenticated/rechoose_category.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/invite_friend.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/lessons_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/notifications_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/tutorial_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/settings_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/help_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/assignment_page.dart';
import 'package:spicyguitaracademy_app/services/pay_with_paypal.dart';
import 'package:spicyguitaracademy_app/services/pay_with_paystack.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Student()),
        ChangeNotifierProvider(create: (context) => StudentSubscription()),
        ChangeNotifierProvider(create: (context) => StudentStudyStatistics()),
        ChangeNotifierProvider(create: (context) => StudentNotifications()),
        ChangeNotifierProvider(create: (context) => Subscription()),
        ChangeNotifierProvider(create: (context) => Courses()),
        ChangeNotifierProvider(create: (context) => StudentAssignments()),
        ChangeNotifierProvider(create: (context) => Lessons()),
        ChangeNotifierProvider(create: (context) => Tutorial()),
        ChangeNotifierProvider(create: (context) => StudentAssignments()),
      ],
      child: SpicyGuitarAcademy(),
    ),
  );

  // runApp(SpicyGuitarAcademy());
}

class SpicyGuitarAcademy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // cache
    precacheImage(
        AssetImage("assets/imgs/icons/spicy_guitar_logo.png"), context);

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colors
        primaryColor: Color(0xFF6B2B14),
        accentColor: Color(0xFF471D0E),
        buttonColor: Color(0xFF6B2B14),
        primaryColorDark: Color(0xFF471D0E),
        scaffoldBackgroundColor: Color(0xFFF3F3F3),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
            ),
            // side: MaterialStateProperty.all(
            //   BorderSide(
            //     color: brown,
            //     width: 2,
            //     style: BorderStyle.solid,
            //   ),
            // ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            textStyle: MaterialStateProperty.all(
              TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
              ),
            ),
            tapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: MaterialStateProperty.all(brown),
            overlayColor: MaterialStateProperty.all(darkbrown),
            foregroundColor: MaterialStateProperty.all(white),
            alignment: Alignment.center,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          errorMaxLines: 3,
          fillColor: Color(0xFF707070),
          hintStyle: TextStyle(color: Color(0xFF707070), fontSize: 20.0),
          labelStyle: TextStyle(color: Color(0xFF707070), fontSize: 20.0),
          // normal
          border: UnderlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF707070)),
          ),
          // focused
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF471D0E)),
          ),
          // errors
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),

        // textButtonTheme: TextButtonThemeData(
        //   style: ButtonStyle(
        //     foregroundColor: brown,
        //   )
        // ),

        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF6B2B14),
          focusColor: Color(0xFF471D0E),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          layoutBehavior: ButtonBarLayoutBehavior.padded,
          splashColor: Color(0xFF471D0E),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Color(0xFF6B2B14))),
        ),

        // brightness
        brightness: Brightness.light,

        // cursorColor: Color(0xFF6B2B14),

        focusColor: Color(0xFF6B2B14),

        fontFamily: "Poppins",

        // text themes
        textTheme: TextTheme(

            // headline6: TextStyle(
            //   color: Color(0xFF6B2B14),
            //   fontSize: 20.0
            // ),

            // overline: TextStyle(
            //   color: Color(0xFF6B2B14),
            //   fontSize: 40.0
            // ),

            bodyText2: TextStyle(
                color: Color(0xFF707070),
                fontSize: 16.0,
                fontFamily: 'Poppins')),
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LandingPage(), // landing_page
        '/welcome_page': (BuildContext context) => new WelcomePage(),
        '/register': (BuildContext context) => new RegisterPage(),
        '/terms_and_condition': (BuildContext context) =>
            new TermsAndCondition(),
        // '/privacy': (BuildContext context) => new PrivacyPolicy(),
        '/login': (BuildContext context) => new LoginPage(),
        '/verify-device': (BuildContext context) => new VerifyDevicePage(),
        '/forgot_password': (BuildContext context) => new ForgotPasswordPage(),
        '/verify': (BuildContext context) => new VerifyPage(),
        '/resetpassword': (BuildContext context) => new ResetPasswordPage(),
        '/welcome_note': (BuildContext context) => new WelcomeNotePage(),
        '/choose_plan': (BuildContext context) => new ChoosePlan(),
        '/successful_transaction': (BuildContext context) =>
            new SuccessfulTransaction(),
        '/failed_transaction': (BuildContext context) =>
            new FailedTransaction(),
        '/ready_to_play': (BuildContext context) =>
            new ReadyToPlayTransaction(),
        '/start_loading': (BuildContext context) => new StartLoading(),
        '/choose_category': (BuildContext context) => new ChooseCategory(),
        '/dashboard': (BuildContext context) => new Dashboard(),
        '/search_page': (BuildContext context) => new SearchPage(),
        '/invite_friend': (BuildContext context) => new InviteFriend(),
        '/lessons_page': (BuildContext context) => new LessonsPage(),
        '/tutorial_page': (BuildContext context) => new TutorialPage(),
        '/coursepreview_page': (BuildContext context) =>
            new CoursePreviewPage(),
        '/notification': (BuildContext context) => new NotificationPage(),
        '/help': (BuildContext context) => new HelpPage(),
        '/helpdetail': (BuildContext context) => new HelpDetailsPage(),
        '/settings': (BuildContext context) => new SettingsPage(),
        '/forums': (BuildContext context) => new ForumsPage(),
        '/assignment_page': (BuildContext context) => new AssignmentPage(),
        '/contactus': (BuildContext context) => new ContactUsPage(),
        '/editprofile': (BuildContext context) => new EditProfilePage(),
        '/editpassword': (BuildContext context) => new EditPasswordPage(),
        '/completedcourses': (BuildContext context) => new CompletedCourses(),
        '/completedcategory': (BuildContext context) => new CompletedCategory(),
        '/pay_with_paystack': (BuildContext context) => new PayWithPaystack(),
        '/pay_with_paypal': (BuildContext context) => new PayWithPayPal(),
      },
    );
  }
}
