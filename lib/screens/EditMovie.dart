import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'Showmovie.dart';

class Editscreen extends StatefulWidget {
  Editscreen(
      {this.docId,
      this.name,
      this.genre,
      this.famous_Cast,
      this.ratings,
      this.comments,
      this.freelink});
  final docId;
  String name;
  String genre;
  String famous_Cast;
  double ratings;
  String comments;
  String freelink;
  @override
  _EditscreenState createState() => _EditscreenState(
      docId, name, genre, famous_Cast, ratings, comments, freelink);
}

class _EditscreenState extends State<Editscreen> {
  _EditscreenState(this.docId, this.name, this.genre, this.famous_cast,
      this.ratings, this.comments, this.freelink);
  static final formKey = new GlobalKey<FormState>();

  final db = Firestore.instance.collection('Movies');
  String docId;
  String name;
  String genre;
  List<String> genres = [];
  String famous_cast;
  List<String> famous_casts = [];
  double ratings;
  String comments;
  String freelink;

  bool _save() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print(
          'Form is valid, Movie Name: $name, Genre: $genre, rating: $ratings');
      print(genre);
      print(famous_cast);
      return true;
    } else {
      print('Form invalid!');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Edit Movies'),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Expanded(
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 70.0, 0.0, 0.0),
              child: new Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        labelText: 'Movie Name',
                        labelStyle: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => name = value,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: genre,
                      decoration: InputDecoration(
                        labelText: 'Genre',
                        labelStyle: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                        hintText: 'Comma Seperated for multiple.',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Genre Name can\'t be empty' : null,
                      onSaved: (value) => genre = value,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: famous_cast,
                      decoration: InputDecoration(
                        labelText: 'Famous Cast',
                        labelStyle: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                        hintText: 'Comma Separated for multiple.',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      // validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
                      onSaved: (value) => famous_cast = value,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: ratings.toString(),
                      decoration: InputDecoration(
                        labelText: 'Rating',
                        labelStyle: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Rating Name can\'t be empty' : null,
                      onSaved: (value) => ratings = double.parse(value),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: comments,
                      decoration: InputDecoration(
                        labelText: 'Comments*',
                        labelStyle: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      //validator: (value) => value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => comments = value,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: freelink,
                      decoration: InputDecoration(
                        labelText: 'free link*',
                        labelStyle: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      //validator: (value) => value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => freelink = value,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 60.0,
                        child: GestureDetector(
                          onTap: () async {
                            if (_save()) {
                              genres = genre.split(',');
                              famous_casts = famous_cast.split(',');
                              await db.document(docId).setData({
                                'movie_n': name,
                                'genre': genres,
                                'famous_c': famous_casts,
                                'rating': ratings,
                                'comments': comments,
                                'free_link': freelink
                              });
                              Navigator.of(context).pop();
                            }
                            Navigator.of(context).pop();
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    fontFamily: 'SourceSansPro',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
