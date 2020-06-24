import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/services/auth.dart';
import '../../services/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login Page",
          ),
          Center(
            // child: _signInButton(context),
            child: CupertinoButton.filled(
              child: Text("log in"),
              onPressed: () async {
                dynamic user = await _auth.signInWithGoogle();
                if (user == null) {
                  print("Error signing in");
                } else {
                  print("Signed in ${user.uid}");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: CupertinoPageScaffold(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Login Page",
//             ),
//             Center(
//               child: _signInButton(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _signInButton(BuildContext context) {
//   return OutlineButton(
//     splashColor: Colors.grey,
//     onPressed: () async {
//       FirebaseUser user = await signInWithGoogle();
//       print('Signed in ${user.email}');
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (BuildContext context) => Home()));
//     },
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//     highlightElevation: 0,
//     borderSide: BorderSide(color: Colors.grey),
//     child: Padding(
//       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Image(
//               image: AssetImage("lib/assets/images/google_logo.png"),
//               height: 35.0),
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Text(
//               'Sign in with Google',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.grey,
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
