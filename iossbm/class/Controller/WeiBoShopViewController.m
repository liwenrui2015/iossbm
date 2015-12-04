//
//  WeiBoShopViewController.m
//  iossbm
//
//  Created by lrw on 15/11/19.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "WeiBoShopViewController.h"

@interface WeiBoShopViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *shopView;

@end

@implementation WeiBoShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"微商店";

    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBackToHome)];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://358636.m.weimob.com/vshop/index"]];
    [_shopView loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)goBackToHome
{
    [self.shopView goBack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{

   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
