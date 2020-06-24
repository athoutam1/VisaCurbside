import 'package:flutter/cupertino.dart';
import './screens/home/home.dart';
import './screens/login/login.dart';
import './models/user.dart';
import 'package:provider/provider.dart';

class AuthListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Login();
    } else {
      return Home();
    }
  }
}
