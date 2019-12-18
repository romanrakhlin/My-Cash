//
//  GraphViewController.swift
//  My Cash
//
//  Created by Roman Rakhlin on 17.12.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    // UI
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var animatedCircle: ProgressChartCircleView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Local vars
    let staticIndex = 0
    let animatedIndex = 1
    var selectedIndex = 0
    let tinnyLightGrey = UIColor.lightGray.withAlphaComponent(0.7)
    
    var firstModels = [
        ProgressCircleChartModel(description: "Покупки", startPercentage: 0, endPercentage: 55, color: .green),
        ProgressCircleChartModel(description: "Еда", startPercentage: 55, endPercentage: 59, color: .red),
        ProgressCircleChartModel(description: "Счета", startPercentage: 59, endPercentage: 81, color: .black),
        ProgressCircleChartModel(description: "Машина", startPercentage: 81, endPercentage: 93, color: .red),
        ProgressCircleChartModel(description: "Другое", startPercentage: 93, endPercentage: 97, color: .orange)
    ]
    
    var secondModels = [
        ProgressCircleChartModel(description: "Подарок", startPercentage: 0, endPercentage: 55, color: .green),
        ProgressCircleChartModel(description: "Зарплата", startPercentage: 55, endPercentage: 59, color: .red),
        ProgressCircleChartModel(description: "Продажа", startPercentage: 59, endPercentage: 81, color: .black),
        ProgressCircleChartModel(description: "Бизнес", startPercentage: 81, endPercentage: 93, color: .red),
        ProgressCircleChartModel(description: "Дивиденты", startPercentage: 93, endPercentage: 97, color: .orange),
        ProgressCircleChartModel(description: "Другое", startPercentage: 91, endPercentage: 91, color: .orange)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        animatedView.backgroundColor = .white
        animatedView.isHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Animated Circle
        animatedCircle.strokeLineWidth = 20
        animatedCircle.selectedStrokeColor = .green
        animatedCircle.backgroundStrokeColor = tinnyLightGrey
        animatedCircle.setModels(models: firstModels)
        animatedCircle.labelFont = UIFont.systemFont(ofSize: 50, weight: .medium)
        animatedCircle.labelSize = CGSize(width: 138, height: 66)
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
        
        animatedCircle.animateChartElement(atIndex: 0, animated: false, duration: nil, animationType: nil, counterType: nil)
        
    }
}

extension GraphViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = firstModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyTableViewCell
        cell.configureCell(title: model.description, percentage: "\(Int(model.endPercentage - model.startPercentage))%")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        animatedCircle.animateChartElement(atIndex: indexPath.row, animated: true, duration: 0.8, animationType: .easeIn, counterType: .int)
    }
    
    
}

