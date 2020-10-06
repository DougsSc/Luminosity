import 'package:app/entitys/measure.dart';
import 'package:app/pages/measure/measures_api.dart';
import 'package:app/utils/simple_bloc.dart';

class MeasuresBloc extends SimpleBloc<List<Measure>> {

  fetch() async {
    try {
      add(await MeasuresApi.measures());
    } catch(e) {
      print(e);
      addError(e);
    }
  }
}