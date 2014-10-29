//
//  ArrayExtensions.swift
//  SwiftMandelbrot
//
//  Created by Colin Eberhardt on 28/09/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

func synchronized(sync: AnyObject, fn: ()->()) {
  objc_sync_enter(sync)
  fn()
  objc_sync_exit(sync)
}


extension Array {
  
  // concurrently applies the given transform to the elements of the array
  func concurrentMap<U>(transform: (T) -> U, callback: (SequenceOf<U>) -> ()) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    let sync = NSObject()
    var index = 0;
    
    // populate the array
    let r = transform(self[0] as T)
    var results = Array<U>(count: self.count, repeatedValue:r)
    
    for (index, item) in enumerate(self[1..<self.count-1]) {
      dispatch_group_async(group, queue) {
        let r = transform(item as T)
        synchronized(sync) {
          results[index] = r
        }
      }
    }
    
    dispatch_group_notify(group, queue) {
      callback(SequenceOf(results))
    }
  }

  // concurrently applies the given transform to the elements of the array
  func concurrentMapLockFree<U>(transform: (T) -> U, callback: SequenceOf<U> -> ()) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    
    // populate the array
    let r = transform(self[0] as T)
    var results = Array<U>(count: self.count, repeatedValue:r)

    results.withUnsafeMutableBufferPointer {
      (inout buffer: UnsafeMutableBufferPointer<U>) -> () in
      for (index, item) in enumerate(self[1..<self.count-1]) {
        dispatch_group_async(group, queue) {
          buffer[index] = transform(item)
        }
      }
      
      dispatch_group_notify(group, queue) {
        callback(SequenceOf(buffer))
      }
    }
  }
  
  // concurrently applies the given transform in chunks
  func concurrentMap<U>(chunks: Int, transform: (T) -> U, callback: SequenceOf<U> -> ()) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    
    
    // populate the array
    let r = transform(self[0] as T)
    var results = Array<U>(count: self.count, repeatedValue:r)
    
    println(self.count)
    
    results.withUnsafeMutableBufferPointer {
      (inout buffer: UnsafeMutableBufferPointer<U>) -> () in
      
      for startIndex in stride(from: 1, through: self.count, by: chunks) {
        dispatch_group_async(group, queue) {
          let endIndex = min(startIndex + chunks, self.count)
          let chunkedRange = self[startIndex..<endIndex]

          for (index, item) in enumerate(chunkedRange) {
            buffer[index + startIndex] = transform(item)
          }
        }
      }
      
      dispatch_group_notify(group, queue) {
        callback(SequenceOf(buffer))
      }
    }
  }
}