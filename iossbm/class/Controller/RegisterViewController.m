//
//  RegisterViewController.m
//  iossbm
//
//  Created by lrw on 15/11/10.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "RegisterViewController.h"
#import "commonTools.h"
#import <SMS_SDK/SMSSDK.h>
#import "AFNetworking.h"
@interface RegisterViewController ()<UIAlertViewDelegate>
{
    NSInteger _number;
    NSTimer * _timerCode;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    // Do any additional setup after loading the view from its nib.
}
//获取验证码
- (IBAction)getSecurityCode:(UIButton *)sender
{
    if([commonTools validateMobile:self.phoneNumber.text])
    {
        NSLog(@"是正确的手机号码");
        [sender setEnabled:NO];
        _number=30;
        _timerCode=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTitle) userInfo:@"" repeats:YES];
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumber.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error)
            {
                NSLog(@"获取验证码成功");
            } else {
                UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"获取验证失败" message:[NSString stringWithFormat:@"错误码：%zi,错误描述：%@",error.code,error.userInfo]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [arrate show];
                NSLog(@"错误吗：%zi,错误描述：%@",error.code,error.userInfo);
            }
        }];
    }
    else
    {
        NSLog(@"不能识别的手机号码");
        UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊手机号" message:@"手机号码太高级了解析不了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [arrate show];
    }
}

//注册
- (IBAction)Register:(id)sender
{
    if([commonTools validateMobile:self.phoneNumber.text])
    {
        if([commonTools validatePassword:self.registerPassword.text])
        {
        NSLog(@"号码和密码可以通过");
        [SMSSDK commitVerificationCode:self.securityCode.text phoneNumber:self.phoneNumber.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSLog(@"获取验证码成功");
                
                [self registerStrat];
                
            } else {
                UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"获取验证失败" message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"commitVerificationCode"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [arrate show];
                NSLog(@"错误吗：%zi,错误描述：%@",error.code,[error.userInfo objectForKey:@"commitVerificationCode"]);
            }
        }];
        }else
        {
            UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊密码" message:@"密码是6-20数字和字母的组合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [arrate show];
             NSLog(@"密码有误");
        }
    }
    else
    {
        UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊手机号" message:@"手机号码太高级了解析不了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [arrate show];
        NSLog(@"号码有误");
    }
    

    
    
}
-(void)registerStrat
{
    NSString * path =[NSString stringWithFormat:@"%@rigist?",IP];
    
    NSDictionary * parsms =@{@"userName":self.phoneNumber.text ,@"password":self.registerPassword.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //         NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"=======%@",[dic objectForKey:@"result"]);
         if([[dic objectForKey:@"result"] isEqualToString:@"success"])
         {
             
             [[NSUserDefaults standardUserDefaults]setObject:self.phoneNumber.text forKey:UserLoginName];
             [[NSUserDefaults standardUserDefaults]setObject:self.registerPassword.text forKey:UserPassword];
             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:IsLogin];
             
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
 
}


-(void)changeTitle
{
    _number--;
    [self.getSecurityButton setTitle:[NSString stringWithFormat:@"获取验证码%ld",(long)_number] forState:UIControlStateNormal];
    if(_number==0)
    {
        [_timerCode invalidate];
        [self.getSecurityButton setEnabled:YES];
        [self.getSecurityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
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
