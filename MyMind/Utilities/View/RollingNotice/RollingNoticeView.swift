import UIKit

@objc public protocol RollingNoticeViewDataSource : NSObjectProtocol {
    func numberOfRowsFor(roolingView: RollingNoticeView) -> Int
    func rollingNoticeView(roolingView: RollingNoticeView, cellAtIndex index: Int) -> NoticeViewCell
}

@objc public protocol RollingNoticeViewDelegate: NSObjectProtocol {
    @objc optional func rollingNoticeView(_ roolingView: RollingNoticeView, didClickAt index: Int)
}

public enum RollingNoticeViewStatus: UInt {
    case idle, working, pause
}
open class RollingNoticeView: UIView {
    weak open var dataSource : RollingNoticeViewDataSource?
    weak open var delegate : RollingNoticeViewDelegate?
    open var stayInterval = 8.0
    open private(set) var status: RollingNoticeViewStatus = .idle
    open var currentIndex: Int {
        guard let count = (self.dataSource?.numberOfRowsFor(roolingView: self)) else { return 0}
        
        if (_cIdx > count - 1) {
            _cIdx = 0
        }
        return _cIdx;
    }
    
    
    private var _cIdx = 0
    private var _needTryRoll = false
    
    
    // MARK: private properties
    private lazy var cellClsDict: Dictionary = { () -> [String : Any] in
        var tempDict = Dictionary<String, Any>()
        return tempDict
    }()
    private lazy var reuseCells: Array = { () -> [NoticeViewCell] in
        var tempArr = Array<NoticeViewCell>()
        return tempArr
    }()
    
    private var timer: Timer?
    private var currentCell: NoticeViewCell?
    private var willShowCell: NoticeViewCell?
    private var isAnimating = false
    
    // MARK: -
    open func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = cellClass
    }
    
    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = nib
    }
    
    open func dequeueReusableCell(withIdentifier identifier: String) -> NoticeViewCell? {
        for cell in self.reuseCells {
            guard let reuseIdentifier = cell.reuseIdentifier else { return nil }
            if reuseIdentifier.elementsEqual(identifier) {
                return cell
            }
        }
        
        if let cellCls = self.cellClsDict[identifier] {
            if let nib = cellCls as? UINib {
                let arr = nib.instantiate(withOwner: nil, options: nil)
                if let cell = arr.first as? NoticeViewCell {
                    cell.setValue(identifier, forKeyPath: "reuseIdentifier")
                    return cell
                }
                return nil
            }
            
            if let noticeCellCls = cellCls as? NoticeViewCell.Type {
                let cell = noticeCellCls.self.init(reuseIdentifier: identifier)
                return cell
            }
            
        }
        return nil
    }
    
    open func reloadDataAndStartRoll() {
        stopRoll()
        guard let count = self.dataSource?.numberOfRowsFor(roolingView: self), count > 0 else {
            return
        }
        
        layoutCurrentCellAndWillShowCell()
        
        
        
        guard count >= 2 else {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: stayInterval, target: self, selector: #selector(RollingNoticeView.timerHandle), userInfo: nil, repeats: true)
        if let __timer = timer {
            RunLoop.current.add(__timer, forMode: .common)
        }
        resume()
        
    }
    
    // ????????????????????????????????????????????????timer??? If you want to release, please stop the timer in the right place,for example '-viewDidDismiss'
    open func stopRoll() {
        
        if let rollTimer = timer {
            rollTimer.invalidate()
            timer = nil
        }
        
        status = .idle
        isAnimating = false
        _cIdx = 0
        currentCell?.removeFromSuperview()
        willShowCell?.removeFromSuperview()
        currentCell = nil
        willShowCell = nil
        self.reuseCells.removeAll()
    }
    
    open func pause() {
        if let __timer = timer {
            __timer.fireDate = Date.distantFuture
            status = .pause
        }
    }
    
    open func resume() {
        if let __timer = timer {
            __timer.fireDate = Date.distantPast
            status = .working
        }
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNoticeViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNoticeViews()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if (_needTryRoll) {
            self.reloadDataAndStartRoll()
            _needTryRoll = false
        }
    }
    
}

// MARK: private funcs
extension RollingNoticeView{
    
    @objc fileprivate func timerHandle() {
        if isAnimating {
            return
        }
        layoutCurrentCellAndWillShowCell()
        
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        isAnimating = true
        UIView.animate(withDuration: 1, animations: {
            self.currentCell?.frame = CGRect(x: 0, y: -h, width: w, height: h)
            self.willShowCell?.frame = CGRect(x: 0, y: 0, width: w, height: h)
        }) { (flag) in
            if let cell0 = self.currentCell, let cell1 = self.willShowCell {
                self.reuseCells.append(cell0)
                cell0.removeFromSuperview()
                self.currentCell = cell1
            }
            self.isAnimating = false
            self._cIdx += 1
        }
    }
    
    
    fileprivate func layoutCurrentCellAndWillShowCell() {
        guard let count = (self.dataSource?.numberOfRowsFor(roolingView: self)) else { return }
        
        if (_cIdx > count - 1) {
            _cIdx = 0
        }
        
        var willShowIndex = _cIdx + 1
        if (willShowIndex > count - 1) {
            willShowIndex = 0
        }
        //    print(">>>>%d", _cIdx)
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
//        print("count: \(count),  _cIdx:\(_cIdx)  willShowIndex: \(willShowIndex)")
        
        if !(w > 0 && h > 0) {
            _needTryRoll = true
            return
        }
        
        if currentCell == nil {
            // ???????????????currentcell
            // currentcell is null at first time
            if let cell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: _cIdx) {
                currentCell = cell
                cell.frame  = CGRect(x: 0, y: 0, width: w, height: h)
                self.addSubview(cell)
            }
            
            return
        }
        
        
        if let cell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: willShowIndex) {
            willShowCell = cell
            cell.frame = CGRect(x: 0, y: h, width: w, height: h)
            self.addSubview(cell)
        }
        
        
        
        guard let _cCell = currentCell, let _wCell = willShowCell else {
            return
        }
        if RollingDebugLog {
            print(String(format: "currentCell  %p", _cCell))
            print(String(format: "willShowCell %p", _wCell))
        }
        
        let currentCellIdx = self.reuseCells.firstIndex(of: _cCell)
        let willShowCellIdx = self.reuseCells.firstIndex(of: _wCell)
        
        if let index = currentCellIdx {
            self.reuseCells.remove(at: index)
        }
        
        if let index = willShowCellIdx {
            self.reuseCells.remove(at: index)
        }
        
    }
    
    @objc fileprivate func handleCellTapAction(){
        self.delegate?.rollingNoticeView?(self, didClickAt: self.currentIndex)
    }
    
    fileprivate func setupNoticeViews() {
        self.clipsToBounds = true
        self.addGestureRecognizer(self.createTapGesture())
    }
    
    fileprivate func createTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(RollingNoticeView.handleCellTapAction))
    }
    
}
