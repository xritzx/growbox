import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/loading.dart';

class AutoController extends StatefulWidget {
  final String param, name;
  AutoController({Key key, this.param, this.name}) : super(key: key);

  @override
  _AutoControllerState createState() => _AutoControllerState();
}

class _AutoControllerState extends State<AutoController> {
  final database = FirebaseDatabase.instance.reference().child('xritzx');
  bool _autoStuff = false;
  bool _manualOn = false;
  bool _loading = false;

  @override
  void initState() {
    getInitState();
    super.initState();
  }

  Future<void> getInitState() async {
    await database.child(widget.param).once().then((DataSnapshot snapshot) {
      setState(() {
        _autoStuff = snapshot.value == 2 ? true : false;
        _manualOn = snapshot.value == 1 ? true : false;
        _loading = false;
      });
    });
  }

  Future<void> _updateDatabase(bool autoStuff, bool manualMode) async {
    int upState = 0;
    if (autoStuff)
      upState = 2;
    else if (manualMode) upState = 1;
    await database.update({widget.param: upState});
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: Loading(
                indicator: BallGridPulseIndicator(),
                size: 50,
                color: Colors.green[200]),
          )
        : Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Container(
                    child: Center(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          // GLOBALISE
                          letterSpacing: 5,
                          wordSpacing: 10,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          // fontFamily: 'Robota'
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      FlatButton(
                          color: _autoStuff ? Colors.black : Colors.black45,
                          textColor: _autoStuff ? Colors.white : Colors.white24,
                          child: Text(
                              _autoStuff ? "Auto Enabled" : "Auto Disabled"),
                          onPressed: () => setState(() {
                                _autoStuff = !_autoStuff;
                                _updateDatabase(_autoStuff, _manualOn);
                              })),
                      SizedBox(
                        width: 20,
                      ),
                      FlatButton(
                        color: _manualOn
                            ? Color.fromARGB(200, 120, 200, 100)
                            : Color.fromARGB(200, 255, 70, 72),
                        textColor: _manualOn ? Colors.black : Colors.white,
                        disabledColor: Colors.black54,
                        disabledTextColor: Colors.white24,
                        child: Text(_manualOn ? "ON" : "OFF"),
                        onPressed: !_autoStuff
                            ? () => setState(() {
                                  _manualOn = !_manualOn;
                                  _updateDatabase(_autoStuff, _manualOn);
                                })
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
