import 'package:flutter/material.dart';
import 'package:viewmodel_flutter/flutter_viewmodel.dart';
import 'package:viewmodel_flutter/states.dart';
import 'package:viewmodel_flutter/viewmodel_builder.dart';

class StaleViewModelDemoScreen extends StatefulWidget {
  const StaleViewModelDemoScreen({super.key});

  @override
  State<StaleViewModelDemoScreen> createState() =>
      _StaleViewModelDemoScreenState();
}

class _StaleViewModelDemoScreenState extends State<StaleViewModelDemoScreen> {
  String selectedUserId = 'user-A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stale ViewModel Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Switch user below. Both panels receive the same parent value.\n'
              'Broken panel does not use viewModelKey; fixed panel does.',
            ),
            const SizedBox(height: 12),
            Text('Parent selectedUserId: $selectedUserId'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => selectedUserId = 'user-A');
                  },
                  child: const Text('Select user-A'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => selectedUserId = 'user-B');
                  },
                  child: const Text('Select user-B'),
                ),
              ],
            ),
            const Divider(height: 32),
            _BrokenProfileSection(userId: selectedUserId),
            const Divider(height: 32),
            _FixedProfileSection(userId: selectedUserId),
          ],
        ),
      ),
    );
  }
}

class _BrokenProfileSection extends StatelessWidget {
  final String userId;

  const _BrokenProfileSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>(
      viewModelBuilder: () => ProfileViewModel(userId: userId),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Broken (without viewModelKey):'),
            Text('Widget input userId: $userId'),
            Text('ViewModel userId: ${viewModel.userId.state}'),
            Text('init count: ${viewModel.initCount.state}'),
            const SizedBox(height: 8),
            const Text(
              'Expected: ViewModel userId should match Widget input userId.\nActual here: it can stay stale after switching users.',
            ),
          ],
        );
      },
    );
  }
}

class _FixedProfileSection extends StatelessWidget {
  final String userId;

  const _FixedProfileSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>(
      viewModelKey: userId,
      viewModelBuilder: () => ProfileViewModel(userId: userId),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fixed (with viewModelKey):'),
            Text('Widget input userId: $userId'),
            Text('ViewModel userId: ${viewModel.userId.state}'),
            Text('init count: ${viewModel.initCount.state}'),
            const SizedBox(height: 8),
            const Text(
              'Here the ViewModel is recreated when userId identity changes, so values stay aligned.',
            ),
          ],
        );
      },
    );
  }
}

class ProfileViewModel extends ViewModel {
  final String constructorUserId;

  late MutableState<String> userId;
  late MutableState<int> initCount;

  ProfileViewModel({required String userId}) : constructorUserId = userId;

  @override
  void init() {
    userId = mutableStateOf(constructorUserId);
    initCount = mutableStateOf(1);
  }
}
