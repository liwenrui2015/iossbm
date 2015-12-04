//
//  GameViewController.m
//  iossbm
//
//  Created by lrw on 15/12/3.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
- (IBAction)gotoLocalPlan:(id)sender {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id444934666"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)gotoJinlinxiagu:(id)sender {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id444934666"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)gotoLuanshu:(id)sender {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id444934666"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)gotoFangunyazi:(id)sender {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id444934666"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
