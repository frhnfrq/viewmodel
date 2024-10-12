library viewmodel;

import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:viewmodel/side_effects.dart';
import 'package:viewmodel/states.dart';

abstract class ViewModel extends ChangeNotifier {
  final List<SideEffect> _sideEffects = [];

  void init();

  void update(dynamic state) {
    for (var sideEffect in _sideEffects) {
      if (state != null) {
        if (sideEffect.dependencies.any((dep) => dep == state)) {
          sideEffect.effect();
        }
      } else {
        sideEffect.effect();
      }
    }
    notifyListeners();
  }

  MutableState<T> mutableStateOf<T>(T state) {
    return MutableState(state, this);
  }

  MutableStateList<T> mutableStateListOf<T>() {
    return MutableStateList(this);
  }

  void onAppLifecycleStateChanged(AppLifecycleState state) {}

  void sideEffect(VoidCallback effect, List<dynamic> dependencies) {
    _sideEffects.add(SideEffect(effect, dependencies));
  }
}
