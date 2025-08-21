import 'package:viewmodel_flutter/flutter_viewmodel.dart';

class MutableState<T> {
  T _state;
  final ViewModel _viewModel;

  MutableState(this._state, this._viewModel);

  T get state => _state;

  set state(T v) {
    _state = v;
    _viewModel.update(this);
  }

  T call([T? state]) {
    if (state != null) {
      this.state = state;
    }

    return this.state;
  }
}

class MutableStateList<T> implements Iterable<T> {
  final List<T> _list = [];
  final ViewModel _viewModel;

  MutableStateList(this._viewModel);

  T operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, T value) {
    _list[index] = value;
    _viewModel.update(this);
  }

  int indexOf(T value) {
    return _list.indexOf(value);
  }

  void insert(int index, T value) {
    _list.insert(index, value);
    _viewModel.update(this);
  }

  void insertAll(int index, Iterable<T> value) {
    _list.insertAll(index, value);
    _viewModel.update(this);
  }

  void add(T value) {
    _list.add(value);
    _viewModel.update(this);
  }

  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    _viewModel.update(this);
  }

  void replaceAll(Iterable<T> iterable) {
    _list.clear();
    _list.addAll(iterable);
    _viewModel.update(this);
  }

  Iterable<T> get reversed => _list.reversed;

  void clear() {
    _list.clear();
    _viewModel.update(this);
  }

  void remove(T value) {
    _list.remove(value);
    _viewModel.update(this);
  }

  void removeAt(int index) {
    _list.removeAt(index);
    _viewModel.update(this);
  }

  void removeWhere(bool Function(T) test) {
    _list.removeWhere(test);
    _viewModel.update(this);
  }

  @override
  bool any(bool Function(T element) test) {
    return _list.any(test);
  }

  @override
  Iterable<R> cast<R>() {
    return _list.cast<R>();
  }

  @override
  bool contains(Object? element) {
    return _list.contains(element);
  }

  @override
  T elementAt(int index) {
    return _list.elementAt(index);
  }

  @override
  bool every(bool Function(T element) test) {
    return _list.every(test);
  }

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) toElements) {
    return _list.expand(toElements);
  }

  @override
  T get first => _list.first;

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _list.firstWhere(test, orElse: orElse);
  }

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) {
    return _list.fold(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return _list.followedBy(other);
  }

  @override
  void forEach(void Function(T element) action) {
    return _list.forEach(action);
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  String join([String separator = ""]) {
    return _list.join(separator);
  }

  @override
  T get last => _list.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _list.lastWhere(test, orElse: orElse);
  }

  @override
  int get length => _list.length;

  @override
  Iterable<E> map<E>(E Function(T e) toElement) {
    return _list.map(toElement);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return _list.reduce(combine);
  }

  @override
  T get single => _list.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _list.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return _list.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return _list.skipWhile(test);
  }

  @override
  Iterable<T> take(int count) {
    return _list.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    return _list.takeWhile(test);
  }

  @override
  List<T> toList({bool growable = true}) {
    return _list.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    return _list.toSet();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return _list.where(test);
  }

  @override
  Iterable<R> whereType<R>() {
    return _list.whereType();
  }
}

class FutureState<T> {
  final Future<T> _future;
  final ViewModel _viewModel;

  T? _state;
  Object? _error;
  bool _loading = true;

  T? get state => _state;

  Object? get error => _error;

  bool get loading => _loading;

  FutureState(
    this._future,
    this._viewModel,
  ) {
    resolve();
  }

  void resolve() {
    this._future.then((value) {
      _state = value;
      _loading = false;
      this._viewModel.update(this);
    }).catchError((error) {
      _state = null;
      _error = error;
      this._viewModel.update(this);
    });
  }
}


/// A reactive Map that notifies a [ViewModel] when its contents are modified.
///
/// Use this class within a ViewModel to hold map state. Any mutation operations
/// like adding, removing, or updating entries will automatically call the
/// ViewModel's update method, triggering a rebuild in listening widgets.
class MutableStateMap<K, V> implements Map<K, V> {
  final Map<K, V> _map = {};
  final ViewModel _viewModel;

  MutableStateMap(this._viewModel);

  //
  // Mutating methods that trigger updates
  //

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
    _viewModel.update(this);
  }

  @override
  void addAll(Map<K, V> other) {
    _map.addAll(other);
    _viewModel.update(this);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _map.addEntries(newEntries);
    _viewModel.update(this);
  }

  @override
  void clear() {
    _map.clear();
    _viewModel.update(this);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    // This method might or might not modify the map. For simplicity and to
    // ensure reactivity, we trigger an update regardless.
    final result = _map.putIfAbsent(key, ifAbsent);
    _viewModel.update(this);
    return result;
  }

  @override
  V? remove(Object? key) {
    final result = _map.remove(key);
    _viewModel.update(this);
    return result;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _map.removeWhere(test);
    _viewModel.update(this);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final result = _map.update(key, update, ifAbsent: ifAbsent);
    _viewModel.update(this);
    return result;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _map.updateAll(update);
    _viewModel.update(this);
  }

  //
  // Read-only methods that delegate to the internal map
  //

  @override
  V? operator [](Object? key) => _map[key];

  @override
  Map<RK, RV> cast<RK, RV>() => _map.cast<RK, RV>();

  @override
  bool containsKey(Object? key) => _map.containsKey(key);

  @override
  bool containsValue(Object? value) => _map.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  @override
  void forEach(void Function(K key, V value) action) => _map.forEach(action);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) =>
      _map.map(convert);

  @override
  Iterable<V> get values => _map.values;
}