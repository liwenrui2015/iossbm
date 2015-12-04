//
//  ViewController.h
//  iossbm
//
//  Created by lrw on 15/11/5.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
@interface ViewController : UIViewController<UIScrollViewDelegate,MapViewControllerDidSelectDelegate>
@property (weak, nonatomic) UIPageControl * pageControl;

- (void)start:(id)sender;
-(void)SecondTimeStar;
@end

