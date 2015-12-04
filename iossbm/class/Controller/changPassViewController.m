//
//  changPassViewController.m
//  iossbm
//
//  Created by lrw on 15/11/11.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "changPassViewController.h"
#import "commonTools.h"
#import "AFNetworking.h"
@interface changPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField * oldPassword;
@property (weak, nonatomic) IBOutlet UITextField * changPassword;
@property (weak, nonatomic) IBOutlet UITextField *checkPassword;
@end

@implementation changPassViewController
- (IBAction)submitOK:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:UserPassword]isEqualToString:_oldPassword.text])
    {
        
        if([_changPassword.text isEqualToString:_checkPassword.text])
        {
            if ([commonTools validatePassword:_changPassword.text])
            {
                NSString * path =[NSString stringWithFormat:@"%@updatePassword?",IP];
                NSDictionary * parsms =@{@"userName":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName] ,@"userPassword":_changPassword.text};
                NSLog(@"更新%@,%@ path=%@",[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName],_changPassword.text,path);
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                
                [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     
                     NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     NSLog(@"=======%@",[dic objectForKey:@"result"]);
                     if([[dic objectForKey:@"result"] isEqualToString:@"success"])
                     {
                         [[NSUserDefaults standardUserDefaults]setObject:_changPassword.text forKey:UserPassword];
                         [self.navigationController popViewControllerAnimated:YES];
                     }else
                     {
                          UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"系统繁忙" message:@"系统繁忙请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                         [arrate show];
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"111请求失败%@",error);
                 }];

            }
            else
            {
                NSLog(@"密码格式");
                UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"密码格式" message:@"密码是6-20个字母和数字组合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [arrate show];

            }
        }
        else
        {
            NSLog(@"两次的密码不一致");
            UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"确认时有错" message:@"两次的密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [arrate show];
        }
        
        
        
    }else
    {
        UIAlertView * arrate =[[UIAlertView alloc]initWithTitle:@"密码错误" message:@"请从新输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [arrate show];
        NSLog(@"登陆密码有误");
    }
    
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
