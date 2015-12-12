//
//  GraphView.swift
//  Calculator
//
//  Created by Daniello on 12/12/15.
//  Copyright © 2015 DDdesigns. All rights reserved.
//

import UIKit

class GraphView: UIView
{
       var axes = AxesDrawer()
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        axes.contentScaleFactor = self.contentScaleFactor;
        axes.drawAxesInRect(self.bounds, origin: self.center, pointsPerUnit: 50)
    }
}
