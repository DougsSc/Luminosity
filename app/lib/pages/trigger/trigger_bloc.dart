import 'package:app/entitys/trigger.dart';
import 'package:app/pages/trigger/trigger_api.dart';
import 'package:app/utils/simple_bloc.dart';

class TriggerBloc extends SimpleBloc<List<Trigger>> {

  fetch() async {
    try {
      add(await TriggerApi.alerts());
    } catch(e) {
      print(e);
      addError(e);
    }
  }
}