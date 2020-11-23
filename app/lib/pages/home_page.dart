import 'package:app/pages/measure/measures_page.dart';
import 'package:app/pages/moviment/moviment_page.dart';
import 'package:app/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'device/devices_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Luminosity', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.insert_chart, color: Colors.white)),
              Tab(
                icon: FaIcon(
                  FontAwesomeIcons.arrowsAltH,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: FaIcon(
                  FontAwesomeIcons.microchip,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: _body(),
      ),
    );
  }

  _body() {
    return TabBarView(children: [
      MeasuresPage(),
      MovimentPage(),
      DevicesPage(),
    ]);
  }
}
