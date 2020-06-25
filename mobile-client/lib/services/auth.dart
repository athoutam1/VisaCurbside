import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(user.uid) : null;
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential);
    // final AuthResult authResult = await _auth.signInWithCredential(credential);
    // final FirebaseUser user = authResult.user;

    final FirebaseUser currentUser = await _auth.currentUser();

    // save persistent data
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(_userFromFirebaseUser(currentUser)));

    await http.post('http://localhost:3005/user/createUser', body: {
      "id": currentUser.uid,
      "name": currentUser.displayName,
      "email": currentUser.email
    });

    return _userFromFirebaseUser(currentUser);
  }

  // auth changes
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signOut() async {
    // await googleSignIn.signOut();
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    print("User Sign Out");
  }
}
