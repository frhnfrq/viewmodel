library viewmodel;

import 'package:flutter/widgets.dart';
import 'package:viewmodel/states.dart';

abstract class ViewModel extends ChangeNotifier {
  void initialize();

  void update() {
    notifyListeners();
  }

  MutableState<T> mutableStateOf<T>(T state) {
    return MutableState(state, this);
  }

  MutableStateList<T> mutableStateListOf<T>() {
    return MutableStateList(this);
  }

  void onAppLifecycleStateChanged(AppLifecycleState state) {}
}
