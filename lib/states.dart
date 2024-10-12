import 'package:viewmodel/viewmodel.dart';

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
