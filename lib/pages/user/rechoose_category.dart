import 'package:flutter/material.dart';

class ReChooseCategory extends StatefulWidget {
  @override
  ReChooseCategoryState createState() => new ReChooseCategoryState();
}

class ReChooseCategoryState extends State<ReChooseCategory> {

  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // internal properties
    int _completedCourses = 25;
    int _totalCourses = 30;
    String _selectedCategory = "Intermediate";

    _titleOrient(orientation) {
      if (orientation == Orientation.landscape) {
        return Container(
          child: Text(
            "Choose a Category",
            textWidthBasis: TextWidthBasis.longestLine,
            style: TextStyle(
              color: Color.fromRGBO(107, 43, 20, 1.0),
              fontSize: 35.0,fontWeight: FontWeight.w600
            ),
            strutStyle: StrutStyle(
              fontSize: 35.0,
              height: 1.8,
            ),
          ),
        );
      } else {
        return Column(
          children: <Widget>[
            Container(
              child: Text(
                "Choose your",
                style: TextStyle(
                  color: Color.fromRGBO(107, 43, 20, 1.0),
                  fontSize: 35.0,fontWeight: FontWeight.w600
                )
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Category",
                style: TextStyle(
                  color: Color.fromRGBO(107, 43, 20, 1.0),
                  fontSize: 35.0,fontWeight: FontWeight.w600
                )
              ),
            ),
          ]
        );
      }
    }

    return new Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      body: OrientationBuilder(
        
        builder: (context, orientation) {
          return SafeArea(
            minimum: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    // back button
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20, left: 2, bottom: 10),
                      child: MaterialButton(
                        minWidth: 20,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        onPressed: (){ Navigator.pop(context);},
                        child: new Icon(Icons.arrow_back_ios, color: Color.fromRGBO(107, 43, 20, 1.0), size: 20.0,),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.white)
                        ),
                      ),
                      
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        // title text
                        _titleOrient(orientation),

                        // message test
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          width: 300,
                          child: Text(
                            // _completedCourses == _totalCourses ?  : "You have not completed all courses in this category." ,
                            "You have completed $_completedCourses out $_totalCourses courses in this category!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1.0), //(107, 43, 20, 1.0),
                              fontSize: 20.0
                            ),
                          ),
                        ),

                        // category blocks
                        Container(
                          margin: const EdgeInsets.only(top: 60.0),
                          child: Row(
                            mainAxisAlignment: orientation == Orientation.portrait ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                            children: <Widget>[
                              
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 0.0 : 20.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                  onPressed: () {
                                    if (_completedCourses == _totalCourses) setState(() => _selectedCategory = "Beginner");
                                  },
                                  color: _selectedCategory == "Beginner" ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.white,
                                  textColor: _selectedCategory == "Beginner" ? Colors.white : Color.fromRGBO(107, 43, 20, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    side: BorderSide( color: Color.fromRGBO(107, 43, 20, 1.0), width: 2.0 )
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 30.0),
                                    child: Text(
                                      "Beginner",
                                      style: TextStyle(
                                        fontSize: 16.0,fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 0.0 : 20.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                  onPressed: () {
                                    if (_completedCourses == _totalCourses) setState(() => _selectedCategory = "Amateur");
                                  },
                                  color: _selectedCategory == "Amateur" ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.white,
                                  textColor: _selectedCategory == "Amateur" ? Colors.white : Color.fromRGBO(107, 43, 20, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    side: BorderSide( color: Color.fromRGBO(107, 43, 20, 1.0), width: 2.0 )
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 30.0),
                                    child: Text(
                                      "Amateur",
                                      style: TextStyle(
                                        fontSize: 16.0,fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ),
                                ),
                              )

                            ],
                          )
                        ),

                        Container(
                          margin: EdgeInsets.only(top: orientation == Orientation.portrait ? 20.0 : 40.0, ),
                          child: Row(
                            mainAxisAlignment: orientation == Orientation.portrait ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                            children: <Widget>[
                              
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 0.0 : 20.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                  onPressed: () {
                                    if (_completedCourses == _totalCourses) setState(() => _selectedCategory = "Intermediate");
                                  },
                                  color: _selectedCategory == "Intermediate" ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.white,
                                  textColor: _selectedCategory == "Intermediate" ? Colors.white : Color.fromRGBO(107, 43, 20, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    side: BorderSide( color: Color.fromRGBO(107, 43, 20, 1.0), width: 2.0 )
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 30.0),
                                    child: Text(
                                      "Intermediate",
                                      style: TextStyle(
                                        fontSize: 16.0,fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: orientation == Orientation.portrait ? 0.0 : 20.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                  onPressed: () {
                                    if (_completedCourses == _totalCourses) setState(() => _selectedCategory = "Advanced");
                                  },
                                  color: _selectedCategory == "Advanced" ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.white,
                                  textColor: _selectedCategory == "Advanced" ? Colors.white : Color.fromRGBO(107, 43, 20, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    side: BorderSide( color: Color.fromRGBO(107, 43, 20, 1.0), width: 2.0 )
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 30.0),
                                    child: Text(
                                      "Advanced",
                                      style: TextStyle(
                                        fontSize: 16.0,fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ),
                                ),
                              )

                            ],
                          )
                        ),

                        // confirm btn
                        Container(
                          margin: const EdgeInsets.only(top: 100.0, bottom: 30.0),
                          width: 310,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            onPressed: _selectedCategory == "" ? null : () {Navigator.pushNamed(context, "/ready_to_play");},
                            color: _selectedCategory == "" ? Colors.white : Color.fromRGBO(107, 43, 20, 1.0),
                            disabledColor: Colors.white,
                            disabledTextColor: Color.fromRGBO(107, 43, 20, 1.0),
                            textColor: _selectedCategory == "" ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              side: BorderSide( color: Color.fromRGBO(107, 43, 20, 1.0), width: 2.0 )
                            ),
                            
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              child: Text("Done",style: TextStyle( fontSize: 20.0)),
                            ),
                            
                          ),
                        ),

                      ],
                    ),
                    
                  ]
                )

              ),
              
          );
        }

      )
    );

  }

}
