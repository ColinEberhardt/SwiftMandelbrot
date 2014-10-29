//
//  ViewController.swift
//  SwiftMandelbrot
//
//  Created by Colin Eberhardt on 22/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mandelbrotView = MandelbrotView()
    mandelbrotView.frame = self.view.frame
    self.view.addSubview(mandelbrotView)
    
    
    /*let start = NSDate()
    let data = Mandelbrot.functionalMandelbrot()
    mandelbrotView.render(data)
    let end = NSDate()
    let diff = end.timeIntervalSinceDate(start)
    println(diff)*/
    
  
    let start = NSDate()
    Mandelbrot.parallelMandelbrot({
      data in
      
      let end = NSDate()
      let diff = end.timeIntervalSinceDate(start)
      println(diff)
      
      dispatch_async(dispatch_get_main_queue(), {
        mandelbrotView.render(data)
      })
      
    })

  }
  
  


}

