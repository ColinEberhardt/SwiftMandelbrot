# Mandelbrot Generation With Concurrent Functional Swift

This is a sample project which shows how the simple task of computing a Mandelbrot set can be split up across multiple threads (and processors) as follows:

```
generateDatapoints().concurrentMap({
  // a closure that is executed concurrently for each datapoint
  (location: ComplexNumber) in 
  self.computeTterationsForLocation(location)
}, {
  // when the above computation completes, send the data to the UI
  mandelbrotView.render($0)
})
```