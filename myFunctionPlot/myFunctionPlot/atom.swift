//
//  atom.swift
//  myFunctionPlot
//
//  Created by Niklas Nordin on 2015-07-14.
//  Copyright (c) 2015 Niklas Nordin. All rights reserved.
//

import UIKit

class atom: NSObject
{
    var coefficient: Double = 0.0
    var exponent: Double = 0.0
    
    func evaluate(x:Double) -> Double
    {
        return coefficient*pow(x, exponent)
    }
}
