//
//  Mandelbrot.swift
//  SwiftMandelbrot
//
//  Created by Colin Eberhardt on 23/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

typealias MandelbrotPoint = (ComplexNumber, Int?)

struct Scale {
  let start: Double
  let end: Double
  let step: Double
  
  func toStride() -> StrideThrough<Double>  {
    return stride(from: start, through: end, by: step)
  }
  
  func steps() -> Int {
    return Int(floor((end - start) / step))
  }
}

let CONSTANTS = (
  xscale: Scale(start: -0.67, end: -0.45, step: 0.0008),
  yscale: Scale(start: -0.67, end: -0.34, step: 0.0006),
  iterations: 100000,
  escape: 2.0
)




class Mandelbrot {
  
  // compute the Mandelbrot using a traditional for-each approach
  class func iterativeMandelbrot() -> [MandelbrotPoint] {
    var results = [MandelbrotPoint]()
    for dx in CONSTANTS.xscale.toStride() {
      for dy in CONSTANTS.yscale.toStride() {
        let c = ComplexNumber(real: dy, imaginary: dx)
        results.append((c, iterationsForLocation(c)))
      }
    }
    return results
  }
  
  // generate all the complex numbers used to generate the Mandelbrot set
  class func generateDatapoints() -> [ComplexNumber] {
    var datapoints = [ComplexNumber](count: CONSTANTS.xscale.steps() * CONSTANTS.yscale.steps(),
      repeatedValue: ComplexNumber())
    var index = 0
    for dx in CONSTANTS.xscale.toStride() {
      for dy in CONSTANTS.yscale.toStride() {
        datapoints[index] = ComplexNumber(real: dy, imaginary: dx)
        index++
      }
    }
    return datapoints
  }
  
  // generated a Mandelbrot using functional techniques
  class func functionalMandelbrot() -> [MandelbrotPoint] {
    return generateDatapoints()
             .map { ($0, self.iterationsForLocation($0)) }
  }
  
  class func parallelMandelbrot(handler: SequenceOf<MandelbrotPoint> -> ()) {
    return generateDatapoints().concurrentMap(1_000, {
      ($0, self.iterationsForLocation($0))
    }, handler)
  }
  
  // iterates the 'iterate' function while the 'whilst' condition is true or
  // the maximum iteration count is exceeded
  class func iterate<T>(# seed: T,  iterations: Int,  iterate: (T) -> T, whilst: (T) -> Bool) -> Int? {
    var iteration = 0
    var z = seed
    do {
      z = iterate(z)
      iteration++
    } while (!whilst(z) && iteration < iterations)
    
    return iteration < iterations ? iteration : nil
  }
  
  // computes the Mandelbrot iterations for the given location
  class func iterationsForLocation(c: ComplexNumber) -> Int? {
    var iteration = 0
    var z = ComplexNumber()
    do {
      z = z * z + c
      iteration++
    } while (z.normal() < CONSTANTS.escape && iteration < CONSTANTS.iterations)
    
    return iteration < CONSTANTS.iterations ? iteration : nil
  }
}