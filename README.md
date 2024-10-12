# ViewModel for Flutter

**ViewModel** is a state management library inspired by Android's ViewModel architecture. It is designed to simplify state management in Flutter apps, allowing you to separate your business logic from UI code while providing lifecycle-aware side effects management.

## Key Features

- **Separation of Concerns:** Cleanly separates your UI code from business logic.
- **State Management:** Simple APIs for mutable states and lists, enabling easy state management.
- **Side Effects Management:** Automatically handle side effects through dependencies when state changes.
- **No Boilerplate:** Minimal setup with easy-to-use builder functions for reactive UI updates.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  viewmodel: latest_version
```

Then run:

```bash
flutter pub get
```


## Example

Here’s a simple example of how to use this package to wire up a simple counter:

```dart
class CounterViewModel extends ViewModel {
  
  // late is used so that we can initialize the mutable states with the helper functions in init()
  late MutableState<int> counter;
  late MutableState<String> username;

  @override
  void init() {
    counter = mutableStateOf(0);
    username = mutableStateOf("Guest");
  }

  void increment() {
    counter.state++;
  }
  
  void updateUsername(String newUsername) {
    // username.state = newUsername;
    username(newUsername); // It's an alternative, a syntactic sugar for the above line to update the state.
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CounterViewModel>(
      viewModelBuilder: () => CounterViewModel(), // You can pass dependencies through the view model's constructor
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(title: Text("Counter Example")),
          body: Center(
            child: Column(
              children: [
                Text("User: ${viewModel.username()}"), // You can call the state itself to get the value, instead of viewModel.counter.state
                Text("Counter: ${viewModel.counter()}"),
              ]
            ), 
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              viewModel.increment();
              viewModel.updateUsername("Farhan");
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
```

## Overview
`ViewModel` is the core class that holds your app's business logic and state. Create your own ViewModel by extending it. 
Override the `init()` method which is called when your ViewModel is attached to the UI. Initialize your states and add side effects in this method. 

### MutableState
Wrap your state T with MutableState<T> so that it can be observed and update the UI when it's mutated. For simplicity, use `mutableStateOf<T>(T state)` helper function to create mutable states.

Though, you'll be able to get and set the value of the state with the `MutableState<T>.state` field, syntactic sugars are available to simplify this. Please refer to the example above.

### MutableStateList
Creates a mutable list state, allowing you to handle list operations like adding, removing, or updating elements, with reactive UI updates. For simplicity, use `mutableStateListOf<T>()` helper function to create mutable state lists.
It's a wrapper of List, so you can interact with `MutableStateList` just like a List. Updating any item will trigger the UI to update;

### LifeCycle
You can override `onAppLifecycleStateChanged(AppLifecycleState state)` in your `ViewModel` to receive lifecycle updates when the app's lifecycle state changes.

### ViewModelBuilder
The `ViewModelBuilder` widget simplifies building the UI by providing your `ViewModel` instance to the widget tree. The UI will rebuild whenever any of the state changes.

### ViewModelProvider
Though, you can get access to your `ViewModel` from the widget builder of `ViewModelBuilder`, you can also get access to your `ViewModel` through the `ViewModelProvider`. In your `build(context)` method, use `YourViewModel viewModel = ViewModelProvider.of<YourViewModel>(context);` or you can use the helper extension function on `BuildContext`, `YourViewModel viewModel = context.viewModel<YourViewModel>();`
This becomes handy when you need to access the viewModel further down the widget tree, specially a widget defined in another file.

### Side Effect
You can create side effects that trigger when certain state variables change. This is useful for cases where state changes should trigger API calls, analytics events, or other non-UI logic. It's preferable to create side effects in the `init` method.
Example:
```dart
@override
void init() {
  // states
  counter = mutableStateOf(0);
  // side effects
  sideEffect(() {
    // Do something
  }, [counter]);
}
```

All side effects are called exactly once when the UI builds for the first time. Then, any change in the dependencies triggers the side effects to be run again.

In this example, the side effect is triggered whenever `username` is updated.

## Note
This package is at the very initial stage. Feel free to explore the code and contribute to the development of the package. We hope it simplifies your state management process and improves the structure of your Flutter apps!