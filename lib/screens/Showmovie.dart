import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'EditMovie.dart';

class ShowPage extends StatefulWidget {
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  final db = Firestore.instance.collection('Movies');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Movie To Watch',
          style: Theme.of(context).textTheme.title,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: db.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return new ListView(
                  physics: BouncingScrollPhysics(),
                  children: getExpenseItems(snapshot),
                );
            }
          },
        ),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => CustomCard(
            movie_name: doc["movie_n"],
            genres: doc["genre"],
            famous_casts: doc["famous_c"],
            rating: doc["rating"].toString(),
            comment: doc["comments"],
            free_link: doc["free_link"],
            documentId: doc.documentID,
          ),
        )
        .toList();
  }
}

class CustomCard extends StatefulWidget {
  CustomCard(
      {@required this.movie_name,
      this.genres,
      this.famous_casts,
      this.rating,
      this.comment,
      this.free_link,
      this.documentId});

  String movie_name;
  List<Object> genres;
  List<Object> famous_casts;
  String rating;
  String comment;
  String free_link;
  String documentId;

  @override
  _CustomCardState createState() => _CustomCardState(
      movie_name: movie_name,
      genres: genres,
      famous_casts: famous_casts,
      rating: rating,
      comment: comment,
      free_link: free_link,
      documentId: documentId);
}

class _CustomCardState extends State<CustomCard> {
  _CustomCardState(
      {@required this.movie_name,
      this.genres,
      this.famous_casts,
      this.rating,
      this.comment,
      this.free_link,
      this.documentId});

  String movie_name;
  List<Object> genres;
  List<Object> famous_casts;
  String rating;
  String comment;
  String free_link;
  String documentId;
  List<String> genre_strings = new List<String>();
  List<String> famous_cast_string = new List<String>();
  String Genre;
  String Famous_cast;

  void convert() {
    genres.forEach((item) {
      genre_strings.add(item.toString());
    });
    //genre_strings.forEach((item) => print(item));
    Genre = genre_strings.join(',');
    print(Genre);
    famous_casts.forEach((item) {
      famous_cast_string.add(item.toString());
    });
    Famous_cast = famous_cast_string.join(',');
    print(Famous_cast);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerHeight = screenSize.height * 0.42;
    final containerWidth = screenSize.width;
    final spacing = screenSize.height * 0.015;

    return Container(
      height: containerHeight,
      width: containerWidth,
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 24.0,
      ),
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 0.6,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //left portion
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //movie name
                  Text(
                    movie_name,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  //genre Heading
                  Text(
                    'Genre',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  //genre list
                  Container(
                    width: containerWidth * 0.5,
                    height: containerHeight * 0.07,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        ...genres
                            .map(
                              (genre) => Text(
                                "$genre,",
                                style: Theme.of(context).textTheme.display1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  //famous cast Heading
                  Text(
                    'Famous Cast',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  //cast list
                  Container(
                    width: containerWidth * 0.5,
                    height: containerHeight * 0.07,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        ...famous_casts
                            .map(
                              (famous_cast) => Text(
                                "$famous_cast,",
                                style: Theme.of(context).textTheme.display1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  //comment box
                  comment != ''
                      ? SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //comment heading
                              Text(
                                'Comment',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              //comment heading
                              Text(
                                comment,
                                style: Theme.of(context).textTheme.display1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  //details row
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //rating data
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //rating heading
                              Icon(
                                Icons.star_border,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              Text(
                                rating,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                          //watching here
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 6.0,
                              ),
                              //watching heading
                              Text(
                                'Watch',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              RaisedButton.icon(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onPressed: free_link == ''
                                    ? null
                                    : () {
                                        launch(free_link);
                                      },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Play',
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //right portion
          Container(
            height: containerHeight,
            width: containerWidth * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: containerHeight * 0.45,
                  width: containerWidth * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('images/img1.jpg', fit: BoxFit.cover),
                  ),
                ),
                Spacer(),
                //edit buttton
                FlatButton.icon(
                  icon: Icon(
                    Icons.edit,
                    size: 24.0,
                    color: Colors.orange,
                  ),
                  label: Text(
                    'Edit    ',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text(
                            "Are you sure to Edit?",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () {
                                convert();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Editscreen(
                                      docId: documentId,
                                      name: movie_name,
                                      genre: Genre,
                                      famous_Cast: Famous_cast,
                                      ratings: double.parse(rating),
                                      comments: comment,
                                      freelink: free_link,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                //delete button
                FlatButton.icon(
                  icon: Icon(
                    Icons.delete,
                    size: 24.0,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Delete',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text(
                            "Are you sure to delete?",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text("Yes"),
                              onPressed: () {
                                Firestore.instance
                                    .collection('Movies')
                                    .document(documentId)
                                    .delete();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                //share button
                Container(
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.share,
                      size: 24.0,
                      color: Colors.blue,
                    ),
                    label: Text(
                      'Share  ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
