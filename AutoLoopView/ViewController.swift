//
//  ViewController.swift
//  AutoLoopView
//
//  Created by Apple Jin on 16/1/6.
//  Copyright © 2016年 onwer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var loopView: ATLoopView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loopView.numberOfFocus { () -> Int in
			return 3
		}
		
		loopView.focusAtIndex { (index) -> UIView in
			let label = UILabel()
			label.text = "\(index)"
			label.textAlignment = .Center
			label.backgroundColor = UIColor(hue: CGFloat(index * 360 / 2)/360.0,
									 saturation: 1.0,
									 brightness: 1.0,
										  alpha: 1.0)
			
			return label
		}
		
		loopView.touchUpFocus { (index) -> Void in
			print(index)
		}
		
		loopView.checkUpSchedule { (schedule) -> Void in
			print(schedule)
		}
		
	}

}

