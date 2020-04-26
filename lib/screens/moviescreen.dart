import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/Movies.dart';
import '../screens/Showmovie.dart';

class MovieScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/movies': (BuildContext context) => new MoviePage(),
        '/showmovie': (BuildContext context) => new ShowPage()
      },
      title: 'ScrapBook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 32.0,
        ),
        textTheme: TextTheme(
          title: GoogleFonts.montserrat(
            fontSize: 22.0,
            color: Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
          subhead: GoogleFonts.montserrat(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
          subtitle: GoogleFonts.montserrat(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          button: GoogleFonts.montserrat(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          caption: GoogleFonts.montserrat(
            fontSize: 18.0,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
          display1: GoogleFonts.montserrat(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: MoviePage(title: 'ScrapBook'),
    );
  }
}

class MoviePage extends StatefulWidget {
  MoviePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyMoviePageState createState() => _MyMoviePageState();
}

class _MyMoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/movies');
                        },
                        child: Center(
                          child: Text('Movies',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/showmovie');
                        },
                        child: Center(
                          child: Text('Show Movies',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
