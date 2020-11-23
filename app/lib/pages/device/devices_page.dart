import 'dart:async';

import 'package:app/entitys/device.dart';
import 'package:app/utils/alert.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/dividing_line.dart';
import 'package:app/widgets/label.dart';
import 'package:app/widgets/text_field.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DevicesPage extends StatefulWidget {
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<Device> _devices = [];

  final _devicesController = StreamController<List<Device>>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Divider(),
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              child: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right),
            ),
            onTap: _onClickAddDevice,
            title: Text('Adicionar Dispositivo'),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<List<Device>>(
              stream: _devicesController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Container();
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                _devices = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(left: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _devices.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _cardItem(_devices[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _cardItem(Device device) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.microchip,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => _onClickDeleteDevice(device),
          ),
          title: Text('${device.name}'),
          subtitle: Text(device.token),
        ),
        Divider(),
      ],
    );
  }

  _loadCards() async {
    List<Device> devices = [
      Device(
        id: 1,
        name: 'Sala',
        token: '032f2728-78bc-4aee-ab09-3f58b48f4e80',
      ),
      Device(
        id: 2,
        name: 'Cozinha',
        token: '032f2728-78bc-4aee-ab09-3f58b48f4e80',
      ),
    ];

    _devicesController.add(devices);
  }

  _onClickAddDevice() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 50, child: DividingLine()),
                SizedBox(height: 24),
                Label('Nome do dispositivo'),
                SizedBox(height: 8),
                DefaultTextField('Nome'),
                SizedBox(height: 16),
                Row(children: <Widget>[
                  Expanded(
                    child: DefaultButton(
                      'Adicionar',
                      onPressed: _onOpenQrScanner,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );

    _onOpenQrScanner();
  }

  _onOpenQrScanner() async {
    Navigator.pop(context);

    final options = ScanOptions(
      strings: {
        "cancel": 'Cancelar',
        "flash_on": 'Flash ligado',
        "flash_off": 'Flash desligado',
      },
      restrictFormat: [BarcodeFormat.qr],
    );

    final result = await BarcodeScanner.scan(options: options);

    print('result.rawContent: ${result.rawContent}');

    showSnackBar(_scaffoldKey, 'Dispositivo adicionado com sucesso!');
  }

  _deleteDevice(Device device) async {
    Navigator.pop(context);

    showLoadingSnackBar(_scaffoldKey, 'Removendo dispositivo...');
    await Future.delayed(Duration(seconds: 3));
    showSnackBar(_scaffoldKey, 'Dispositivo removido com sucesso!');
  }

  _onClickDeleteDevice(Device device) {
    showBottomQuestion(
      context,
      'Remover Dispositivo',
      'Você deseja remover o dispositivo ${device.name}?',
      DefaultButton('Remover', onPressed: () => _deleteDevice(device)),
    );
  }

  @override
  void dispose() {
    _devicesController.close();
    super.dispose();
  }
}
