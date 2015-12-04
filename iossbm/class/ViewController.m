//
//  ViewController.m
//  iossbm
//
//  Created by lrw on 15/11/5.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "ViewController.h"
#import "MoerTableViewController.h"
#import "UserInfoTableViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface ViewController ()
{
   
}
@property (strong, nonatomic) UIScrollView * scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //等待一秒显示启动页面
    [NSThread sleepForTimeInterval:0.5];
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"isFristStar"])
    {
        NSLog(@"是第一次进入APP");
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.frame = self.view.bounds;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
        // ad data
        NSArray * ads = @[@"Welcome_3.0_1.png", @"Welcome_3.0_2.png", @"Welcome_3.0_3.png", @"Welcome_3.0_4.png", @"Welcome_3.0_5.png"];
        
        // config scroll view and image views;
        for (int i = 0 ; i < ads.count; i++)
        {
            UIImage * image = [UIImage imageNamed:ads[i]];
            
            UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
            CGRect frame = self.scrollView.frame;
            frame.origin.x = i * frame.size.width;
            frame.origin.y = 0;
            imageView.frame = frame;
            [self.scrollView addSubview:imageView];
            
            if (i == ads.count - 1) {
                UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
                [next addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
                next.frame = imageView.frame;
                [self.scrollView addSubview:next];
            }
        }
        
        CGSize size = self.scrollView.frame.size;
        size.width *= ads.count;
        self.scrollView.contentSize = size;
        self.scrollView.delegate = self;
        
        // config the page control
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 20);
        pageControl.numberOfPages = ads.count;
       
        pageControl.pageIndicatorTintColor=[UIColor grayColor];
       
        pageControl.currentPageIndicatorTintColor=[UIColor redColor];
        pageControl.currentPage = 0;
        pageControl.userInteractionEnabled = NO;
        self.pageControl = pageControl;
        [self.view addSubview:pageControl];
    }
    else
    {
        NSLog(@"是再次进入APP,直接跳过欢迎页面;");
    }

}
-(void)viewDidAppear:(BOOL)animated
{
     if([[NSUserDefaults standardUserDefaults]boolForKey:@"isFristStar"])
    [self SecondTimeStar];
}
-(void)SecondTimeStar
{

    
    HomeViewController* homeViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
     homeViewController.title=@"首页";
    UINavigationController * n1 = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    n1.title = @"首页";
    n1.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_my_music.png"];
    
    MapViewController*  _mapViewController = [[MapViewController alloc]init];
    UINavigationController * n2 = [[UINavigationController alloc] initWithRootViewController:_mapViewController];
    n2.title = @"地图";
    n2.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_my_map.png"];
    
    
    
    UserInfoTableViewController * userInfoTableViewController = [[UserInfoTableViewController alloc] initWithNibName:@"UserInfoTableViewController" bundle:nil];
    userInfoTableViewController.title=@"个人中心";
    UINavigationController * n3 = [[UINavigationController alloc] initWithRootViewController:userInfoTableViewController];
    n3.title =@"我的";
    n3.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_store.png"];
    
    
    MoerTableViewController * moerViewController = [[MoerTableViewController alloc] initWithNibName:@"MoerTableViewController" bundle:nil];
    moerViewController.title=@"更多";
    UINavigationController * n4 = [[UINavigationController alloc] initWithRootViewController:moerViewController];
    n4.title =@"更多";
    n4.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_more.png"];
    

    UITabBarController * tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[n1,n2,n3,n4];
    
    tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:tabBarController animated:YES completion:nil];

}
- (void)customMKMapViewDidSelectedWithInfo:(id)info
{
    NSLog(@"%@",info);
}
- (void)start:(id)sender {
    //修改NSuserDefaults修改不是第一次登录
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isFristStar"];
    [self SecondTimeStar];

    
//    TRSelectedViewController * selectedViewController = [[TRSelectedViewController alloc] initWithNibName:@"TRSelectedViewController" bundle:nil];
//    selectedViewController.channels = @[@"channel01.png", @"channel02.png", @"channel03.png",
//                                        @"channel04.png", @"channel05.png", @"channel06.png",
//                                        @"channel07.png", @"channel08.png", @"channel09.png"];
//    UINavigationController * n2 = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
//    n2.title = @"精选";
//    n2.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_selected.png"];
//
//    TRStoreViewController * storeViewController = [[TRStoreViewController alloc] initWithNibName:@"TRStoreViewController" bundle:nil];
//    UINavigationController * n3 = [[UINavigationController alloc] initWithRootViewController:storeViewController];
//    n3.title = @"乐库";
//    n3.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_store.png"];
//    
//    TRMoreViewController * moreViewController = [[TRMoreViewController alloc] initWithNibName:@"TRMoreViewController" bundle:nil];
//    UINavigationController * n4 = [[UINavigationController alloc] initWithRootViewController:moreViewController];
//    n4.title = @"更多";
//    n4.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_more.png"];
    
//    
//    UITabBarController * tabBarController = [[UITabBarController alloc] init];
//    tabBarController.viewControllers = @[n1,n2,n3,n4];
//    
//    tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:tabBarController animated:YES completion:nil];
//    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   self.pageControl.currentPage = round(scrollView.contentOffset.x / scrollView.frame.size.width);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
