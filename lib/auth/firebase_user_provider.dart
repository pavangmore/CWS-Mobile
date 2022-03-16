import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class CwsorgFirebaseUser {
  CwsorgFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

CwsorgFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<CwsorgFirebaseUser> cwsorgFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<CwsorgFirebaseUser>((user) => currentUser = CwsorgFirebaseUser(user));
