import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/screens/onboarding/slider_layout_view.dart';

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OnboardingState();
  
}

class OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody()
    );
  }

  Widget onBordingBody() => Container(
    child: SliderLayoutView(),
  );
  
}