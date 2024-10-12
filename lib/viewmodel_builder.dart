import 'package:flutter/widgets.dart';
import 'package:viewmodel/viewmodel.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  final T Function() viewModelBuilder;
  final Widget Function(BuildContext context, T viewModel) builder;

  const ViewModelBuilder({
    super.key,
    required this.viewModelBuilder,
    required this.builder,
  });

  @override
  State<ViewModelBuilder<T>> createState() {
    return _ViewModelBuilderState<T>();
  }
}

class _ViewModelBuilderState<T extends ViewModel>
    extends State<ViewModelBuilder<T>>
    with WidgetsBindingObserver {
  late T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModelBuilder();

    viewModel.init();
    viewModel.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      viewModel.update(null);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    viewModel.onAppLifecycleStateChanged(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<T>._create(
      notifier: viewModel,
      child: widget.builder(context, viewModel),
    );
  }
}

class ViewModelProvider<T extends ViewModel> extends InheritedNotifier {
  // final T viewModel;
  const ViewModelProvider._create({
    super.key,
    required super.notifier,
    required super.child,
  });

  static T of<T extends ViewModel>(BuildContext context) {
    final viewModel = context
        .dependOnInheritedWidgetOfExactType<ViewModelProvider<T>>()
        ?.notifier;

    assert(viewModel != null, "No appropriate ViewModel found in the context.");

    return viewModel! as T;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<Listenable> oldWidget) {
    return notifier != oldWidget.notifier;
  }
}

extension ViewModelProviderExtension on BuildContext {
  T viewModel<T extends ViewModel>() {
    return ViewModelProvider.of<T>(this);
  }
}
