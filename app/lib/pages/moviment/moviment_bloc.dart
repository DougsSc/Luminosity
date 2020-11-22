import 'package:app/entitys/measure.dart';
import 'package:app/pages/moviment/moviment_api.dart';
import 'package:app/utils/simple_bloc.dart';

class MovimentBloc extends SimpleBloc<List<Measure>> {

  Future fetch(value) async {
    try {
      await MovimentApi.move(value);
    } catch(e) {
      print(e);
      addError(e);
    }
  }
}