import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
// import 'main.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  static final formKey = new GlobalKey<FormState>();
  String movie_name;
  String genre;
  List<String> genres = [];
  String famous_cast;
  List<String> famous_casts = [];
  double rating;
  String comments;
  String free_link;
  final db = Firestore.instance;

  bool _save() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print(
          'Form is valid, Movie Name: $movie_name, Genre: $genre, rating: $rating');
      return true;
    } else {
      print('Form invalid!');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = MediaQuery.of(context).size.height * 0.04;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Movies',
          style: Theme.of(context).textTheme.title,
        ),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 22.0,
            left: 22.0,
            bottom: 22.0,
            top: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //Expanded(
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //movie name input
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.movie),
                        labelText: 'Movie Name',
                        labelStyle: Theme.of(context).textTheme.caption,
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => movie_name = value,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    //genre input
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.art_track,
                          size: 32.0,
                        ),
                        labelText: 'Genre',
                        labelStyle: Theme.of(context).textTheme.caption,
                        hintText: 'Comma Seperated for multiple.',
                        hintStyle: Theme.of(context).textTheme.display1,
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Genre Name can\'t be empty' : null,
                      onSaved: (value) => genre = value,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    //famous cast input
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          size: 32.0,
                        ),
                        labelText: 'Famous Cast',
                        labelStyle: Theme.of(context).textTheme.caption,
                        hintText: 'Comma Separated for multiple.',
                        hintStyle: Theme.of(context).textTheme.display1,
                      ),
                      //validator: (value) => value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => famous_cast = value,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    //rating input
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.star_border,
                          size: 30.0,
                        ),
                        labelText: 'Rating',
                        labelStyle: Theme.of(context).textTheme.caption,
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Rating Name can\'t be empty' : null,
                      onSaved: (value) => rating = double.parse(value),
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    //comments input
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.rate_review,
                          size: 28.0,
                        ),
                        labelText: 'Comments*',
                        labelStyle: Theme.of(context).textTheme.caption,
                      ),
                      //validator: (value) => value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => comments = value,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    //free link input
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.link,
                          size: 28.0,
                        ),
                        labelText: 'Free Link*',
                        labelStyle: Theme.of(context).textTheme.caption,
                      ),
                      //validator: (value) => value.isEmpty ? 'Movie Name can\'t be empty' : null,
                      onSaved: (value) => free_link = value,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    //save button
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'Save',
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: () async {
                          if (_save()) {
                            genres = genre.split(',');
                            famous_casts = famous_cast.split(',');
                            await db.collection('Movies').add({
                              'movie_n': movie_name,
                              'genre': genres,
                              'famous_c': famous_casts,
                              'rating': rating,
                              'comments': comments,
                              'free_link': free_link
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
