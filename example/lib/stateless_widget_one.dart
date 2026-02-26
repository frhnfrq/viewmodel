import 'package:flutter/material.dart';

class StatelessWidgetOne extends StatelessWidget {
  const StatelessWidgetOne({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Built Stateless Widget One');
    return Text('Stateless Widget One');
  }
}
