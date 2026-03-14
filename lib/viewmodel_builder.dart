import 'package:flutter/widgets.dart';
import 'package:viewmodel_flutter/flutter_viewmodel.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  final Object? viewModelKey;
  final T Function() viewModelBuilder;
  final Widget Function(BuildContext context, T viewModel) builder;

  const ViewModelBuilder({
    super.key,
    this.viewModelKey,
    required this.viewModelBuilder,
    required this.builder,
  });

  @override
  State<ViewModelBuilder<T>> createState() {
    return _ViewModelBuilderState<T>();
  }
}

class _ViewModelBuilderState<T extends ViewModel>
    extends State<ViewModelBuilder<T>> with WidgetsBindingObserver {
  late T viewModel;
  late VoidCallback _listener;

  void _createAndBindViewModel() {
    viewModel = widget.viewModelBuilder();
    viewModel.init();
    viewModel.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.update();
    });
  }

  void _disposeViewModel() {
    viewModel.removeListener(_listener);
    viewModel.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listener = () {
      if (mounted) {
        setState(() {});
      }
    };
    _createAndBindViewModel();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant ViewModelBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModelKey != widget.viewModelKey) {
      _disposeViewModel();
      _createAndBindViewModel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    viewModel.onAppLifecycleStateChanged(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<T>._create(
      notifier: viewModel,
      child: Builder(
        builder: (providerContext) {
          return widget.builder(providerContext, viewModel);
        },
      ),
    );
  }
}

class ViewModelProvider<T extends ViewModel> extends InheritedNotifier<T> {
  const ViewModelProvider._create({
    super.key,
    required super.notifier,
    required super.child,
  });

  static T? maybeOf<T extends ViewModel>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ViewModelProvider<T>>()
        ?.notifier;
  }

  static T of<T extends ViewModel>(BuildContext context) {
    final viewModel = maybeOf<T>(context);
    if (viewModel == null) {
      throw FlutterError(
        'No ViewModelProvider<$T> found in context.\n'
        'Make sure this widget is under a ViewModelBuilder<$T> in the widget tree.',
      );
    }

    return viewModel;
  }
}

extension ViewModelProviderExtension on BuildContext {
  T? maybeViewModel<T extends ViewModel>() {
    return ViewModelProvider.maybeOf<T>(this);
  }

  T viewModel<T extends ViewModel>() {
    return ViewModelProvider.of<T>(this);
  }
}
