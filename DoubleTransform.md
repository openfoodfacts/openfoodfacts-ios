# DoubleTransform

``` swift
public class DoubleTransform: TransformType 
```

## Inheritance

`TransformType`

## Nested Type Aliases

### `Object`

``` swift
public typealias Object = Double
```

### `JSON`

``` swift
public typealias JSON = String
```

## Methods

### `transformFromJSON(_:)`

``` swift
public func transformFromJSON(_ value: Any?) -> Object? 
```

### `transformToJSON(_:)`

``` swift
public func transformToJSON(_ value: Object?) -> JSON? 
```
