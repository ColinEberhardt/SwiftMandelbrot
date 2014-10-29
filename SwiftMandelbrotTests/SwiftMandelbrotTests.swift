//
//  SwiftMandelbrotTests.swift
//  SwiftMandelbrotTests
//
//  Created by Colin Eberhardt on 22/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import XCTest

class SwiftMandelbrotTests: XCTestCase {
  func testPerformanceExample() {
    self.measureBlock() {
      let foo = Mandelbrot.iterativeMandelbrot()
    }
  }
  
  func testPerformanceExample2() {
    self.measureBlock() {
      let foo = Mandelbrot.functionalMandelbrot()
    }
  }
}
