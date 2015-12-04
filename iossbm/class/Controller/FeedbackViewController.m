//
//  FeedbackViewController.m
//  iossbm
//
//  Created by lrw on 15/11/13.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "FeedbackViewController.h"
#import "commonTools.h"
#import "AFNetworking.h"
@interface FeedbackViewController ()<UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedBack;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *UserQQ;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation FeedbackViewController
- (IBAction)submitOK:(id)sender
{
  
    if(![_feedBack.text isEqualToString:@""])
    {
        
        if([_phoneNumber.text isEqualToString:@""]||[commonTools validateMobile:_phoneNumber.text])
        {
            NSLog(@"电话正确");
        }
        else
        {
            NSLog(@"电话有错%@",_phoneNumber.text);
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"电话有错" message:@"不填，或修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];

            return;
        }
        
        
        if([_UserQQ.text isEqualToString:@""]||[commonTools validateQQ:_UserQQ.text])
        {
             NSLog(@"QQ正确");
       
            
        }
        else
        {
            NSLog(@"QQ有错");
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"QQ有错" message:@"不填，或修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        if([_email.text isEqualToString:@""]||[commonTools validateEmail:_email.text])
        {
             NSLog(@"邮箱正确");
          
            
        }else
        {
            NSLog(@"邮箱有错");
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"邮箱有错" message:@"不填，或修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }else
    {
        NSLog(@"建议是空");
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"建议是空" message:@"空建议范围太广了，亲来的实在的！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSLog(@"通过");
    NSString * path =[NSString stringWithFormat:@"%@insertIdea?",IP];
    NSDictionary * parsms =@{@"coment":_feedBack.text,@"values1":_phoneNumber.text,@"values2":_UserQQ.text,@"values3":_email.text,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName]};
    

    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
         if([[dic objectForKey:@"result"] isEqualToString:@"success"])
         {
             NSLog(@"=====提交成功");
         }
         else
         {
              NSLog(@"=====提交失败");
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
    
    

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //键盘事件
    
    self.title=@"意见反馈";
    _phoneNumber.text=[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName];
    // Do any additional setup after loading the view from its nib.
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 253.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
