//
//  ATLoopView.swift
//  AutoLoopView
//
//  Created by Apple Jin on 16/1/6.
//  Copyright © 2016年 onwer. All rights reserved.
//

import UIKit

public class ATLoopView: UIView {

	@IBInspectable var autoLoopDuration: Double = 7.0
	
	private let collectionView = UICollectionView(frame: CGRectZero,
								   collectionViewLayout: UICollectionViewFlowLayout())
	
	private var numberOfFocus: (() -> Int)?
	private var focusAtIndex: (Int -> UIView)?
	private var touchUpFocus: (Int -> Void)?
	private var checkUpSchedule: (Int -> Void)?
	
	
	override public init(frame: CGRect) {
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
		
		NSTimer.scheduledTimerWithTimeInterval(autoLoopDuration, target: self, selector: "scrollToNext", userInfo: nil, repeats: true)
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
	
	public func checkUpSchedule(set: (schedule: Int) -> Void) {
		self.checkUpSchedule = set
	}
	
	func scrollToNext() {
		collectionView.scrollRectToVisible(CGRectMake(collectionView.contentOffset.x + bounds.width, 0, bounds.width, bounds.height), animated: true)
	}
	
}


extension ATLoopView: UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		collectionView.contentOffset.x = bounds.width
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (numberOfFocus?() ?? 0) + 2
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idCell", forIndexPath: indexPath)
		let count = (numberOfFocus?() ?? 0) + 2
		
		cell.backgroundColor = .clearColor()
		cell.backgroundView = {
			switch indexPath.row {
			case 0:
				return self.focusAtIndex?(count - 3)
			case count - 1:
				return self.focusAtIndex?(0)
			default:
				return self.focusAtIndex?(indexPath.row - 1)
			}
		}()
		
		return cell
	}
}

extension ATLoopView: UICollectionViewDelegate {
	
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		self.touchUpFocus?(indexPath.row - 1)
	}
	
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		let progress = scrollView.contentOffset.x
		
		if progress == 0.0 {
			scrollView.contentOffset.x = scrollView.contentSize.width - bounds.width * 2
		} else if progress == scrollView.contentSize.width - bounds.width {
			scrollView.contentOffset.x = self.bounds.width
		}
		
	}
	
}
