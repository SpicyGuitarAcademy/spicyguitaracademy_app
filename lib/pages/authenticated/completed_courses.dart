import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spicyguitaracademy_app/common.dart';
import 'package:spicyguitaracademy_app/models.dart';
import 'package:soundpool/soundpool.dart';

class CompletedCourses extends StatefulWidget {
  @override
  CompletedCoursesState createState() => new CompletedCoursesState();
}

class CompletedCoursesState extends State<CompletedCourses> {
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
    streamId = await pool.play(soundId!, repeat: 50);
    pool.setVolume(soundId: soundId, volume: 20);
  }

  @override
  void dispose() {
    super.dispose();
    pool.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'You have completed all lessons in ${Courses.currentCourse!.title}',
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
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  onPressed: () async {
                    try {
                      if (Assignment.status == true) {
                        Navigator.pushReplacementNamed(
                            context, '/assignment_page');
                      } else {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/dashboard'));
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      error(context, stripExceptions(e));
                    }
                  },
                  color: brown,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      side: BorderSide(color: brown, width: 2.0)),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: Text("Continue", style: TextStyle(fontSize: 20.0)),
                  ),
                ),
              ),
            ]),
      ),
    ));
  }
}
