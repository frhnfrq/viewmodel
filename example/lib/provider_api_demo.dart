import 'package:example/home_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:viewmodel_flutter/viewmodel_builder.dart';

class ProviderApiDemoScreen extends StatefulWidget {
  const ProviderApiDemoScreen({super.key});

  @override
  State<ProviderApiDemoScreen> createState() => _ProviderApiDemoScreenState();
}

class _ProviderApiDemoScreenState extends State<ProviderApiDemoScreen> {
  String? strictLookupMessage;

  @override
  Widget build(BuildContext context) {
    final maybeVm = context.maybeViewModel<HomeScreenViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('ViewModelProvider API Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Outside ViewModelBuilder scope:'),
          Text(
            'maybeViewModel result: ${maybeVm == null ? 'null (safe)' : 'found'}',
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              try {
                context.viewModel<HomeScreenViewModel>();
                setState(() {
                  strictLookupMessage = 'Unexpectedly found a ViewModel.';
                });
              } catch (error) {
                setState(() {
                  strictLookupMessage = error.toString();
                });
              }
            },
            child: const Text('Run strict viewModel lookup here'),
          ),
          if (strictLookupMessage != null) ...[
            const SizedBox(height: 8),
            Text('strict lookup output:\n$strictLookupMessage'),
          ],
          const Divider(height: 32),
          const Text('Inside ViewModelBuilder scope:'),
          ViewModelBuilder<HomeScreenViewModel>(
            viewModelBuilder: () => HomeScreenViewModel(),
            builder: (context, viewModel) {
              final scopedMaybe = context.maybeViewModel<HomeScreenViewModel>();
              final scopedStrict = context.viewModel<HomeScreenViewModel>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'maybeViewModel: ${scopedMaybe != null ? 'found' : 'null'}',
                  ),
                  Text('viewModel: found (${scopedStrict.runtimeType})'),
                  const SizedBox(height: 8),
                  Text('Counter: ${viewModel.counter.state}'),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.counter(viewModel.counter.state + 1);
                    },
                    child: const Text('Increment counter'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
