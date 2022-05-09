//
//  ReaderWriter.swift
//  Task10Concurrency&multithreading
//
//  Created by Tymofii (Work) on 19.10.2021.
//

import UIKit

final class ReaderWriter<T> {
    private var data: [T] = []
    private let concurrentQueue = DispatchQueue(label: "com.epam.Task10Concurrency-multithreading.queue", attributes: .concurrent)
    
    var elements: [T] {
        var result: [T] = []
        concurrentQueue.sync {
            result = data
        }
        return result
    }
    
    func insert(_ value: T) {
        concurrentQueue.async(flags: .barrier) {
            self.data.append(value)
        }
    }
}
