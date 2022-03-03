import 'package:flutter/material.dart';

class CommonCardHeader extends StatefulWidget {
  const CommonCardHeader({Key? key}) : super(key: key);

  @override
  State<CommonCardHeader> createState() => _CommonCardHeaderState();
}

class _CommonCardHeaderState extends State<CommonCardHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          Text(
            "Monday\n02 February 2022",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 20),
          Text(
            "Kuala Lumpur",
            style: Theme.of(context).textTheme.headline5,
          ),
          const Divider(
            thickness: 1,
            height: 108,
            color: Colors.black,
          ),
      ],
    );
  }
}