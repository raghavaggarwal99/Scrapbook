import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './providers/auth.dart';
// import './providers/notifications.dart';

import './screens/loginscreen.dart';
import './screens/splashScreen.dart';
import './screens/homeScreen.dart';
import './screens/tabsScreen.dart';
import './screens/adminScreen.dart';
// import './screens/messageScreen.dart';
// import './screens/mainChatScreen.dart';

// import './widgets/heat_map.dart';

import 'constants/constants.dart';

void main() => runApp(MyApp());

//Provider is the most basic of the Provider widget types. You can use it to 
//provide a value (usually a data model object) to anywhere in the widget tree. 
//However, it won’t help you update the widget tree when that value changes.
//ChangeNotifierProvider listens for changes in the model object. When there are changes, it will rebuild any widgets under the Consumer.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Personal Scrapbook',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // primaryColor: Color(0xff2ecc71),
            // accentColor: Colors.greenAccent,
            primaryIconTheme: IconThemeData(
              color: Colors.white,
              size: 32,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 32,
            ),
            textTheme: TextTheme(
              title: GoogleFonts.balooDa(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 42.0,
              ),
              subtitle: GoogleFonts.balooDa(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 26.0,
                letterSpacing: 1.4,
              ),
              subhead: GoogleFonts.balooDa(
                fontWeight: FontWeight.w500,
                fontSize: 22.0,
                color: Colors.black.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
              body1: GoogleFonts.balooDa(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
                fontSize: 18.0,
              ),
              button: GoogleFonts.balooDa(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
          ),
          home: authData.isAuth
              ? authData.isAdmin ? AdminScreen() : TabsScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : MyHomePage(),
                ),
          routes: {
            Routes.ADMIN_SCREEN: (ctx) => AdminScreen(),
            Routes.TABS_SCREEN: (ctx) => TabsScreen(),
            Routes.HOME_SCREEN: (ctx) => HomeScreen(),
            // Routes.MESSAGE_SCREEN: (ctx) => MessageScreen(),
            // Routes.MAP_SCREEN: (ctx) => HeatMap(),
            // Routes.MAIN_CHAT_SCREEN: (ctx) => MainChatScreen(),
          },
        ),
      ),
    );
  }
}