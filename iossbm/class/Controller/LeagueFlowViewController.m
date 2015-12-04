//
//  LeagueFlowViewController.m
//  iossbm
//
//  Created by lrw on 15/11/10.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "LeagueFlowViewController.h"

@interface LeagueFlowViewController ()

@end

@implementation LeagueFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.textInfo.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    self.title=@"加盟";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidDisappear:(BOOL)animated
{
   NSLog(@"viewDidDisappear");
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
