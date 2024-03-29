import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class CompletedCategory extends StatefulWidget {
  @override
  CompletedCategoryState createState() => new CompletedCategoryState();
}

class CompletedCategoryState extends State<CompletedCategory> {
  Soundpool pool = Soundpool(streamType: StreamType.music);
  int? soundId;
  int? streamId;

  @override
  void initState() {
    super.initState();
    loadCongratsMusic();
  }

  void loadCongratsMusic() async {
    soundId = await rootBundle
        .load("assets/audio/congrats_audio.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    streamId = await pool.play(soundId!, repeat: 5);
    pool.setVolume(soundId: soundId, volume: 20);
  }

  @override
  void dispose() {
    super.dispose();
    pool.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentStudyStatistics>(
        builder: (BuildContext context, studentStats, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.symmetric(horizontal: 35),
            height: screen(context).height,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/imgs/pictures/confetti.gif'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100),
                  Text(
                    "Congratulations",
                    style: TextStyle(
                      color: brown,
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      'You have completed all courses in ${studentStats.studyingCategoryLabel} category',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/imgs/pictures/partypopper.gif',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    width: screen(context).width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 25,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Continue",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          loading(context);
                          dynamic resp = await request(
                              '/api/student/category/complete',
                              method: 'POST',
                              body: {
                                'course': courses.currentCourse!.id.toString()
                              },
                              headers: {
                                'JWToken': Auth.token!,
                                'cache-control': 'max-age=0, must-revalidate'
                              });
                          Navigator.pop(context);

                          if (resp['status'] == true) {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/dashboard'));
                            Navigator.pushNamed(context, '/choose_category');
                          } else {
                            if (Assignment.status == true) {
                              Navigator.pushReplacementNamed(
                                  context, '/assignment_page');
                            } else {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/dashboard'));
                            }
                            snackbar(context, resp['message']);
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          error(context, stripExceptions(e));
                        }
                      },
                    ),
                  ),
                ]),
          ),
        ));
      });
    });
  }
}
