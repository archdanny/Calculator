//
//  GraphViewController.swift
//  Calculator
//
//  Created by Daniello on 12/12/15.
//  Copyright © 2015 DDdesigns. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!
    
    var brain = CalculatorBrain?()
    
    @IBOutlet weak var graphView: GraphView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        graphView.axes.brain = brain
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        //graphView.axes.brain = brain
        let evaluate = graphView.axes.brain?.evaluate()
        label.text = evaluate?.description
    }

    
}
