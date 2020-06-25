import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/screens/onboarding/constants.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider({
    @required this.sliderImageUrl,
    @required this.sliderHeading,
    @required this.sliderSubHeading,
  });

}

final sliderArrayList = [
    Slider(
      sliderImageUrl: 'lib/assets/images/slider_1.png',
      sliderHeading: Constants.SLIDER_HEADING_1,
      sliderSubHeading: Constants.SLIDER_DESC
    ),
    Slider(
      sliderImageUrl: 'lib/assets/images/slider_2.png',
      sliderHeading: Constants.SLIDER_HEADING_2,
      sliderSubHeading: Constants.SLIDER_DESC
    ),
    Slider(
      sliderImageUrl: 'lib/assets/images/slider_3.png',
      sliderHeading: Constants.SLIDER_HEADING_3,
      sliderSubHeading: Constants.SLIDER_DESC
    ),
];