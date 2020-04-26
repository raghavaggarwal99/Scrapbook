import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../providers/auth.dart';

class foodpage extends StatefulWidget {
  String places;
  String recc;
  double star;
  bool isedit;
  String docid;
  foodpage(this.places, this.recc,this.star, this.isedit, this.docid, {Key key}) : super(key:key);
  @override
  _foodpageState createState() => _foodpageState(places,recc,star,isedit,docid);
}

class _foodpageState extends State<foodpage> {
  File myimage;
  bool uploaded = false;
  String FileName;
  String places;
  String docid;
  String recc;
  double star = 0.0;
  bool isedit;
  var overalluserid;

  _foodpageState(this.places, this.recc, this.star, this.isedit, this.docid);

  TextEditingController placecontrol;
  TextEditingController ratingcontrol;
  @override
  void initState() {
    placecontrol = new TextEditingController();
    placecontrol.text = places;
    ratingcontrol = new TextEditingController();
    ratingcontrol.text = recc;
    super.initState();
  }

  String Foodplaces;
  String Ratings;

  getfoodplace(Foodplaces){
    this.Foodplaces = Foodplaces;
  }
  getratings(Ratings){
    this.Ratings = Ratings;
  }
  Color gradientstart = Colors.deepPurple[700];
  Color gradientend = Colors.purple[500];
  @override
  Widget build(BuildContext context) {
    overalluserid = Provider.of<Auth>(
      context,
      listen: false,
    ).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text("Foodpage"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(colors: [gradientstart, gradientend],
          begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5)
          )
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Container(
                width: (MediaQuery.of(context).size.width)/1.2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Which place?",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(9.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),

                    )
                  ),
                  controller: placecontrol,
                  onChanged: (String foodplace){
                    getfoodplace(foodplace);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Container(
                width: (MediaQuery.of(context).size.width)/1.2,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Any recommendations?",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 9.0, bottom: 60.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),

                      )
                  ),
                  controller: ratingcontrol,
                  onChanged: (String ratings){
                    getratings(ratings);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Container(
                width: (MediaQuery.of(context).size.width)/1.2,
                child: SmoothStarRating(
                  rating: star,
                  size: 38,
                  filledIconData: Icons.star,
                  color: Colors.yellowAccent,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: false,
                  spacing: 1.7,
                  onRatingChanged: (v){
                    setState(() {
                      star  = v;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: 9.0,),
           Padding(
             padding: EdgeInsets.all(18.0),
             child:  Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 RaisedButton(
                   elevation: 10.0,
                   shape: CircleBorder(

                   ),
                   child: Icon(
                    Icons.cancel
                   ),
                   onPressed: (){
                     placecontrol.clear();
                     ratingcontrol.clear();
                     Navigator.pop(context);
                   },
                 ),
                 SizedBox(width: 12.0,),
                 RaisedButton(
                   elevation: 10.0,
                   shape: RoundedRectangleBorder(
                     borderRadius: new BorderRadius.circular(14.0),
                     side: BorderSide(
                         width: 1,
                         color: Theme.of(context).primaryColor
                     ),
                   ),
                   child: Row(
                     children: <Widget>[
                       Icon(Icons.add_circle_outline,
                       color: Colors.blue,),
                       SizedBox(width: 6.0,),
                       Text("Add!")
                     ],
                   ),
                   onPressed: (){
                     if(placecontrol.text.isEmpty || ratingcontrol.text.isEmpty){
                       showDialog(
                           context: context,
                           builder: (context) {
                             return AlertDialog(
                               title: Text("Empty!"),
                               content: Text("Fill those pls :)"),
                               actions: <Widget>[
                                 new FlatButton(
                                   child: new Text('Okay!'),
                                   onPressed: () {
                                     Navigator.of(context).pop();
                                   },
                                 )
                               ],
                             );
                           });
                     }

                     else if(isedit){
                       Firestore.instance.collection('places').document(docid).updateData({
                         'place' : placecontrol.text,
                         'rating' : ratingcontrol.text,
                         'star' : star,
                       }).then((result) => {
                         Navigator.pop(context),
                         placecontrol.clear(),
                         ratingcontrol.clear()
                       });
                     }
                     else if(placecontrol.text.isNotEmpty && ratingcontrol.text.isNotEmpty && !isedit){
                       Firestore.instance.collection('Scrapbook').document(overalluserid).collection('Food').add({
                         'place' : placecontrol.text,
                         'rating' : ratingcontrol.text,
                         'star' : star,
                       }).then((result) => {
                         Navigator.pop(context),
                         placecontrol.clear(),
                         ratingcontrol.clear()
                       });
                     }
                     //createdata();
                     //uploadimage();
                   },
                 ),
               ],
             ),
           ),
            uploaded == false ? Container(): Text("Done!")
          ],
        ),
      ),
    );
  }
}
