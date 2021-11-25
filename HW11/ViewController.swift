//
//  ViewController.swift
//  HW11
//
//  Created by Ольга on 24.11.2021.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    // MARK: - Lable
    
    private lazy var timerLable: UILabel = {
        let lable = UILabel()
        lable.text = "25:00"
        lable.font = .systemFont(ofSize: 70, weight: .light)
        lable.textAlignment = .center
        lable.frame = CGRect(x: 110, y: 355, width: 195, height: 90)
        lable.textColor = .systemRed
        return lable
    }()
    
    // MARK: - Images for Start Button
    
    private lazy var playImage: UIImage = {
        var image = UIImage()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .light, scale: .medium)
        image = UIImage(systemName: "play", withConfiguration: imageConfig)!
        return image
    }()
    
    private lazy var pauseImage: UIImage = {
        var image = UIImage()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .light, scale: .medium)
        image = UIImage(systemName: "pause", withConfiguration: imageConfig)!
        return image
    }()
    
    // MARK: - Buttons
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(playImage, for: .normal)
        button.frame = CGRect(x: 180, y: 520, width: 60, height: 60)
        button.addTarget(self, action: (#selector(startButtonTapped(_:))), for: .touchUpInside)
        button.tintColor = .systemRed
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 180, y: 720, width: 80, height: 70)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        button.addTarget(self, action: (#selector(resetButtonTapped(_:))), for: .touchUpInside)
        return button
    }()
    
    private lazy var workButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 90, y: 150, width: 70, height: 70)
        button.setTitle("Work", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        button.addTarget(self, action: (#selector(workButtonTapped(_:))), for: .touchUpInside)
        return button
    }()
    
    private lazy var restButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 270, y: 150, width: 70, height: 70)
        button.setTitle("Rest", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        button.addTarget(self, action: (#selector(restButtonTapped(_:))), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Progress bar
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    var isAnimationStarted = false
    
    // MARK: - Timer
    
    var isWorkTime = true
    var timer = Timer()
    var isTimerStarted = false
    var time = 25
    
    // MARK: - Functions

    @IBAction func workButtonTapped(_ sender: Any) {
        isWorkTime = true
        stopAnimation()
        timer.invalidate()
        isTimerStarted = false
        startButton.setImage(playImage, for: .normal)
        
        workButton.isEnabled = false
        workButton.alpha = 0.5
        restButton.isEnabled = true
        restButton.alpha = 1
        
        timerLable.text = "25:00"
        timerLable.textColor = .systemRed
        startButton.tintColor = .systemRed
        
        time = 25
    }
    
    @IBAction func restButtonTapped(_ sender: Any) {
        isWorkTime = false
        stopAnimation()
        timer.invalidate()
        isTimerStarted = false
        startButton.setImage(playImage, for: .normal)
        
        restButton.isEnabled = false
        restButton.alpha = 0.5
        workButton.isEnabled = true
        workButton.alpha = 1
        
        timerLable.text = "05:00"
        timerLable.textColor = .systemGreen
        startButton.tintColor = .systemGreen
        
        time = 5
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        resetButton.isEnabled = true
        resetButton.alpha = 1.0
        
        if !isTimerStarted {
            createProgressLayer()
            startResumeAnimation()
            
            startTimer()
            isTimerStarted = true
            startButton.setImage(pauseImage, for: .normal)
            
        } else {
            pauseAnimation()
            
            timer.invalidate()
            isTimerStarted = false
            startButton.setImage(playImage, for: .normal)
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        stopAnimation()
        
        resetButton.isEnabled = false
        resetButton.alpha = 0.5
        startButton.setImage(playImage, for: .normal)
        
        timer.invalidate()
        isTimerStarted = false
        
        if isWorkTime == false {
            timerLable.text = "05:00"
            timerLable.textColor = .systemGreen
            time = 5
        } else {
            timerLable.text = "25:00"
            timerLable.textColor = .systemRed
            time = 25
        }
    }
        
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if time < 1 {
            resetButton.isEnabled = false
            resetButton.alpha = 0.5
            startButton.setImage(playImage, for: .normal)
            timer.invalidate()
            isTimerStarted = false

            if isWorkTime == false {
                timerLable.text = "05:00"
                time = 5
            } else {
                timerLable.text = "25:00"
                time = 25
            }
            
        } else {
            time -= 1
            timerLable.text = formatTime()
        }
    }
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func createCircleLayer() {
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 200, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.gray.cgColor
      
        view.layer.addSublayer(circleLayer)
    }
    
    func createProgressLayer() {
        progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 200, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        
        if isWorkTime == false {
            progressLayer.strokeColor = UIColor.systemGreen.cgColor
        } else {
            progressLayer.strokeColor = UIColor.systemRed.cgColor
        }
        
        view.layer.addSublayer(progressLayer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    func startAnimation() {
        resetAnimation()
        progressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        
        if isWorkTime == false {
            animation.duration = 5
        } else {
            animation.duration = 25
        }
        
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        progressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    func resetAnimation() {
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeSincePaused = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(timerLable)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        view.addSubview(workButton)
        view.addSubview(restButton)
        
        createCircleLayer()
    }
}
