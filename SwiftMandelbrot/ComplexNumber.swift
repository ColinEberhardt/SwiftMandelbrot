//
//  ComplexNumber.swift
//  SwiftMandelbrot
//
//  Created by Colin Eberhardt on 22/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

struct ComplexNumber
{
  let real = 0.0
  let imaginary = 0.0
  
  func normal() -> Double {
    return real * real + imaginary * imaginary
  }
}

func + (x: ComplexNumber, y: ComplexNumber) -> ComplexNumber {
  return ComplexNumber(real: x.real + y.real, imaginary: x.imaginary + y.imaginary)
}

func * (x: ComplexNumber, y: ComplexNumber) -> ComplexNumber {
  return ComplexNumber(real: x.real * y.real - x.imaginary * y.imaginary,
                      imaginary: x.real * y.imaginary + x.imaginary * y.real)
}
