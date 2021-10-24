import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
// import the all and the studying
import 'package:spicyguitaracademy_app/pages/authenticated/featured_courses.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/bought_courses.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/no_featured_courses.dart';
import 'package:spicyguitaracademy_app/providers/Ui.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class FeaturedCoursesPage extends StatefulWidget {
  @override
  FeaturedCoursesPageState createState() => new FeaturedCoursesPageState();
}

class FeaturedCoursesPageState extends State<FeaturedCoursesPage>
    with SingleTickerProviderStateMixin {
  FeaturedCoursesPageState();

  TabController? _tabController;
  int tabPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // TabController
    _tabController = new TabController(vsync: this, length: 2);

    // Ui ui = context.read<Ui>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Ui>(builder: (BuildContext context, ui, child) {
      _tabController?.index = ui.featuredCoursesPage;
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    ui.setFeaturedCoursesPage(index);
                  },
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: brown,
                  ),
                  unselectedLabelColor: brown,
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
                  tabs: <Widget>[
                    Tab(
                        child: Text(
                      "BOUGHT COURSES",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                        child: Text(
                      "BUY COURSES",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              ),
            ),
            body: TabBarView(
                dragStartBehavior: DragStartBehavior.start,
                controller: _tabController,
                children: <Widget>[
                  // Bought Page
                  courses.boughtCourses.length == 0
                      ? NoFeaturedCoursesPage()
                      : BoughtCoursesPage(),

                  // All Page
                  FeaturedCourses(),
                ]));
      });
    });
  }
}
