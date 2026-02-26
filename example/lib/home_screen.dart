import 'package:example/home_screen_viewmodel.dart';
import 'package:example/stateless_widget_one.dart';
import 'package:example/stateless_widget_two.dart';
import 'package:flutter/material.dart';
import 'package:viewmodel_flutter/viewmodel_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Built HomeScreen');
    return ViewModelBuilder<HomeScreenViewModel>(
      viewModelBuilder: () {
        return HomeScreenViewModel();
      },
      builder: (context, viewModel) {
        debugPrint('Built HomeScreen Scaffold');
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Flutter ViewModel Example'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  '${viewModel.counter.state}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const StatelessWidgetOne(),
                SizedBox(height: 20),
                const StatelessWidgetTwo(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              viewModel.counter(viewModel.counter() + 1);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
