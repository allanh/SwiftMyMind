//
//  UDNSKMarqueeView.swift
//  UDNSKit
//
//  Created by Nelson Chan on 2018/12/28.
//  Copyright © 2018 Nelson Chan. All rights reserved.
//

import UIKit

public typealias UDNSKInteractiveMarqueeAnimateCompletion = (Bool, Int) -> Void

/**  The datasource of UDNKInteractiveMarqueeView should adopt UDNKInteractiveMarqueeViewDataSource protocol */
protocol UDNSKInteractiveMarqueeViewDataSource {
    

    /** Return the view at given index path.
     @param marqueeView A marquee view request the content view.
     @param indexPath A index path locate a content view in marquee view.
     @return A marquee content view
     */
    @available(iOS 2.0, *)
    func interactiveMarqueeView(_ marqueeView: UDNSKInteractiveMarqueeView, contentViewAt indexPath: IndexPath) -> UIView

    /** Return the number of marquees object.
     @param marqueeView A marquee view request the number of marquees.
     @return The number of marquees.
     */
    func numberOfMarquees(in marqueeView: UDNSKInteractiveMarqueeView) -> Int


    func direction(of marqueeView: UDNSKInteractiveMarqueeView) -> UDNSKInteractiveMarqueeView.ScrollDirection
}

protocol UDNSKInteractiveMarqueeViewDelegate {
    
    
    /**  Methods for notification of selection event.
     @param marqueeView The marquee view object.
     @param indexPath The index path of selected marquee.
     */
    func interactiveMarqueeView(_ marqueeView: UDNSKInteractiveMarqueeView, didSelectItemAt indexPath: IndexPath)
}
extension UDNSKInteractiveMarqueeViewDelegate {
    func interactiveMarqueeView(_ marqueeView: UDNSKInteractiveMarqueeView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
private var key: Void?

open class UDNSKInteractiveMarqueeView : UIScrollView & UIScrollViewDelegate {
    
    public enum ScrollDirection {
        case left
        case right
        case up
        case down
    }
    
    var dataSource: UDNSKInteractiveMarqueeViewDataSource?
    var marqueeDelegate: UDNSKInteractiveMarqueeViewDelegate?
    
    private var delay: TimeInterval = 0
    private var duration: TimeInterval = 0;
    private var cachedContentViews: [Any?] = []
    private var completion: UDNSKInteractiveMarqueeAnimateCompletion?
    private var timer: Timer?
    private var numberOfMarquees: Int = Int.min
    private var previousView: UIView?
    private var nextView: UIView?
    private var currentView: UIView?
    private var didChanged: Bool = false
    private var offset: CGPoint = CGPoint.zero
    private var currentIndex: Int = 0
    
    private func contentView(at indexPath:IndexPath) -> UIView {
        if cachedContentViews[indexPath.row] == nil {
            if let view = dataSource?.interactiveMarqueeView(self, contentViewAt: indexPath) {
                objc_setAssociatedObject(view, &key, indexPath, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                cachedContentViews[indexPath.row] = view
            }
        }
        return cachedContentViews[indexPath.row] as! UIView
    }
    private func setupContentViews() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        if let dataSource = dataSource {
            if dataSource.direction(of: self) == .left || dataSource.direction(of: self) == .right {
                switch (numberOfMarquees) {
                case 0:
                    break
                case 1:
                    let currentView = contentView(at: IndexPath(item: currentIndex, section: 0))
                    currentView.frame = CGRect(x: 0, y: 0, width: currentView.frame.width, height: currentView.frame.height)
                    addSubview(currentView)
                    contentSize = CGSize(width: currentView.frame.width, height: currentView.frame.height)
                    contentOffset = CGPoint.zero
                case 2:
                    var previousIndex = currentIndex + numberOfMarquees
                    previousIndex -= 1
                    previousIndex %= numberOfMarquees
                    let previousView = contentView(at: IndexPath(item: previousIndex, section: 0))
                    previousView.frame = CGRect(x: 0, y: 0, width: previousView.frame.width, height: previousView.frame.height)
                    addSubview(previousView)
                    let currentView = contentView(at: IndexPath(item: currentIndex, section: 0))
                    currentView.frame = CGRect(x: previousView.frame.width, y: 0, width: currentView.frame.width, height: currentView.frame.height)
                    addSubview(currentView)
                    let nextView = previousView.copyView()
                    nextView.frame = CGRect(x: previousView.frame.width+currentView.frame.width, y: 0, width: nextView.frame.width, height: nextView.frame.height)
                    addSubview(nextView)
                    contentSize = CGSize(width: 3*currentView.frame.width, height: currentView.frame.height)
                    contentOffset = CGPoint(x: previousView.frame.width, y: 0)
                default:
                    var previousIndex = currentIndex + numberOfMarquees
                    previousIndex -= 1
                    previousIndex %= numberOfMarquees
                    let previousView = contentView(at: IndexPath(item: previousIndex, section: 0))
                    previousView.frame = CGRect(x: 0, y: 0, width: previousView.frame.width, height: previousView.frame.height)
                    addSubview(previousView)
                    let currentView = contentView(at: IndexPath(item: currentIndex, section: 0))
                    currentView.frame = CGRect(x: previousView.frame.width, y: 0, width: currentView.frame.width, height: currentView.frame.height)
                    addSubview(currentView)
                    var nextIndex = currentIndex + 1
                    nextIndex %= numberOfMarquees
                    let nextView = contentView(at: IndexPath(item: nextIndex, section: 0))
                    nextView.frame = CGRect(x: previousView.frame.width+currentView.frame.width, y: 0, width: nextView.frame.width, height: nextView.frame.height)
                    addSubview(nextView)
                    contentSize = CGSize(width: 3*currentView.frame.width, height: currentView.frame.height)
                    contentOffset = CGPoint(x: previousView.frame.width, y: 0)
                }
            }
        } else {
            switch (numberOfMarquees) {
            case 0:
                break
            case 1:
                let currentView = contentView(at: IndexPath(item: currentIndex, section: 0))
                currentView.frame = CGRect(x: 0, y: 0, width: currentView.frame.width, height: currentView.frame.height)
                addSubview(currentView)
                contentSize = CGSize(width: currentView.frame.width, height: currentView.frame.height)
                contentOffset = CGPoint.zero
            case 2:
                var previousIndex = currentIndex + numberOfMarquees
                previousIndex -= 1
                previousIndex %= numberOfMarquees
                let previousView = contentView(at: IndexPath(item: previousIndex, section: 0))
                previousView.frame = CGRect(x: 0, y: 0, width: previousView.frame.width, height: previousView.frame.height)
                addSubview(previousView)
                let currentView = contentView(at: IndexPath(item: currentIndex, section: 0))
                currentView.frame = CGRect(x: 0, y: previousView.frame.height, width: currentView.frame.width, height: currentView.frame.height)
                addSubview(currentView)
                let nextView = previousView.copyView()
                nextView.frame = CGRect(x: 0, y: previousView.frame.height+currentView.frame.height, width: nextView.frame.width, height: nextView.frame.height)
                addSubview(nextView)
                contentSize = CGSize(width: currentView.frame.width, height: 3*currentView.frame.height)
                contentOffset = CGPoint(x: 0, y: previousView.frame.height)
            default:
                var previousIndex = currentIndex + numberOfMarquees
                previousIndex -= 1
                previousIndex %= numberOfMarquees
                let previousView = contentView(at: IndexPath(item: previousIndex, section: 0))
                previousView.frame = CGRect(x: 0, y: 0, width: previousView.frame.width, height: previousView.frame.height)
                addSubview(previousView)
                let currentView = contentView(at: IndexPath(item: currentIndex, section: 0))
                currentView.frame = CGRect(x: 0, y: previousView.frame.height, width: currentView.frame.width, height: currentView.frame.height)
                addSubview(currentView)
                var nextIndex = currentIndex + 1
                nextIndex %= numberOfMarquees
                let nextView = contentView(at: IndexPath(item: nextIndex, section: 0))
                nextView.frame = CGRect(x: 0, y: previousView.frame.height+currentView.frame.height, width: nextView.frame.width, height: nextView.frame.height)
                addSubview(nextView)
                contentSize = CGSize(width: currentView.frame.width, height: 3*currentView.frame.height)
                contentOffset = CGPoint(x: 0, y: previousView.frame.height)
            }

        }
    }
    @objc func pan(recognizer: UIPanGestureRecognizer) -> Void {
        if recognizer.state == .began {
            offset = contentOffset
            pauseAnimateMarquee()
        } else if recognizer.state == .ended {
            let translate = recognizer.translation(in: self)
            if let dataSource = dataSource {
                switch dataSource.direction(of: self) {
                    case .left, .right:
                        if translate.x > frame.width/2 {
                            currentIndex += numberOfMarquees
                            currentIndex -= 1
                            currentIndex %= numberOfMarquees
                            didChanged = true
                        } else if abs(translate.x) > frame.width/2 {
                            currentIndex += 1
                            currentIndex %= numberOfMarquees
                            didChanged = true
                        }
                    case .up, .down:
                        if translate.y > frame.height/2 {
                            currentIndex += numberOfMarquees
                            currentIndex -= 1
                            currentIndex %= numberOfMarquees
                            didChanged = true
                        } else if abs(translate.y) > frame.height/2 {
                            currentIndex += 1
                            currentIndex %= numberOfMarquees
                            didChanged = true
                        }
                }
            }
            setupContentViews()
            completion?(true, currentIndex)
            if !didChanged {
                continueAnimateMarquee()
            } else {
                isScrollEnabled = true
                delegate = self
                removeGestureRecognizer(recognizer)
            }
        } else if (recognizer.state == .cancelled || recognizer.state == .failed) {
            continueAnimateMarquee()
        } else if recognizer.state == .changed {
            let translate = recognizer.translation(in: self)
            contentOffset = CGPoint(x: offset.x-translate.x, y: offset.y)
        }
    }
    @objc func tap(recognizer: UIPanGestureRecognizer) -> Void {
        if let delegate = marqueeDelegate {
            var indexPath: IndexPath?
            for subview in subviews {
                if subview.layer.frame.contains(recognizer.location(in: self)) {
                    indexPath = objc_getAssociatedObject(subview, &key) as? IndexPath
                    break
                }
            }
            if let index = indexPath {
                delegate.interactiveMarqueeView(self, didSelectItemAt: index)
            }
        }
    }
    @objc func changeMarquee(timer: Timer) -> Void {
        if numberOfMarquees == Int.min, let dataSource = dataSource {
            numberOfMarquees = dataSource.numberOfMarquees(in: self)
        }
        if numberOfMarquees > 1 {
            if let dataSource = dataSource {
                switch dataSource.direction(of: self) {
                case .left:
                    scrollRectToVisible(CGRect(x: frame.width*2, y: 0, width: frame.width, height: frame.height), animated: true)
                    currentIndex += 1
                    currentIndex %= numberOfMarquees
                case .down:
                    scrollRectToVisible(CGRect(x: 0, y: 2*frame.height, width: frame.width, height: frame.height), animated: true)
                    currentIndex += 1
                    currentIndex %= numberOfMarquees
                case .right, .up:
                    scrollRectToVisible(CGRect(x: 0, y: 0, width: frame.width, height: frame.height), animated: true)
                    currentIndex += numberOfMarquees
                    currentIndex -= 1
                    currentIndex %= numberOfMarquees
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    self.setupContentViews()
                    self.completion?(true, self.currentIndex)
                }
            }
        }
    }
    func initialize() -> Void {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(recognizer:)))
        addGestureRecognizer(tapRecognizer)
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 2*scrollView.bounds.width {
            currentIndex += 1
        } else if scrollView.contentOffset.x == 0 {
            currentIndex -= 1
            currentIndex %= numberOfMarquees
        }
        currentIndex %= numberOfMarquees
        completion?(true, currentIndex)
        setupContentViews()
    }
    //@property (assign, nonatomic) HIKInteractiveMarqueeScrollDirection direction;
    /** Stop animate marquee.
     */
    open func stopAnimateMarquee() -> Void {
        pauseAnimateMarquee()
        dataSource = nil

    }
    
    /** Start the marquee for giving duration, delay and animator.
     @param duration The duration of animation in seconds.
     @param delay The delay between two marquees in seconds.
     @param handler The animation completion handler.
     */
    open func startAnimateMarqueeDuration(_ duration: TimeInterval, delay: TimeInterval, completion handler: UDNSKInteractiveMarqueeAnimateCompletion?) {
        if numberOfMarquees == Int.min, let dataSource = dataSource {
            numberOfMarquees = dataSource.numberOfMarquees(in: self)
        }
        cachedContentViews = []
        for _ in 0...numberOfMarquees {
            cachedContentViews.append(nil)
        }
        completion = handler
        if numberOfMarquees > 0 {
            self.delay = delay
            self.duration = duration
            currentIndex = 0
            isPagingEnabled = true
            setupContentViews()
            timer?.invalidate()
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(changeMarquee(timer:)), userInfo: nil, repeats: true)
        }

    }
    
    /** Pause animate marquee.
     */
    open func pauseAnimateMarquee() -> Void {
        timer?.invalidate()
        timer = nil

    }
    
    /** Continue animate marquee.
     */
    open func continueAnimateMarquee() -> Void {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(changeMarquee(timer:)), userInfo: nil, repeats: true)
        }
    }
}
