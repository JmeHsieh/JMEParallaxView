//
//  JMEParallaxView.h
//  JMEParallaxView
//
//  Created by Jme on 5/4/14.
//  Copyright (c) 2014 JmeHsieh. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JMEParallaxDirection)
{
    JMEParallaxHorizontal,
    JMEParallaxVertical
};

@interface JMEParallaxView : UIView

/**
 @abstract Default consctuctor.
 @param frame The frame of this view.
 @discussion Use this constructor only.
 */
- (instancetype)initWithFrame:(CGRect)frame;


/// Controls the direction of parallax effect. Default to JMEParallaxHorizontal.
@property (nonatomic) JMEParallaxDirection direction;

/// The sliding image view to result in parallax effect.
@property (strong, nonatomic) UIImageView *contentImageView;

/// Controls how the content would be revealed while scrolling. Default to YES.
@property (nonatomic) BOOL reversedContentRevealing;

/// Controls how much content should be displayed. Default to 80%.
@property (nonatomic) float contentDisplayingPercentage;

/// The active range that controls when to start/stop parallax effect while scrolling.
@property (nonatomic) CGPoint activeRange;

/// Controls the guide line for checking active range. Default to 0.
@property (nonatomic) CGFloat anchorOffset;

/// The scroll view we are responding to.
/// Optional. When nil, call parallaxWithScrollView: or parallaxWithContentOffset: manyally in scrollViewDidScroll: to update parallax effect.
@property (strong, nonatomic) UIScrollView *observingScrollView;


/**
 @abstract Convenient method for calculating active range.
 @param scrollView The scrollView we are responding to.
 @param pageLength The width or height of a page in scrollView.
 @param pageNumber The index of the page.
 @param direction The JMEParallaxDirection of JMEParallaxView instance that's going to be used.
 @param edgeInsets The margin of JMEParallaxView that's going to be used.
 @discussion The convenient method for calculating active range of a JMEParallaxView, in UIScrollView case.
 */
+ (CGPoint)activeRangeWithScrollView:(UIScrollView *)scrollView
                          pageLength:(CGFloat)pageLength
                          pageNumber:(NSInteger)pageNumber
                           direction:(JMEParallaxDirection)direction
                          edgeInsets:(UIEdgeInsets)edgeInsets;

/**
 @abstract Convenient method for calculating active range.
 @param tableView The tableView we are responding to.
 @param indexPath The indexPath of the cell.
 @param direction The JMEParallaxDirection of JMEParallaxView instance that's going to be used.
 @param edgeInsets The margin of JMEParallaxView that's going to be used.
 @discussion The convenient method for calculating active range of a JMEParallaxView, in UITableView case.
 */
+ (CGPoint)activeRangeWithTableView:(UITableView *)tableView
                          indexPath:(NSIndexPath *)indexPath
                          direction:(JMEParallaxDirection)direction
                         edgeInsets:(UIEdgeInsets)edgeInsets;

/**
 @abstract Convenient method for calculating active range.
 @param collectionView The collectionView we are responding to.
 @param indexPath The indexPath of the cell.
 @param direction The JMEParallaxDirection of JMEParallaxView instance that's going to be used.
 @param edgeInsets The margin of JMEParallaxView that's going to be used.
 @discussion The convenient method for calculating active range of a JMEParallaxView, in UITableView case.
 */
+ (CGPoint)activeRangeWithCollectionView:(UICollectionView *)collectionView
                               indexPath:(NSIndexPath *)indexPath
                               direction:(JMEParallaxDirection)direction
                              edgeInsets:(UIEdgeInsets)edgeInsets;

/**
 @abstract Update contentImageView's frame.
 @param scrollView The scrollView we are responding to.
 @discussion Manually call this in scrollViewDidScroll: if observedScrollView is not set.
 */
- (void)parallaxWithScrollView:(UIScrollView *)scrollView;

/**
 @abstract Convenient method for calculating active range.
 @param tableView The tableView we are responding to.
 @param indexPath The indexPath of the cell.
 @param direction The JMEParallaxDirection of JMEParallaxView instance that's going to be used.
 @param edgeInsets The margin of JMEParallaxView that's going to be used.
 @discussion Manually call this in scrollViewDidScroll: if observedScrollView is not set.
 */
- (void)parallaxWithContentOffset:(CGPoint)contentOffset;

@end
