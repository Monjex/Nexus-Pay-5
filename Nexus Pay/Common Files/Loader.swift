//
//  Loader.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation
import NVActivityIndicatorView

class Loader: UIView {
    var spinnerView : SpinnerView?
    var viewWhite = UIView()
    var lblLoaderText = UILabel()
    
    //MARK: Add loader
    func addLoader(view: UIView)  {
        DispatchQueue.main.async {
        view.isUserInteractionEnabled = false
        let screenSize:  CGRect = UIScreen.main.bounds
            self.spinnerView?.removeFromSuperview()
            self.spinnerView = SpinnerView(frame: CGRect(x: screenSize.width/2-50, y: screenSize.height/2-50, width: 100, height: 100))
            view.addSubview(self.spinnerView!)
        }
    }
    
    func addLoaderBtn(btn: UIButton)  {
        DispatchQueue.main.async {
            btn.isUserInteractionEnabled = false
           // let screenSize:  CGRect = UIScreen.main.bounds
            self.spinnerView?.removeFromSuperview()
            self.spinnerView = SpinnerView(frame: CGRect(x: btn.frame.width-40, y: btn.frame.height/2-10, width: 24, height: 24))
            btn.addSubview(self.spinnerView!)
        }
    }
    
    //MARK: Add loader
    func addLoaderWithText(view: UIView,strText : String)  {
        DispatchQueue.main.async {
            //view.isUserInteractionEnabled = false
            let screenSize:  CGRect = UIScreen.main.bounds
            self.viewWhite.removeFromSuperview()
            self.viewWhite = UIView()
            self.viewWhite.frame = CGRect(x: screenSize.width/2-75, y: screenSize.height/2-75, width: 150, height: 130)
            self.viewWhite.backgroundColor = UIColor.black
            self.viewWhite.layer.cornerRadius = 8
            self.viewWhite.clipsToBounds = true
            self.viewWhite.alpha = 0.9
            view.addSubview(self.viewWhite)
            self.lblLoaderText.removeFromSuperview()
            self.lblLoaderText = UILabel()
            self.lblLoaderText.frame = CGRect(x:10 , y: self.viewWhite.frame.height - 50, width: 120, height:40)
            self.lblLoaderText.text = strText
            self.lblLoaderText.textColor = UIColor.gray
            self.lblLoaderText.font = UIFont.systemFont(ofSize: 13)
            self.lblLoaderText.textAlignment = .center
            self.lblLoaderText.numberOfLines = 2
            self.viewWhite.addSubview(self.lblLoaderText)
            var activityIndicator = UIActivityIndicatorView()
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.style = UIActivityIndicatorView.Style.large
            activityIndicator.color = UIColor.gray
            activityIndicator.frame = CGRect(x: self.viewWhite.frame.width/2-20, y: self.viewWhite.frame.height/2-40, width: 40, height: 40)
            activityIndicator.startAnimating()
            self.viewWhite.addSubview(activityIndicator)
        }
    }
    func removeLoaderWithText(view: UIView)  {
        DispatchQueue.main.async {
            self.viewWhite.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    func removeLoader(view: UIView)  {
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    func removeLoaderBtn(btn: UIButton)  {
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
            btn.isUserInteractionEnabled = true
        }
    }
}

extension UIResponder {
    func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).getParentViewController()
            }
            else {return nil}
        }
    }
}


//MARK: Setup loading View
@IBDesignable
class SpinnerView : UIView {
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 3
        setPath()
    }
    
    override func didMoveToWindow() {
        animate()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }
    
    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        
        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).cgColor
        }
        animation.duration = duration
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    
}
