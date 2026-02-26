import 'package:example/stateless_widget_two_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:viewmodel_flutter/viewmodel_builder.dart';

class StatelessWidgetTwo extends StatelessWidget {
  const StatelessWidgetTwo({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Built Stateless Widget Two');
    return ViewModelBuilder<StatelessWidgetTwoViewModel>(
      viewModelBuilder: () {
        return StatelessWidgetTwoViewModel();
      },
      builder: (context, viewModel) {
        debugPrint('Built Stateless Widget Two Container');
        return Container(
          color: Colors.blue[100],
          child: Column(
            children: [
              Text('Stateless Widget Two'),
              Text(
                '${viewModel.counter.state}',
                style: TextStyle(fontSize: 20),
              ),
              TextButton(
                onPressed: () {
                  viewModel.counter(viewModel.counter() + 1);
                },
                child: Text('Update Stateless Widget Two'),
              ),
            ],
          ),
        );
      },
    );
  }
}
