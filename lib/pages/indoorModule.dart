import 'package:flutter/material.dart';
import 'package:urbanfarmer/components/autoController.dart';

class IndoorModule extends StatelessWidget {
  const IndoorModule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          AutoController(param: 'autoLights', name: 'Lights'),
          AutoController(param: 'autoTemp', name: 'Temperature Control'),
        ],
      ),
    );
  }
}
