import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'moviment_bloc.dart';

class MovimentPage extends StatefulWidget {
  @override
  _MovimentPageState createState() => _MovimentPageState();
}

class _MovimentPageState extends State<MovimentPage> {
  final _bloc = MovimentBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Movimentar Persiana",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(32),
            child: Text(
              "Movimente a persiana de acordo com a porcentagem desejada!",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FlutterSlider(
                  centeredOrigin: true,
                  jump: true,
                  values: [50],
                  selectByTap: true,
                  handler: FlutterSliderHandler(
                    child: FaIcon(
                      FontAwesomeIcons.arrowsAltH,
                      color: Colors.blueAccent,
                    ),
                  ),
                  hatchMark: FlutterSliderHatchMark(
                    linesDistanceFromTrackBar: 5,
                    density: 1,
                    labels: [
                      FlutterSliderHatchMarkLabel(
                        percent: 0,
                        label: Text('0%'),
                      ),
                      FlutterSliderHatchMarkLabel(
                        percent: 100,
                        label: Text('100%'),
                      ),
                    ],
                  ),
                  fixedValues: [
                    FlutterSliderFixedValue(percent: 0, value: -50),
                    FlutterSliderFixedValue(percent: 10, value: -40),
                    FlutterSliderFixedValue(percent: 20, value: -30),
                    FlutterSliderFixedValue(percent: 30, value: -20),
                    FlutterSliderFixedValue(percent: 40, value: -10),
                    FlutterSliderFixedValue(percent: 50, value: 0),
                    FlutterSliderFixedValue(percent: 60, value: 10),
                    FlutterSliderFixedValue(percent: 70, value: 20),
                    FlutterSliderFixedValue(percent: 80, value: 30),
                    FlutterSliderFixedValue(percent: 90, value: 40),
                    FlutterSliderFixedValue(percent: 100, value: 50),
                  ],
                  onDragCompleted: (_, percent, __) {
                    // print('print: $percent');
                    var value = (percent * -1) / 100;
                    _bloc.fetch(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
