import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'auth/firebase_user_provider.dart';
import 'auth/auth_util.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:cwsorg/splash_screen/splash_screen_widget.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'my_tasks/my_tasks_widget.dart';
import 'completed_tasks/completed_tasks_widget.dart';
import 'my_profile/my_profile_widget.dart';
import 'surveyform/surveyform_widget.dart';
import 'projectlist/projectlist_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<CwsorgFirebaseUser> userStream;
  CwsorgFirebaseUser initialUser;
  bool displaySplashImage = true;
  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();
    userStream = cwsorgFirebaseUserStream()
      ..listen((user) => initialUser ?? setState(() => initialUser = user));
    Future.delayed(
        Duration(seconds: 1), () => setState(() => displaySplashImage = false));
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CWSORG',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(primarySwatch: Colors.teal
      ),
      home: initialUser == null || displaySplashImage
          ? Container(
              color: Colors.transparent,
              child: Center(
                child: Builder(
                  builder: (context) => Image.asset(
                    'assets/images/todo_0.0_Splash@3x.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            )
          : currentUser.loggedIn
              ? NavBarPage()
              : SplashScreenWidget(),
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key key, this.initialPage}) : super(key: key);

  final String initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'myTasks';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'myTasks': MyTasksWidget(),
      'CompletedTasks': CompletedTasksWidget(),
      'MyProfile': MyProfileWidget(),
    };
    return Scaffold(
      body: tabs[_currentPage],
      appBar: AppBar(title: Text('CWSORG')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.playlist_add,
              size: 32,
            ),
            activeIcon: Icon(
              Icons.playlist_add,
              size: 32,
            ),
            label: 'My Work',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.alarm_on,
              size: 32,
            ),
            activeIcon: Icon(
              Icons.alarm_on,
              size: 32,
            ),
            label: 'Completed',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 32,
            ),
            activeIcon: Icon(
              Icons.person_sharp,
              size: 32,
            ),
            label: 'Home',
            tooltip: '',
          )
        ],
        backgroundColor: FlutterFlowTheme.primaryBlack,
        currentIndex: tabs.keys.toList().indexOf(_currentPage),
        selectedItemColor: FlutterFlowTheme.primaryColor,
        unselectedItemColor: FlutterFlowTheme.tertiaryColor,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(66, 190, 165, 1.0),
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfileWidget()),
                  );
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Attendance'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Survey Forms'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SurveyformWidget()),
                  );
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Projects'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectlistWidget()),
                  );
                  // Update the state of the app.
                  // ...
                },
              ),

              ListTile(
                title: const Text('Knowledge Center'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),

            ],
          ),
        ),
    );
  }
}
