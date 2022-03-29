import 'package:flutter/material.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.transparent,
        child: Stack(children: [
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/nedaanLogo.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: child,
          ),
        ]),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}
