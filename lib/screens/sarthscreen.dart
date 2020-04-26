import 'dart:async';
import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/food_page.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class SarthScreen extends StatefulWidget {
  @override
  SarthscreenState createState() => SarthscreenState();
}

class SarthscreenState extends State<SarthScreen> {
  Color gradientstart = Colors.deepPurple[700];
  Color gradientend = Colors.purple[500];
  final db = Firestore.instance;
  var overalluserid;

  @override
  Widget build(BuildContext context) {
     overalluserid = Provider.of<Auth>(
      context,
      listen: false,
    ).userId;
    return new Scaffold(
    // appBar: AppBar(
    //   title: Text("Homepage"),
    //   centerTitle: true,
    // ),
    body: Container(
      decoration: BoxDecoration(
        gradient:  new LinearGradient(colors: [gradientstart, gradientend],
        begin: const FractionalOffset(0.5, 0.0),
        end:  const FractionalOffset(0.0, 0.5),
          stops: [0.0,1.0]
        )
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                ),
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text("Your food places!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Scrapbook').document(overalluserid).collection('Food').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData) return const Text("Connecting");
                  return Expanded(
                      child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index){
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return Container(
                            child: new GestureDetector(
                              onLongPress: (){
                                showModalBottomSheet(context: context,
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(17.0)),
                                    ),
                                    builder: (BuildContext context){
                                  return Container(
                                    child: new Wrap(
                                      children: <Widget>[
                                        new ListTile(
                                            leading: new Icon(Icons.delete),
                                            contentPadding: EdgeInsets.all(5.8),
                                            title: Text("Delete",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,

                                            ),),
                                            onTap:(){
                                              Firestore.instance.collection('Scrapbook').document(overalluserid).collection('Food').document(ds.documentID).delete();
                                              Navigator.pop(context);
                                            }
                                        )
                                      ],
                                    ),
                                  );
                                });
                              },
                              child:  mycard(
                                foodplace: ds['place'],
                                ratings:  ds['rating'],
                                id: ds.documentID,
                                star: ds['star'],
                              ),
                            ),
                          );
                        },
                      )
                  );
                },
              ),
            )
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      icon: Icon(Icons.add),
      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => foodpage("", "",0.0,false, "")));},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      elevation: 15.0,
      label: Text("Add!"),
    ),
    );
  }
}

class mycard extends StatelessWidget {
  String foodplace;
  String ratings;
  String id;
  double star;

  mycard({this.foodplace, this.ratings, this.id, this.star});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(foodplace,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.mode_edit),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => foodpage(foodplace, ratings,star, true, id)));
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(ratings,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Icon(
                            Icons.star,
                            color: star >= 1 ? Colors.orange : Colors.grey,
                          ),
                          new Icon(
                            Icons.star,
                            color: star >= 2 ? Colors.orange : Colors.grey,
                          ),
                          new Icon(
                            Icons.star,
                            color: star >= 3 ? Colors.orange : Colors.grey,
                          ),
                          new Icon(
                            Icons.star,
                            color: star >= 4 ? Colors.orange : Colors.grey,
                          ),
                          new Icon(
                            Icons.star,
                            color: star >= 5 ? Colors.orange : Colors.grey,
                          ),
                          new SizedBox(
                            width: 120.0,
                          ),
                          new IconButton(
                              icon: Icon(Icons.share),
                              onPressed: (){
                                final RenderBox box = context.findRenderObject();
                                Share.share("${foodplace} -\nMy review: ${ratings}\nRating : ${star}", subject: ratings, sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size
                                );
                              },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


