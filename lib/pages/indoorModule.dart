import 'package:flutter/material.dart';
import 'package:urbanfarmer/components/autoController.dart';
import 'package:urbanfarmer/components/setTarget.dart';

class IndoorModule extends StatelessWidget {
  const IndoorModule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          AutoController(param: 'autoLights', name: '💡Lights Control'),
          AutoController(param: 'autoTemp', name: '🌡️Temperature Control'),
          TargetAndDisplay(set_param: 'target', get_param: 'temp')
        ],
      ),
    );
  }
}
