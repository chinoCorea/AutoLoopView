//
//  ViewController.swift
//  AutoLoopView
//
//  Created by Apple Jin on 16/1/6.
//  Copyright © 2016年 onwer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var loopView: ATLoopView?
	@IBOutlet var csLoopView: SCLoopView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setSCLoopView()
	}

	func setATLoopView() {
		let datas = ["ruby", "swift", "python", "objective-c", "git"]
		
		loopView?.numberOfFocus { () -> Int in
			return datas.count
		}
		
		loopView?.focusAtIndex { (index) -> UIView in
			let label = UILabel()
			label.text = datas[index]
			label.textAlignment = .Center
			label.backgroundColor = UIColor(hue: CGFloat(index * 360 / datas.count)/360.0,
				saturation: 1.0,
				brightness: 1.0,
				alpha: 1.0)
			
			return label
		}
		
		loopView?.touchUpFocus { (index) -> Void in
			print(datas[index])
		}
		
		loopView?.checkUpSchedule { (schedule) -> Void in
			print(schedule)
		}
	}
	
	func setSCLoopView() {
		let datas = ["Java SE", "PHP", "Shell", "Ruby"]
		
		csLoopView?.numberOfFocus = {
			return datas.count
		}
		
		csLoopView?.focusForIndex = { index in
			let label = UILabel()
			label.text = datas[index]
			label.textAlignment = .Center
			label.font = UIFont(name: "Zapfino", size: 15.0)
			
			return label
		}
		
		csLoopView?.touchUpFocus = { index in
			print(datas[index])
		}
		
		csLoopView?.loadFocus()
	}
}

