//
//  JMEParallaxView.m
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

#import "JMEParallaxView.h"
#import "FBKVOController.h"

static void * scrollViewObservingContext = &scrollViewObservingContext;

@interface JMEParallaxView ()
@property (strong, nonatomic) FBKVOController *kvoController;
@property (readonly, nonatomic) CGFloat contentLength;
@property (nonatomic) float velocity;
// Private Methods
- (void)updateSettings;
@end

@implementation JMEParallaxView

#pragma mark - Constructors

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // self
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        // content image view
        self.contentImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImageView.backgroundColor = [UIColor clearColor];
        self.contentImageView.clipsToBounds = YES;
        [self addSubview:self.contentImageView];
        
        // defaults
        self.contentDisplayingPercentage = 0.8; // this should be set before direction
        self.direction = JMEParallaxHorizontal;
        self.reversedContentRevealing = YES;
        self.activeRange = CGPointZero;
    }
    return self;
}

#pragma mark - View Lifecycyle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Move contentImageView.frame to the right position when this view is displayed the very first time
    if (self.observingScrollView) {
        [self parallaxWithScrollView:self.observingScrollView];
    }
}

#pragma mark - Accessors

// Private
- (CGFloat)contentLength
{
    if (self.direction == JMEParallaxHorizontal) {
        return floorf(CGRectGetWidth(self.frame) / self.contentDisplayingPercentage);
    }
    else {
        return floorf(CGRectGetHeight(self.frame) / self.contentDisplayingPercentage);
    }
}

// Public
- (void)setDirection:(JMEParallaxDirection)direction
{
    _direction = direction;
    [self updateSettings];
}

- (void)setContentDisplayingPercentage:(float)contentDisplayingPercentage
{
    NSParameterAssert(contentDisplayingPercentage <= 1);
    NSParameterAssert(contentDisplayingPercentage > 0);
    _contentDisplayingPercentage = contentDisplayingPercentage;
    [self updateSettings];
}

- (void)setActiveRange:(CGPoint)activeRange
{
    _activeRange = activeRange;
    [self updateSettings];
}

- (void)setAnchorOffset:(CGFloat)anchorOffset
{
    _anchorOffset = anchorOffset;
}

- (void)setObservingScrollView:(UIScrollView *)observedScrollView
{
    if (!self.kvoController) {
        self.kvoController = [FBKVOController controllerWithObserver:self];
    }
    
    if (observedScrollView != self.observingScrollView) {
        _observingScrollView = observedScrollView;
        
        __weak __typeof(&*self) weakSelf = self;
        [self.kvoController observe:self.observingScrollView
                            keyPath:@"contentOffset"
                            options:NSKeyValueObservingOptionNew
                              block:^(id observer, id object, NSDictionary *change){
                                  __strong __typeof(&*weakSelf) strongSelf = weakSelf;
                                  [strongSelf parallaxWithContentOffset:[change[NSKeyValueChangeNewKey] CGPointValue]];
                              }];
    }
}

#pragma mark - Class Methods

+ (CGPoint)activeRangeWithScrollView:(UIScrollView *)scrollView
                          pageLength:(CGFloat)pageLength
                          pageNumber:(NSInteger)pageNumber
                           direction:(JMEParallaxDirection)direction
                          edgeInsets:(UIEdgeInsets)edgeInsets
{
    CGFloat min;
    CGFloat max;
    
    if (direction == JMEParallaxHorizontal) {
        min = pageNumber*pageLength - CGRectGetWidth(scrollView.frame);
        max = pageNumber*pageLength + pageLength;
        
        min += edgeInsets.left;
        max -= edgeInsets.right;
    }
    else {
        min = pageNumber*pageLength - CGRectGetHeight(scrollView.frame);
        max = pageNumber*pageLength + pageLength;
        
        min += edgeInsets.top;
        max -= edgeInsets.bottom;
    }
    
    return CGPointMake(min, max);
}

+ (CGPoint)activeRangeWithTableView:(UITableView *)tableView
                          indexPath:(NSIndexPath *)indexPath
                          direction:(JMEParallaxDirection)direction
                         edgeInsets:(UIEdgeInsets)edgeInsets
{
    CGFloat min;
    CGFloat max;
    
    if (direction == JMEParallaxHorizontal) {
        min = CGRectGetMinX([tableView rectForRowAtIndexPath:indexPath]) - CGRectGetWidth(tableView.frame);
        max = CGRectGetMaxX([tableView rectForRowAtIndexPath:indexPath]);
        
        min += edgeInsets.left;
        max -= edgeInsets.right;
    }
    else {
        min = CGRectGetMinY([tableView rectForRowAtIndexPath:indexPath]) - CGRectGetHeight(tableView.frame);
        max = CGRectGetMaxY([tableView rectForRowAtIndexPath:indexPath]);
        
        min += edgeInsets.top;
        max -= edgeInsets.bottom;
    }
    
    return CGPointMake(min, max);
}

#pragma mark - Instance Methods

- (void)parallaxWithScrollView:(UIScrollView *)scrollView
{
    [self parallaxWithContentOffset:scrollView.contentOffset];
}

- (void)parallaxWithContentOffset:(CGPoint)contentOffset
{
    CGFloat lowerBound = MIN(self.activeRange.x, self.activeRange.y);
    CGFloat upperBound = MAX(self.activeRange.x, self.activeRange.y);
    CGFloat anchor = (self.direction==JMEParallaxHorizontal?contentOffset.x:contentOffset.y) + self.anchorOffset;
    CGRect frame = self.contentImageView.frame;
    
    // reversed content revealing
    if (self.reversedContentRevealing) {
        if (anchor <= lowerBound) {
            (self.direction==JMEParallaxHorizontal) ? (frame.origin.x = 0) : (frame.origin.y = 0);
        }
        else if (anchor >= upperBound) {
            (self.direction==JMEParallaxHorizontal) ?
            (frame.origin.x = CGRectGetWidth(self.frame)-self.contentLength) :
            (frame.origin.y = CGRectGetHeight(self.frame)-self.contentLength);
        }
        else if ((anchor>lowerBound) && (anchor<upperBound)) {
            CGFloat offset = (anchor-upperBound) * self.velocity;
            (self.direction==JMEParallaxHorizontal) ? (frame.origin.x = offset) : (frame.origin.y = offset);
        }
    }
    else {
        if (anchor <= lowerBound) {
            (self.direction==JMEParallaxHorizontal) ?
            (frame.origin.x = CGRectGetWidth(self.frame)-self.contentLength) :
            (frame.origin.y = CGRectGetHeight(self.frame)-self.contentLength);
        }
        else if (anchor >= upperBound) {
            (self.direction==JMEParallaxHorizontal) ? (frame.origin.x = 0) : (frame.origin.y = 0);
        }
        else if ((anchor>lowerBound) && (anchor<upperBound)) {
            CGFloat offset = (lowerBound-anchor) * self.velocity;
            (self.direction==JMEParallaxHorizontal) ? (frame.origin.x = offset) : (frame.origin.y = offset);
        }
    }
    
    self.contentImageView.frame = frame;
}

#pragma mark - Private Methods

- (void)updateSettings
{
    // changes made by contentDisplayingPercentage
    CGRect frame = self.contentImageView.frame;
    if (self.direction == JMEParallaxHorizontal) {
        frame.size.width = self.contentLength;
        frame.size.height = CGRectGetHeight(self.frame);
    }
    else {
        frame.size.width = CGRectGetWidth(self.frame);
        frame.size.height = self.contentLength;
    }
    self.contentImageView.frame = frame;
    
    // changes made by activeRange
    CGFloat slidingRangeLength;
    CGFloat activeRangeLength = abs(self.activeRange.x - self.activeRange.y);
    if (self.direction == JMEParallaxHorizontal) {
        slidingRangeLength = self.contentLength - CGRectGetWidth(self.frame);
    }
    else {
        slidingRangeLength = self.contentLength - CGRectGetHeight(self.frame);
    }
    self.velocity = slidingRangeLength / activeRangeLength;
}

@end
