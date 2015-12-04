//
//  RegisterViewController.h
//  iossbm
//
//  Created by lrw on 15/11/10.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *registerPassword;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@property (weak, nonatomic) IBOutlet UIButton *getSecurityButton;

///验证码回应
-(void)changeTitle;
-(void)registerStrat;
@end
