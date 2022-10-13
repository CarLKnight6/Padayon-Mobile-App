import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
// ignore: unused_import
import 'package:io/ansi.dart';
import 'package:padayon/startyourjourneyscreens/home_page.dart';
// ignore: unused_import
import 'package:padayon/widget/button_widget.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'START YOUR JOURNEY',
              body: 'padayon app',
              image: buildImage('assets/image1.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Padayon: A Mental Health App',
              body: 'Available right at your fingerprints',
              image: buildImage('assets/image2.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'How was your day?',
              body: 'I hope youre doing fine',
              image: buildImage('assets/image3.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Today may seem bad but tomorrow is a hope to continue',
              body: 'Start your journey with us',
              // footer: ButtonWidget(
              //   color: Color.fromRGBO(8, 120, 93, 3),
              //   text: 'Enter padayon',
              //   onClicked: () =>
              //       Navigator.of(context).pushNamed('/loginscreen'),
              // ),
              image: buildImage('assets/image4.jpg'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Done',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          onDone: () => Navigator.of(context).pushNamed('/loginscreen'),
          showSkipButton: true,
          skip: Text('Skip', style: TextStyle(color: Colors.white)),
          onSkip: () => Navigator.of(context).pushNamed('/loginscreen'),
          next: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          globalBackgroundColor: Color.fromRGBO(8, 120, 93, 3),
          skipFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Colors.white,
        activeColor: Colors.black,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
