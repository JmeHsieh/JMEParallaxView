# JMEParallaxView

[![Version](http://cocoapod-badges.herokuapp.com/v/JMEParallaxView/badge.png)](http://cocoadocs.org/docsets/JMEParallaxView)
[![Platform](http://cocoapod-badges.herokuapp.com/p/JMEParallaxView/badge.png)](http://cocoadocs.org/docsets/JMEParallaxView)

An easy-configuring UIView + UIImageView to perform parallax effect.

<img src="./Demo.png" alt="JMEParallaxView Screenshot" width="320" height="568" />
<img src="./Demo.gif" alt="JMEParallaxView Screenshot" width="320" height="568" />

[Youtube Video](http://www.youtube.com/watch?v=UzX166Lsw_M)

## Requirements
* Xcode 5 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

## Demo

Build and run `JMEParallaxViewExample` Xcode workspace to see how `JMEParallaxView` works.

## Usage

``` objective-c
parallaxView.observingScrollView = tableView; 
parallaxView.contentImageView.image = yourImage;
parallaxView.contentDisplayingPercentage = 0.8; 
parallaxView.activeRange = [JMEParallaxView activeRangeWithTableView:tableView indexPath:indexPath direction:parallaxView.direction edgeInsets:UIEdgeInsetsZero];
```

See more in the example project.

## Installation

JMEParallaxView is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

``` bash
pod "JMEParallaxView"
```
    
Alternatively, you can manually copy the files under `JMEParallaxView` directory into your project. Just be sure to have [KVOController](https://github.com/facebook/KVOController) in your project, since we use it to track your scroll view.

## Contact

Jo-Yuan Hsieh

- https://github.com/jmehsieh
- https://twitter.com/jmehsieh
- jmehsieh@gmail.com

## Notes and Accreditation

JMEParallaxView very gratefully makes use of these other fantastic open source projects:

- [KVOController](https://github.com/facebook/KVOController) - Used to track scrolling events of UIScrollView.

Demo photos kindly provided by Jo-Yuan Hsieh (<http://instagram.com/jmehsieh>).

## License

JMEParallaxView is available under the MIT license. See the LICENSE file for more info.

