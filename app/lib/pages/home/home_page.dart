import 'package:app/pages/measure/measures_page.dart';
import 'package:app/pages/moviment/moviment_api.dart';
import 'package:app/pages/moviment/moviment_page.dart';
import 'package:app/pages/trigger/add_trigger_page.dart';
import 'package:app/pages/trigger/trigger_page.dart';
import 'package:app/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              //Icon(Icons.notifications_active, color: Colors.white))
            ],
          ),
        ),
        body: _body(),
        //floatingActionButton: _floatActionButton(),
      ),
    );
  }

  _body() {
    return TabBarView(children: [
      MeasuresPage(),
      MovimentPage(),
    ]);
  }

  _floatActionButton() {
    return Container(
      child: FloatingActionButton(
          onPressed: _onClickAddAlert,
          child: FaIcon(
            FontAwesomeIcons.arrowsAltH,
            color: Colors.white,
          )
          // Icon(Icons.add, color: Colors.white),
          ),
    );
  }

  _onClickAddAlert() {
    push(context, MovimentPage());
    //push(context, AddTriggerPage());
  }
}
