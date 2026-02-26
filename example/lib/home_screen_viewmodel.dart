import 'package:viewmodel_flutter/flutter_viewmodel.dart';
import 'package:viewmodel_flutter/states.dart';

class HomeScreenViewModel extends ViewModel {
  late MutableState<int> counter;

  @override
  void init() {
    counter = mutableStateOf(0);
  }
}
