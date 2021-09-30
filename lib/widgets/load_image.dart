import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget loadImage(context, dynamic course, String url) {
  // return NetworkImage('$baseUrl/${course.thumbnail}',
  // headers: {'cache-control': 'max-age=1000000'});
  return new Container(
    // margin: EdgeInsets.only(bottom: 10),
    width: screen(context).width * 0.28,
    height: 100,
    decoration: new BoxDecoration(
      image: DecorationImage(
        image: NetworkImage('$baseUrl/${course.thumbnail}',
            headers: {'cache-control': 'max-age=0, must-revalidate'}),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
    ),
    child: course.status == false
        ? SvgPicture.asset("assets/imgs/icons/lock_icon.svg",
            color: Colors.white, fit: BoxFit.scaleDown)
        : SvgPicture.asset(
            "assets/imgs/icons/play_video_icon.svg",
            color: Colors.white,
            fit: BoxFit.scaleDown,
          ),
  );
  // FutureBuilder(
  //   future: http.get(url, headers: {'cache-control': 'max-age=1000000'}),
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.done) {
  //       print("completed snapshot $snapshot");
  //       return Container();
  //       // return new Container(
  //       //   width: screen(context).width * 0.28,
  //       //   height: 120,
  //       //   decoration: new BoxDecoration(
  //       //     image: DecorationImage(
  //       //       image: FileImage(snapshot.data),
  //       //       // NetworkImage('$baseUrl/${course.thumbnail}',
  //       //       //       headers: {'cache-control': 'max-age=0, must-revalidate'}),
  //       //       fit: BoxFit.cover,
  //       //     ),
  //       //     borderRadius: BorderRadius.only(
  //       //         bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
  //       //   ),
  //       //   child: course.status == false
  //       //       ? SvgPicture.asset("assets/imgs/icons/lock_icon.svg",
  //       //           color: Colors.white, fit: BoxFit.scaleDown)
  //       //       : SvgPicture.asset(
  //       //           "assets/imgs/icons/play_video_icon.svg",
  //       //           color: Colors.white,
  //       //           fit: BoxFit.scaleDown,
  //       //         ),
  //       // );
  //     } else {
  //       print("not completed snapshot $snapshot");
  //       return Container();
  //       // return new Container(
  //       //   width: screen(context).width * 0.28,
  //       //   height: 120,
  //       //   child:
  //       //       Image.asset("assets/imgs/icons/unloaded.png", fit: BoxFit.cover),
  //       // );
  //     }
  //   },
  // );
}
