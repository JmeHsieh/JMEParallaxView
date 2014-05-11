//
//  ParallaxTableViewController.m
//  JMEParallaxView
//
//  Created by Jme on 5/8/14.
//  Copyright (c) 2014 JmeHsieh. All rights reserved.
//

#import "ParallaxTableViewController.h"
#import "JMEParallaxView.h"

static const NSInteger kPhotosCount = 20;
static const CGFloat kPadding = 10;
static const CGFloat kImageHeight = 130;
static const CGFloat kRowHeight = 2*kPadding + kImageHeight;

@interface ParallaxTableViewController ()
@property (strong, nonatomic) NSArray *photos;
@end

@implementation ParallaxTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:kPhotosCount];
        for (int i=0; i<kPhotosCount; ++i) {
            photos[i] = [NSString stringWithFormat:@"%d.jpg", i];
        }
        self.photos = [NSArray arrayWithArray:photos];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photos";
    self.tableView.rowHeight = kRowHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

#pragma mark 0 UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        JMEParallaxView *parallaxView = [[JMEParallaxView alloc] initWithFrame:CGRectMake(0, kPadding, 320, kImageHeight)];
        parallaxView.tag = 111;
        parallaxView.direction = JMEParallaxVertical;
        parallaxView.reversedContentRevealing = YES;
        parallaxView.contentDisplayingPercentage = 0.6;
        parallaxView.anchorOffset = tableView.contentInset.top;
        parallaxView.observingScrollView = tableView;
        
        [cell.contentView addSubview:parallaxView];
    }
    
    JMEParallaxView *parallaxView = (JMEParallaxView *)[cell viewWithTag:111];
    parallaxView.contentImageView.image = [UIImage imageNamed:self.photos[indexPath.row]];
    parallaxView.activeRange = [JMEParallaxView activeRangeWithTableView:tableView
                                                               indexPath:indexPath
                                                               direction:parallaxView.direction
                                                              edgeInsets:UIEdgeInsetsMake(kPadding, 0, kPadding, 0)];
    
    return cell;
}

@end
