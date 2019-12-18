//
//  ProgressChartCircleView.swift
//  My Cash
//
//  Created by Roman Rakhlin on 17.12.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

class ProgressChartCircleView: UIView {
    
    public enum LabelTypeAnimation {
        case linear
        case easeIn
        case easeOut
    }
    
    public enum LabelCounterType {
        case int
        case float
    }
    
    fileprivate lazy var _models: [ProgressCircleChartModel] = [ProgressCircleChartModel]()
    fileprivate lazy var _selectedStrokeColor: UIColor = .green
    fileprivate lazy var _backgroundStrokeColor: UIColor = .lightGray
    fileprivate lazy var _radius: CGFloat = self.frame.size.width / 2
    fileprivate var _clockwise: Bool = true
    fileprivate var _label: CountingLabel!
    fileprivate lazy var _strokeLineWidth: CGFloat = 20
    fileprivate lazy var _labelSize: CGSize = CGSize(width: 200, height: 200)
    fileprivate lazy var _labelFont: UIFont = UIFont.systemFont(ofSize: 80, weight: .medium)
    fileprivate var contourLayer: CAShapeLayer?
    
    
    // Open Var
    open var selectedStrokeColor: UIColor {
        set { _selectedStrokeColor = newValue }
        get { return _selectedStrokeColor }
    }
    
    open var backgroundStrokeColor: UIColor {
        set { _backgroundStrokeColor = newValue }
        get { return _backgroundStrokeColor }
    }
    
    open var radius: CGFloat {
        set { _radius = newValue }
        get { return _radius }
    }
    
    open var strokeLineWidth: CGFloat {
        set { _strokeLineWidth = newValue }
        get { return _strokeLineWidth }
    }
    
    open var labelSize: CGSize {
        set { _labelSize = newValue }
        get { return _labelSize }
    }
    
    open var labelFont: UIFont {
        set { _labelFont = newValue}
        get { return _labelFont }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Private functions
extension ProgressChartCircleView {}

// MARK: - Public methods
extension ProgressChartCircleView {
    public func setModels(models: [ProgressCircleChartModel]) {
        self._models = models
    }
    
    func animateChartElement(atIndex index: Int, animated: Bool, duration: TimeInterval?, animationType: LabelTypeAnimation?, counterType: LabelCounterType?) {
        
        self.layer.sublayers?.forEach{$0.removeFromSuperlayer()}
        self.setNeedsDisplay()
        self._label = CountingLabel(frame: CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height))
        self.addSubview(_label)
        self._label.font = labelFont
        self._label.textColor = _selectedStrokeColor
        self._label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self._label.textAlignment = .center
        self.layoutIfNeeded()
        
        for i in 0 ..< _models.count {
            
            let centerView = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            layoutIfNeeded()
            
            let startAnglePercentage = _models[i].startPercentage + 1
            let endAnglePercentage = _models[i].endPercentage - 1
            let startAngleRadians = startAnglePercentage * 2 * CGFloat.pi / 100 - (CGFloat.pi / 2)
            let endAngleRadians = endAnglePercentage * 2 * CGFloat.pi / 100 - (CGFloat.pi / 2)
            
            // Circular Path
            let circularPath = UIBezierPath(arcCenter: centerView, radius: radius, startAngle: startAngleRadians, endAngle: endAngleRadians, clockwise: true)
            
            // Contour Layer
            self.contourLayer = CAShapeLayer()
            guard let contourLayer = self.contourLayer else { return }
            contourLayer.path = circularPath.cgPath
            contourLayer.strokeColor = i == index ? selectedStrokeColor.cgColor : _backgroundStrokeColor.cgColor
            contourLayer.strokeEnd = i == index && animated ? 0 : 1
            contourLayer.lineWidth = self._strokeLineWidth
            contourLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(contourLayer)
            
            // Animation
            if animated && i == index {
                
                guard let animationType = animationType, let counterType = counterType, let duration = duration else { return }
                
                let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
                strokeAnimation.toValue = 1
                strokeAnimation.duration = duration
                strokeAnimation.fillMode = CAMediaTimingFillMode.forwards
                strokeAnimation.isRemovedOnCompletion = false
                //contourLayer.lineCap = kCALineCapRound
                contourLayer.add(strokeAnimation, forKey: "strokeAnimation")
                
                var animationTypeLabel: CountingLabel.CounterAnimationType!
                switch animationType {
                case .easeIn:
                    animationTypeLabel = .easeIn
                    break
                    
                case .easeOut:
                    animationTypeLabel = .easeOut
                    break
                    
                case .linear:
                    animationTypeLabel = .linear
                    break
                }
                
                var counterLabel: CountingLabel.CounterType
                switch counterType {
                case .float:
                    counterLabel = .float
                    break
                    
                case .int:
                    counterLabel = .int
                    break
                }
                
                _label.count(fromValue: Float(0), to: Float(_models[i].endPercentage - _models[i].startPercentage), withDuration: duration, animationType: animationTypeLabel, counterType: counterLabel)
                
            } else {
                if i == index {
                    _label.text = "\(Int(_models[i].endPercentage - _models[i].startPercentage))%"
                }
                
            }
        }
    }
    
    func animateChartElement(atIndex index: Int) {
        // TODO:
    }
}

