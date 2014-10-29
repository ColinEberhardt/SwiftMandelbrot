//
//  MandelbrotView.swift
//  SwiftMandelbrot
//
//  Created by Colin Eberhardt on 25/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit

class MandelbrotView: UIView {
  
  var data: [MandelbrotPoint]
  
  override init() {
    data = [MandelbrotPoint]()
    super.init()
  }
  
  override init(frame: CGRect) {
    data = [MandelbrotPoint]()
    super.init(frame: frame)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func render(data: SequenceOf<MandelbrotPoint>) {
    self.data = [MandelbrotPoint](data)
    setNeedsDisplay()
  }
  
  func render(data: [MandelbrotPoint]) {
    self.data = data
    setNeedsDisplay()
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    func colorForIteration(iterations: Int?) -> UIColor {
      func colorComponent(iteration: Int) -> CGFloat {
        return CGFloat( (sin(Double(iteration) / 20.0) + 1.0) / 2.0)
      }
      if let iterationCount = iterations {
        return UIColor(red: colorComponent(iterationCount),
                      green: colorComponent(iterationCount + 10),
                      blue: colorComponent(iterationCount + 25),
                      alpha: 1.0)
      } else {
        return UIColor.blackColor()
      }
    }
    
    func mapping(max: Double, min: Double, size: CGFloat)(point: Double) -> CGFloat {
      return CGFloat(((point - min) * Double(size)) / (max - min))
    }
    
    let xscale = mapping(CONSTANTS.xscale.start, CONSTANTS.xscale.end, self.bounds.size.width)
    let yscale = mapping(CONSTANTS.yscale.start, CONSTANTS.yscale.end, self.bounds.size.height)
    
    let width = abs(xscale(point: CONSTANTS.xscale.start + CONSTANTS.xscale.step) - xscale(point: CONSTANTS.xscale.start)) + 1.0
    let height = abs(yscale(point: CONSTANTS.yscale.start + CONSTANTS.yscale.step) - yscale(point: CONSTANTS.yscale.start)) + 1.0
    
    for item in data {
      let (location, iterations) = item
      let rect = CGRectMake(xscale(point: location.imaginary), yscale(point: location.real), width, height);
      
      colorForIteration(iterations).setFill()
      
      CGContextFillRect(context, rect)
    }
  }
}