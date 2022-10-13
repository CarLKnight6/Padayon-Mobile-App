import 'package:flutter/material.dart';
import 'package:padayon/settaskscreens/datepicker.dart';

class Epap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.green[900],
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.green[900]),
            ),
            home: Scaffold(
              body: Center(
                child: DatePicker(),
              ),
            )),
        onWillPop: () async {
          return false;
        });
  }
}
