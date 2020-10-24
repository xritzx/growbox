import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class TargetAndDisplay extends StatefulWidget {
  String set_param, get_param;
  TargetAndDisplay({Key key, this.set_param, this.get_param}) : super(key: key);

  @override
  _TargetAndDisplayState createState() => _TargetAndDisplayState();
}

class _TargetAndDisplayState extends State<TargetAndDisplay> {
  @override
  int _target;
  int _temp;
  bool _loading = true;
  final database = FirebaseDatabase.instance.reference().child('xritzx');
  @override
  void initState() {
    getInitState();
    super.initState();
  }

  Future<void> getInitState() async {
    await database.child(widget.set_param).once().then((DataSnapshot snapshot) {
      setState(() {
        _target = snapshot.value;
      });
    });
    await database.child(widget.get_param).once().then((DataSnapshot snapshot) {
      setState(() {
        _temp = snapshot.value;
        _loading = false;
      });
    });
  }

  Future<void> _updateDatabase() async {
    await database.update({widget.set_param: _target});
  }

  Widget build(BuildContext context) {
    return _loading
        ? SizedBox(
            height: 200,
            child: Center(
              child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50,
                  color: Colors.green[200]),
            ),
          )
        : Container(
            child: SizedBox(
              width: 500,
              height: 200,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                color: Color.fromARGB(100, 160, 200, 100),
                child: Row(
                  children: [
                    Text(
                      "🌱\n" + _temp.toString() + "°C",
                      style: TextStyle(
                        letterSpacing: 0.6,
                        wordSpacing: 5,
                        fontSize: 50,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      child: SingleCircularSlider(
                        20,
                        (_target - 15),
                        height: 150,
                        width: 160,
                        baseColor: Color.fromARGB(60, 0, 0, 0),
                        selectionColor: Color.fromARGB(140, 0, 0, 0),
                        child: Center(
                            child: Text(
                          " Target\n🌡️" + _target.toString() + "°C",
                          style: TextStyle(
                            // GLOBALISE
                            letterSpacing: 0.6,
                            wordSpacing: 5,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            // fontFamily: 'Robota'
                          ),
                        )),
                        onSelectionChange: (i, e, l) {
                          print(e);
                          setState(() => _target = e + 15);
                        },
                        onSelectionEnd: (i, e, l) {
                          _updateDatabase();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
