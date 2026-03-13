library viewmodel_flutter;

import 'package:flutter/widgets.dart';
import 'package:viewmodel_flutter/side_effects.dart';
import 'package:viewmodel_flutter/states.dart';

abstract class ViewModel extends ChangeNotifier {
  final List<SideEffect> _sideEffects = [];
  bool _disposed = false;

  bool get isDisposed => _disposed;

  void init();

  bool update([dynamic state]) {
    if (_disposed) {
      return false;
    }

    for (final sideEffect in _sideEffects) {
      if (state == null || sideEffect.dependencies.any((dep) => dep == state)) {
        sideEffect.effect();
        if (_disposed) {
          return false;
        }
      }
    }

    if (_disposed) {
      return false;
    }

    notifyListeners();
    return true;
  }

  MutableState<T> mutableStateOf<T>(T state) {
    return MutableState(state, this);
  }

  MutableStateList<T> mutableStateListOf<T>() {
    return MutableStateList(this);
  }

  MutableStateMap<K, V> mutableStateMapOf<K, V>() {
    return MutableStateMap(this);
  }

  void onAppLifecycleStateChanged(AppLifecycleState state) {}

  void sideEffect(VoidCallback effect, List<dynamic> dependencies) {
    _sideEffects.add(SideEffect(effect, dependencies));
  }

  @mustCallSuper
  @override
  void dispose() {
    _disposed = true;
    _sideEffects.clear();
    super.dispose();
  }
}
