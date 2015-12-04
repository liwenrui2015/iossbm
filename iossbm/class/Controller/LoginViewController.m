//
//  LoginViewController.m
//  iossbm
//
//  Created by lrw on 15/11/9.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "commonTools.h"
#import "ForgotViewController.h"

@interface LoginViewController ()<UIAlertViewDelegate>

@end

@implementation LoginViewController
- (IBAction)forgotPassword:(id)sender
{
    ForgotViewController * forgot= [[ForgotViewController alloc]initWithNibName:@"ForgotViewController" bundle:nil];
    [self.navigationController pushViewController:forgot animated:YES];
}
- (IBAction)Coumstregister:(id)sender
{
    RegisterViewController* registerView = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
    
}
- (IBAction)loginIN:(id)sender
{
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
    {
        //电话号码匹配
        if([commonTools validateMobile:self.UserName.text])
        {
            //密码匹配
            if([commonTools validatePassword:self.PassWord.text])
            {
                
                NSString * path =[NSString stringWithFormat:@"%@login?",IP];
                NSDictionary * parsms =@{@"userName":self.UserName.text,@"password":self.PassWord.text};
                
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                
                
                [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     
                     NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     if([[dic objectForKey:@"result"]isEqualToString:@"success"])
                     {
                         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:IsLogin];
                         [[NSUserDefaults standardUserDefaults]setObject:self.UserName.text forKey:UserLoginName];
                         [[NSUserDefaults standardUserDefaults]setObject:self.PassWord.text forKey:UserPassword];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                     else
                     {
                         UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"检查用户名和密码" message:@"用户名和密码不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                         [arrate show];
                     }
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"111请求失败%@",error);
                 }];
            }else
            {
                NSLog(@"米娜有误");
                UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"特殊密码" message:@"密码是6-20数字和字母的组合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [arrate show];
            }
        }
        else
        {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"特殊手机号" message:@"手机号码太高级了解析不了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
        }
        
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
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
