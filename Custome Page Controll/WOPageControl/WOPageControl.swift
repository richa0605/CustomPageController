//
//  SCPageControl_normal.swift
//  Pods
//
//  Created by Myoung on 2017. 4. 27..
//
//

import UIKit

@IBDesignable
class RKPageControl: UIView {

    // MARK: - Inspectable Properties
    @IBInspectable public var numberOfPages: Int = 0 {
        didSet {
            setupDotViews()
        }
    }

    @IBInspectable public var currentPage: Int {
        set {
            if newValue < 0 || newValue >= dotViewArrayM.count || dotViewArrayM.count == 0 || newValue == currentPage || inAnimating {
                return
            }
            updateCurrentPage(to: newValue)
        }
        get {
            return currentPageInner
        }
    }

    @IBInspectable public var currentDotWidth: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public var otherDotWidth: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public var dotHeight: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public var dotSpace: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public var currentDotColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public var otherDotColor: UIColor = .lightGray {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable public override var cornerRadius: CGFloat {
        didSet {
            dotViewArrayM.forEach { $0.layer.cornerRadius = cornerRadius }
            setNeedsLayout()
        }
    }

    // MARK: - Private Properties
    private var currentPageInner: Int = 0
    private var dotViewArrayM = [UIView]()
    private var isInitialize: Bool = false
    private var inAnimating: Bool = false

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup Methods
    private func setup() {
        setupDotViews()
    }

    private func setupDotViews() {
        dotViewArrayM.forEach { $0.removeFromSuperview() }
        dotViewArrayM.removeAll()
        for _ in 0..<numberOfPages {
            let dotView = UIView()
            dotView.layer.cornerRadius = cornerRadius
            dotView.backgroundColor = otherDotColor
            addSubview(dotView)
            dotViewArrayM.append(dotView)
        }
        isInitialize = true
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }

    private func setupUI() {
        if dotViewArrayM.isEmpty || !isInitialize { return }
        isInitialize = false
        let totalWidth = currentDotWidth + CGFloat(numberOfPages - 1) * (dotSpace + otherDotWidth)
        var currentX = (frame.size.width - totalWidth) / 2
        for ind in 0..<dotViewArrayM.count {
            let dotView = dotViewArrayM[ind]
            let width = (ind == currentPage ? currentDotWidth : otherDotWidth)
            let height = dotHeight
            let vwx = currentX
            let vwy = (frame.size.height - height) / 2
            dotView.frame = CGRect(x: vwx, y: vwy, width: width, height: height)
            currentX += width + dotSpace
            dotView.backgroundColor = (ind == currentPage ? currentDotColor : otherDotColor)
        }
    }

    private func updateCurrentPage(to newValue: Int) {
        if newValue > currentPage {
            animateForwardTransition(to: newValue)
        } else {
            animateBackwardTransition(to: newValue)
        }
    }

    private func animateForwardTransition(to newValue: Int) {
        let currentView = dotViewArrayM[currentPage]
        bringSubviewToFront(currentView)
        inAnimating = true
        UIView.animate(withDuration: 0.1, animations: {
            let vwx = currentView.frame.origin.x
            let vwy = currentView.frame.origin.y
            let vww = self.currentDotWidth + (self.dotSpace + self.otherDotWidth) * CGFloat(newValue - self.currentPage)
            let vwh = currentView.frame.size.height
            currentView.frame = CGRect(x: vwx, y: vwy, width: vww, height: vwh)
        })
        { _ in
            self.completeForwardAnimation(to: newValue, from: currentView)
        }
    }

    private func completeForwardAnimation(to newValue: Int, from currentView: UIView) {
        let endView = dotViewArrayM[newValue]
        endView.backgroundColor = currentView.backgroundColor
        endView.frame = currentView.frame
        bringSubviewToFront(endView)
        currentView.backgroundColor = otherDotColor
        let startX = currentView.frame.origin.x
        for ind in 0..<(newValue - currentPage) {
            let dotView = dotViewArrayM[currentPage + ind]
            let vwx = startX + (otherDotWidth + dotSpace) * CGFloat(ind)
            let vwy = dotView.frame.origin.y
            let vww = otherDotWidth
            let vwh = dotHeight
            dotView.frame = CGRect(x: vwx, y: vwy, width: vww, height: vwh)
        }
        UIView.animate(withDuration: 0.1, animations: {
            let vww = self.currentDotWidth
            let vwx = endView.frame.maxX - self.currentDotWidth
            let vwy = endView.frame.origin.y
            let vwh = endView.frame.size.height
            endView.frame = CGRect(x: vwx, y: vwy, width: vww, height: vwh)
        })
        { _ in
            self.currentPageInner = newValue
            self.inAnimating = false
        }
    }

    private func animateBackwardTransition(to newValue: Int) {
        let currentView = dotViewArrayM[currentPage]
        bringSubviewToFront(currentView)
        inAnimating = true
        UIView.animate(withDuration: 0.1, animations: {
            let vwx = currentView.frame.origin.x - (self.dotSpace + self.otherDotWidth) * CGFloat(self.currentPage - newValue)
            let vwy = currentView.frame.origin.y
            let vww = self.currentDotWidth + (self.dotSpace + self.otherDotWidth) * CGFloat(self.currentPage - newValue)
            let vwh = currentView.frame.size.height
            currentView.frame = CGRect(x: vwx, y: vwy, width: vww, height: vwh)
        })
        { _ in
            self.completeBackwardAnimation(to: newValue, from: currentView)
        }
    }

    private func completeBackwardAnimation(to newValue: Int, from currentView: UIView) {
        let endView = dotViewArrayM[newValue]
        endView.backgroundColor = currentView.backgroundColor
        endView.frame = currentView.frame
        bringSubviewToFront(endView)
        currentView.backgroundColor = otherDotColor
        let startX = currentView.frame.maxX
        for ind in 0..<(currentPage - newValue) {
            let dotView = dotViewArrayM[currentPage - ind]
            let vwx = startX - otherDotWidth - (otherDotWidth + dotSpace) * CGFloat(ind)
            let vwy = dotView.frame.origin.y
            let vww = otherDotWidth
            let vwh = dotView.frame.size.height
            dotView.frame = CGRect(x: vwx, y: vwy, width: vww, height: vwh)
        }
        UIView.animate(withDuration: 0.1, animations: {
            let vwx = endView.frame.origin.x
            let vwy = endView.frame.origin.y
            let vww = self.currentDotWidth
            let vwh = endView.frame.size.height
            endView.frame = CGRect(x: vwx, y: vwy, width: vww, height: vwh)
        })
        { _ in
            self.currentPageInner = newValue
            self.inAnimating = false
        }
    }
}
extension UIView {
    /// Corner Radius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
