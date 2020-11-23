import 'package:app/entitys/measure.dart';
import 'package:app/pages/measure/measures_bloc.dart';
import 'package:app/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MeasuresPage extends StatefulWidget {
  @override
  _MeasuresPageState createState() => _MeasuresPageState();
}

class _MeasuresPageState extends State<MeasuresPage> {
  List<Measure> sensors;

  final _bloc = MeasuresBloc();

  @override
  void initState() {
    super.initState();
    _bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Measure>>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Não foi possível buscar os dados'));
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          sensors = snapshot.data;
          return _listView(snapshot.data.reversed.toList());
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  _listView(List<Measure> data) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final measure = data[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//              _alertItem(alert),
                _measureItem(measure),
                Divider(),
              ],
            ),
          );
        },
      ),
      onRefresh: () => _bloc.fetch(),
      backgroundColor: Colors.white,
    );
  }

  _getIcon(String type) {
    if (type == 'air_moisture') {
      return Icon(Icons.opacity, color: Colors.blueAccent, size: 20);
    } else if (type == 'luminosity') {
      return Icon(Icons.wb_sunny, color: Colors.yellow[700], size: 20);
    } else if (type == 'temperature') {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.thermometerHalf,
            size: 20,
            color: Colors.red,
          ),
        ),
      );
    }
    return Icon(Icons.opacity);
  }

  _measureItem(Measure measure) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getIcon("temperature"),
                SizedBox(width: 16),
                Label('${measure.temperature} ºC'),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getIcon("air_moisture"),
                SizedBox(width: 6),
                Label('${measure.moisture} %'),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getIcon("luminosity"),
                SizedBox(width: 16),
                Label('${measure.luminosity} %'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
