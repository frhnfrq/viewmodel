## 0.1.1

* made ViewModel updates disposal-safe (`update` is now a safe no-op after dispose and returns a bool)
* added `isDisposed` getter and clear side effects in `dispose`
* updated ViewModelBuilder to keep and remove listener explicitly during dispose

## 0.0.1

* initial release.

## 0.1.0

* added MutableStateMap