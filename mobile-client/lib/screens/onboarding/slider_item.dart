import 'package:flutter/material.dart';
import 'package:visa_curbside/screens/onboarding/constants.dart';
import 'package:visa_curbside/screens/onboarding/slider.dart';

class SliderItem extends StatelessWidget {

  final int index;
  SliderItem(this.index);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(sliderArrayList[index].sliderImageUrl)
            )
          ),
        ),
        SizedBox(
          height: 60.0
        ),
        Text(
          sliderArrayList[index].sliderHeading,
          style: TextStyle(
            fontFamily: Constants.POPPINS,
            fontWeight: FontWeight.w700,
            fontSize: 20.5
          ),
        ),
        SizedBox(
          height: 15.0
        )
      ],
    );
  }
  
}