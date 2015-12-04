//
//  ForgotViewController.m
//  iossbm
//
//  Created by lrw on 15/11/11.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "ForgotViewController.h"
#import "AFNetworking.h"
#import "commonTools.h"
#import <SMS_SDK/SMSSDK.h>
@interface ForgotViewController ()<UIAlertViewDelegate>
{
    NSInteger _number;
    NSTimer * _timerCode;
}
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *notarize;
@property (weak, nonatomic) IBOutlet UITextField *security;
@property (weak, nonatomic) IBOutlet UIButton *securityBut;
-(void)changeTitle;
-(void)reSetPassword;
@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
}

- (IBAction)getSecurity:(UIButton *)sender
{
    if([commonTools validateMobile:self.UserName.text])
    {
        NSString * path =[NSString stringWithFormat:@"%@testUser?",IP];
        NSDictionary * parsms =@{@"userName":self.UserName.text};
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        
        [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"=======%@",[dic objectForKey:@"result"]);
             if([[dic objectForKey:@"result"] isEqualToString:@"success"])
             {
                 [sender setEnabled:NO];
                 _number=30;
                 _timerCode=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTitle) userInfo:@"" repeats:YES];
                 [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.UserName.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                     if (!error)
                     {
                         NSLog(@"获取验证码成功");
                     } else {
                         UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"获取验证失败" message:[NSString stringWithFormat:@"错误码：%zi,错误描述：%@",error.code,error.userInfo]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                         [arrate show];
                         NSLog(@"错误吗：%zi,错误描述：%@",error.code,error.userInfo);
                     }
                 }];
                 
             }else
             {
                 UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"未注册" message:@"该号码未注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [arrate show];
             }
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"111请求失败%@",error);
         }];
        
        
        
    }
    else
    {
        NSLog(@"不能识别的手机号码");
        UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊手机号" message:@"手机号码太高级了解析不了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [arrate show];
    }
}
- (IBAction)submiteOK:(id)sender
{
    
    
    if([commonTools validateMobile:self.UserName.text])
    {
        if([commonTools validatePassword:self.Password.text])
        {
            if([self.Password.text isEqualToString:self.notarize.text])
            {
                if(![self.security.text isEqualToString:@""])
                {
                    [SMSSDK commitVerificationCode:self.security.text phoneNumber:self.UserName.text zone:@"86" result:^(NSError *error) {
                        if (!error) {
                            NSLog(@"获取验证码成功");
                            
                            [self reSetPassword];
                            
                        } else {
                            UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"获取验证失败" message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"commitVerificationCode"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [arrate show];
                            NSLog(@"错误吗：%zi,错误描述：%@",error.code,[error.userInfo objectForKey:@"commitVerificationCode"]);
                        }
                    }];
                }
                else
                {
                    UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"验证码不可以为空" message:@"请重新输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [arrate show];
                    NSLog(@"密码有误");
                }
            }
            else
            {
                UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"两次密码不一致" message:@"请从新数据密码和确认密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [arrate show];
                NSLog(@"密码有误");
            }
        }
        else
        {
            UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊密码" message:@"密码是6-20数字和字母的组合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [arrate show];
            NSLog(@"密码有误");
            
        }
        
    }else
    {
        NSLog(@"不能识别的手机号码");
        UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊手机号" message:@"手机号码太高级了解析不了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [arrate show];
    }
}
-(void)changeTitle
{
    _number--;
    [self.securityBut setTitle:[NSString stringWithFormat:@"获取验证码%ld",(long)_number] forState:UIControlStateNormal];
    if(_number==0)
    {
        [_timerCode invalidate];
        [self.securityBut setEnabled:YES];
        [self.securityBut setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

-(void)reSetPassword
{
    
    
    NSString * path =[NSString stringWithFormat:@"%@updatePassword?",IP];
    
    NSDictionary * parsms =@{@"userName":self.UserName.text ,@"password":self.Password.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"=======%@",[dic objectForKey:@"result"]);
         if([[dic objectForKey:@"result"] isEqualToString:@"success"])
         {
             
             [[NSUserDefaults standardUserDefaults]setObject:self.UserName.text forKey:UserLoginName];
             [[NSUserDefaults standardUserDefaults]setObject:self.Password.text forKey:UserPassword];
             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:IsLogin];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }else
         {
             UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊手机号" message:@"手机号码太高级了解析不了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [arrate show];
             
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
    
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
