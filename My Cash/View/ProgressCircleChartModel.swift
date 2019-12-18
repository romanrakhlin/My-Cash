//
//  ProgressCircleChartModel.swift
//  My Cash
//
//  Created by Roman Rakhlin on 17.12.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

struct ProgressCircleChartModel {
    var description: String
    var startPercentage: CGFloat
    var endPercentage: CGFloat
    var color: UIColor
    
    init(description: String, startPercentage: CGFloat, endPercentage: CGFloat, color: UIColor) {
        self.description = description
        self.startPercentage = startPercentage
        self.endPercentage = endPercentage
        self.color = color
    }
}
