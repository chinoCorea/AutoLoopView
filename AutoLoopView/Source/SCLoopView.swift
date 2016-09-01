//
//  SCLoopView.swift
//  AutoLoopView
//
//  Created by Apple Jin on 16/8/29.
//  Copyright © 2016年 onwer. All rights reserved.
//

import UIKit

class SCLoopView: UIScrollView {

	var numberOfFocus: () -> Int = { return 0 }
	var focusForIndex: (Int) -> UIView = { _ in UIView() }
	var touchUpFocus: (Int) -> Void = { _ in }
	var updateSchedule: (CGFloat) -> Void = { _ in }
	
	override func layoutSubviews() {
		self.contentSize = CGSize(width: bounds.width * CGFloat(numberOfFocus() + 2), height: bounds.height)
		
		for index in 0..<(numberOfFocus() + 2) {
			viewWithTag(index + 100)?.frame = CGRect(x: CGFloat(index) * bounds.width,
			                                         y: 0.0,
			                                         width: bounds.width,
			                                         height: bounds.height)
		}
		
		if contentOffset.x == 0.0 {
			self.contentOffset = CGPoint(x: bounds.width, y: 0.0)
		} else if contentOffset.x < 1.0 {
			self.contentOffset = CGPoint(x: bounds.width * CGFloat(numberOfFocus()), y: 0.0)
		} else if contentOffset.x > bounds.width * CGFloat(numberOfFocus() + 1) {
			self.contentOffset = CGPoint(x: bounds.width, y: 0.0)
		}
	}
	
	@objc private func touchUpView(tap: UITapGestureRecognizer) {
		guard let tag = tap.view?.tag else { return }
		let index = (tag - 100) < 0 ? 0 : (tag - 100)
		
		touchUpFocus(index)
	}
	
	func loadFocus() {
		let focusNum = numberOfFocus() + 2
		
		self.pagingEnabled = true
		
		for index in 0..<focusNum {
			let view: UIView
			
			if index == 0 {
				view = focusForIndex(focusNum - 3)
			} else if index == focusNum - 1 {
				view = focusForIndex(0)
			} else {
				view = focusForIndex(index - 1)
			}
			
			view.userInteractionEnabled = true
			view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SCLoopView.touchUpView(_:))))
			view.tag = 100 + index
			self.addSubview(view)
		}
	}
}
