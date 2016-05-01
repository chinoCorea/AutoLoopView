//
//  ATLoopView.swift
//  AutoLoopView
//
//  Created by Apple Jin on 16/1/6.
//  Copyright © 2016年 onwer. All rights reserved.
//

import UIKit

public class ATLoopView: UIView {

	@IBInspectable private var loopDuration: Double = 7.0
	
	private let collectionView = UICollectionView(frame: CGRectZero,
								   collectionViewLayout: UICollectionViewFlowLayout())
	
	private var numberOfFocus: (() -> Int)?
	private var focusAtIndex: (Int -> UIView)?
	private var touchUpFocus: (Int -> Void)?
	private var checkUpSchedule: (CGFloat -> Void)?
	
	private var timer: NSTimer!
	private var amount: Int {
		return numberOfFocus?() ?? 0
	}
	
	public init(frame: CGRect, loopDuration: NSTimeInterval) {
		self.loopDuration = loopDuration
		super.init(frame: frame)
		initialize()
	}

	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		initialize()
	}
	
	public override func layoutSubviews() {
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		
		layout.itemSize = CGSize(width: bounds.width,
								height: bounds.height)
		layout.scrollDirection = .Horizontal
		layout.minimumInteritemSpacing = 0.0
		layout.minimumLineSpacing = 0.0
		
		collectionView.frame = self.bounds
		collectionView.scrollEnabled = amount > 1
	}

	private func initialize() {
		self.layoutIfNeeded()
		
		collectionView.backgroundColor = .clearColor()
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.pagingEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "idCell")
		
		self.addSubview(collectionView)
		
		timer = NSTimer(timeInterval: loopDuration, target: self, selector: #selector(ATLoopView.scrollToNext), userInfo: nil, repeats: true)
		NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
	}
	
	public func numberOfFocus(set: () -> Int) {
		self.numberOfFocus = set
	}
	
	public func focusAtIndex(set: (index: Int) -> UIView) {
		self.focusAtIndex = set
	}
	
	public func touchUpFocus(set: (index: Int) -> Void) {
		self.touchUpFocus = set
	}
	
	public func checkUpSchedule(set: (schedule: CGFloat) -> Void) {
		self.checkUpSchedule = set
	}
	
	public func reloadData() {
		collectionView.reloadData()
	}
	
	func scrollToNext() {
		if amount > 1 {
			collectionView.scrollRectToVisible(CGRectMake(collectionView.contentOffset.x + bounds.width, 0, bounds.width, bounds.height), animated: true)
		} else {
			timer.invalidate()
		}
	}
	
	deinit {
		timer.invalidate()
	}
	
}


extension ATLoopView: UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		collectionView.contentOffset.x = bounds.width * CGFloat(amount)
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return amount * 3
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idCell", forIndexPath: indexPath)
		
		cell.backgroundColor = .clearColor()
		cell.backgroundView = focusAtIndex?(indexPath.item % amount)
		
		return cell
	}
}

extension ATLoopView: UICollectionViewDelegate {
	
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		self.touchUpFocus?(indexPath.item % amount)
	}
	
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		let offSet = scrollView.contentOffset.x
		let factWidth = bounds.width * CGFloat(amount)

		if offSet == factWidth - bounds.width {
			collectionView.contentOffset.x = bounds.width * CGFloat(amount * 2 - 1)
		} else if offSet == factWidth * 2 {
			collectionView.contentOffset.x = bounds.width * CGFloat(amount)
		}
		
		checkUpSchedule?((offSet / factWidth - CGFloat(Int(offSet / factWidth))) * CGFloat(amount))
		
	}
	
}
