# AutoLoopView

- This is an project like the top view of App Store. I have written a demo but it has 
some bug. Please experts modify the code that I write and imporve the function, and please 
create a new branch with named like (Modification-YourName) when commit the code, Thanks!

## Requirements

- iOS 7.0+

## Installation

> **Download [Zip file]("https://github.com/Alamofire/Alamofire/archive/master.zip") and insert into your project or copy source file and paste in your project.

## Usage

> **ATLoopView inherit UIView, and there is an UICollectionView in ATLoopView. so when you use Storyboard to creat this view, please pull UIView and make its superclass as ATLoopView

### Making Models And Initialize ATLoopView

```swift
import AutoLoopView

let datas = ["ruby", "swift", "python", "objective-c", "git"]

let loopView = ATLoopView(frame: CGRect(x: 0.0, 
										y: 0.0, 
									width: UIScreen.mainScreen().bounds.width, 
								   height: 130.0), 
				   loopDuration: 7.0)
```

### Setting Datas

```swift
loopView.numberOfFocus { () -> Int in
	return datas.count
}

loopView.focusAtIndex { (index) -> UIView in
	let label = UILabel()
	label.text = datas[index]
	label.textAlignment = .Center
	label.backgroundColor = UIColor(hue: CGFloat(index * 360 / datas.count) / 360.0,
							 saturation: 1.0,
							 brightness: 1.0,
								  alpha: 1.0)

	return label
}

loopView.touchUpFocus { (index) -> Void in
	print(datas[index])
}

loopView.checkUpSchedule { (schedule) -> Void in
	print(schedule)
}
```
## My Eamil

- 1642018345@qq.com or jjinglin@gmail.com