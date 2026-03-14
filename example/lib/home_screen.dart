import 'package:example/home_screen_viewmodel.dart';
import 'package:example/provider_api_demo.dart';
import 'package:example/stale_viewmodel_demo.dart';
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StaleViewModelDemoScreen(),
                      ),
                    );
                  },
                  child: const Text('Open stale ViewModel demo'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProviderApiDemoScreen(),
                      ),
                    );
                  },
                  child: const Text('Open provider API demo'),
                ),
                const StatelessWidgetOne(),
                SizedBox(height: 20),
                const StatelessWidgetTwo(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              viewModel.counter(viewModel.counter.state + 1);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
