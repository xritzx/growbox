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
  bool _loading = true;

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
        ? SizedBox(
            height: 230,
            child: Center(
              child: Loading(
                  indicator: BallGridPulseIndicator(),
                  size: 50,
                  color: Colors.green[200]),
            ),
          )
        : Container(
            color: Colors.transparent,
            child: Container(
              decoration: new BoxDecoration(
                  color: Color.fromARGB(30, 70, 200, 55),
                  borderRadius: new BorderRadius.only(
                    bottomRight: const Radius.circular(50.0),
                  )),
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          // GLOBALISE
                          letterSpacing: 0.6,
                          wordSpacing: 5,
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          // fontFamily: 'Robota'
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        FlatButton(
                            color: _autoStuff ? Colors.black87 : Colors.black45,
                            textColor:
                                _autoStuff ? Colors.white : Colors.white24,
                            child: Text(
                                _autoStuff ? "Auto Enabled" : "Auto Disabled"),
                            onPressed: () => setState(() {
                                  _autoStuff = !_autoStuff;
                                  _updateDatabase(_autoStuff, _manualOn);
                                })),
                        SizedBox(
                          width: 30,
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
            ),
          );
  }
}
