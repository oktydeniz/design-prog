//
//  ViewController.swift
//  design-prog
//
//  Created by oktay on 18.12.2024.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    let shapeLayer = CAShapeLayer()
    let traceLayer = CAShapeLayer()
    let labelPercent = UILabel()
    let pulsingLayer = CAShapeLayer()
    
    
    
    private func checkProgramm() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkProgramm()
        
        view.backgroundColor = UIColor.bgColor
        
        let circularPaht = UIBezierPath(arcCenter: CGPoint.zero, radius: 110, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        
        pulsingLayer.path = circularPaht.cgPath
        pulsingLayer.strokeColor = UIColor.clear.cgColor
        pulsingLayer.lineWidth = 10
        pulsingLayer.fillColor = UIColor.pulsingFillColor.cgColor
        pulsingLayer.lineCap = .round
        pulsingLayer.position = view.center
        view.layer.addSublayer(pulsingLayer)
        animationPulsingLayer()
        
        
        traceLayer.path = circularPaht.cgPath
        traceLayer.lineWidth = 20
        traceLayer.fillColor = UIColor.bgColor.cgColor
        traceLayer.lineCap = .round
        traceLayer.position = view.center
        traceLayer.strokeColor = UIColor.traceStrokeColor.cgColor
        view.layer.addSublayer(traceLayer)
        
        
        shapeLayer.path = circularPaht.cgPath
        shapeLayer.strokeColor = UIColor.outLineStrokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.position = view.center
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 0.1)
        
        view.layer.addSublayer(shapeLayer)
        
        
        labelPercent.text = "Start"
        labelPercent.textAlignment = .center
        labelPercent.font = UIFont.boldSystemFont(ofSize: 29)
        view.addSubview(labelPercent)
        labelPercent.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        labelPercent.center = view.center
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topBar)))
    }
    
    private func animationPulsingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 2
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pulsingLayer.add(animation, forKey: "pulingView")
    }
    
    fileprivate func animationFunc() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "animation")
    }
    
    // MARK: - Gesture
    
    @objc private func topBar() {
        downloadView()
        //animationFunc()
    }
    
    @objc private func checkEnterForeground() {
        animationPulsingLayer()
    }
    
    // MARK: -Download
    
    let fileUrl = "https://avtshare01.rz.tu-ilmenau.de/avt-vqdb-uhd-1/test_1/segments/water_netflix_7500kbps_1080p_59.94fps_hevc.mp4"
    
    private func downloadView() {
        shapeLayer.strokeEnd = 0
        pulsingLayer.fillColor = UIColor.pulsingFillColor.cgColor
        let sessionUrl = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        guard let url = URL(string: fileUrl) else {
            return
        }
        
        let task = sessionUrl.downloadTask(with: url)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percent = Int((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))*100)
        print(percent)
        DispatchQueue.main.sync {
            shapeLayer.strokeEnd = CGFloat(exactly: Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))!
            labelPercent.text = "%\(percent)"
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.sync {
            labelPercent.text = "Done!"
            pulsingLayer.fillColor = UIColor.pursingFillColorFinish.cgColor
        }
    }
}

