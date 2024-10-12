import 'package:flutter/foundation.dart';

class SideEffect {
  final VoidCallback effect;
  final List<dynamic> dependencies;

  SideEffect(this.effect, this.dependencies);
}
