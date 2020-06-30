//
//  main.swift
//  testingStringManipulation
//
//  Created by Ahava on 6/5/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import Foundation

var string = " Hello, World!"

let splitString = string.split(separator: " ")
print(splitString)
let joinedString = splitString.joined(separator: " ")
print(joinedString)
