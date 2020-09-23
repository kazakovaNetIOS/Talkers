//
//  Logger.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class Logger {
    
    public static var isLoggingOn: Bool = false
    
    public static func printInLog(_ text: String) {
        if !isLoggingOn {
            return
        }
        
        #if DEBUG
        print(text)
        #endif
    }
}

