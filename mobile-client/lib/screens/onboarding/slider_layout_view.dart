import 'package:flutter/material.dart';
import 'package:visa_curbside/screens/onboarding/constants.dart';
import 'package:visa_curbside/screens/onboarding/slide_dots.dart';
import 'package:visa_curbside/screens/onboarding/slider.dart';
import 'package:visa_curbside/screens/onboarding/slider_item.dart';

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SliderLayoutViewState();
  
}

class SliderLayoutViewState extends State<SliderLayoutView> {

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() => Container(
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: sliderArrayList.length,
            itemBuilder: (ctx,i)=>SliderItem(i),
          ),
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                  child: Text(
                    Constants.NEXT,
                    style: TextStyle(
                      fontFamily: Constants.OPEN_SANS,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                  child: Text(
                    Constants.SKIP,
                    style: TextStyle(
                      fontFamily: Constants.OPEN_SANS,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0
                    ),
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.bottomCenter,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < sliderArrayList.length; i++)
                      if (i == _currentPage)
                        SlideDots(true)
                      else
                        SlideDots(false)
                  ],
                )
              )
            ],
          )
        ],
      ),
    ),
  );
  
}