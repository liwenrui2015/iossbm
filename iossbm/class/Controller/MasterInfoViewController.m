//
//  MasterInfoViewController.m
//  iossbm
//
//  Created by lrw on 15/11/24.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "MasterInfoViewController.h"
#import "commonTools.h"
#import "AFNetworking.h"
#import "PayforViewController.h"
@interface MasterInfoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *InfoImage;
@property (weak, nonatomic) IBOutlet UILabel *InfoPrice;
@property (weak, nonatomic) IBOutlet UILabel *InfoSeller;
@property (weak, nonatomic) IBOutlet UILabel *InfoComponent;
@property (weak, nonatomic) IBOutlet UILabel *InfoEnd;
///时间选择器
@property (weak, nonatomic) IBOutlet UIDatePicker *getTimePicker;
@property (weak, nonatomic) IBOutlet UITextField *adressText;
@end

@implementation MasterInfoViewController
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.view endEditing:YES];
}
///预约
- (IBAction)gotoBespoke:(id)sender
{
    NSDate * nowDate = [NSDate date];
    NSLog(@"时间差是：%f",_getTimePicker.date.timeIntervalSince1970-nowDate.timeIntervalSince1970);
    
    if((_getTimePicker.date.timeIntervalSince1970-nowDate.timeIntervalSince1970)<3600*2)
    {
        NSLog(@"时间太仓促了小二没法准备！");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"时间仓促" message:@"时间太仓促了小二没法准备,时间要大于俩个小时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
        {
            if(self.adressText.text.length<9)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"地址无发识别" message:@"地址不够详细" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                PayforViewController * payforContor = [[PayforViewController alloc]initWithNibName:@"PayforViewController" bundle:nil];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
                payforContor.theTiem=[formatter stringFromDate:self.getTimePicker.date];
                payforContor.theAdress = self.adressText.text;
                payforContor.payInfoMode=self.masterInfoMode;
                payforContor.isCanPay=YES;
                NSString * path =[NSString stringWithFormat:@"%@insertOrder?",IP];
                NSDictionary * parsms =@{@"orderAddress":self.adressText.text,@"serviceDate":[formatter stringFromDate:self.getTimePicker.date],@"workId":self.masterInfoMode.workId,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName]};
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     
                     if([[dic objectForKey:@"result"] isEqualToString:@"success"])
                     {
                         payforContor.passOrderId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                        
                         [self.navigationController pushViewController:payforContor animated:YES];
                     }
                     else
                     {
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"订单失败" message:@"订单提交失败返回上一级" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                         [alert show];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"111请求失败%@",error);
                 }];
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"未登录" message:@"您还没有登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (IBAction)datePickerChange:(UIDatePicker *)sender
{
    NSDate * nowDate = [NSDate date];
    if([[nowDate laterDate:sender.date]isEqual:nowDate])
    {
        NSLog(@"早于当前时间改变时间");
        [sender setDate:nowDate];
    }
}
-(void)collectWork:(id)sedner
{
    
    NSString * path =[NSString stringWithFormat:@"%@insertCoupons?",IP];
    NSDictionary * parsms =@{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName],@"couponType":@1,@"couponThing":self.masterInfoMode.workId};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"收藏%@",dic);
         if([[dic objectForKey:@"result"] isEqualToString:@"success"])
         {
             [commonTools showMessage:@"收藏成功"];
         }
         else if([[dic objectForKey:@"result"] isEqualToString:@"alreay"])
         {
             [commonTools showMessage:@"已经收藏"];
         }
         else
         {
             [commonTools showMessage:@"收藏失败"];

         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];

    
    NSLog(@"作品收藏");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约信息";
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collectWork:)];
    NSString * path =[NSString stringWithFormat:@"%@getWorkProfile?",IP];
    NSDictionary * parsms =@{@"workId":_masterInfoMode.workId};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.InfoEnd.text=[[dic objectForKey:@"result"]objectForKey:@"work_profile"];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,self.masterInfoMode.workImage]]];
        UIImage * imge = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.InfoImage.image=imge;
        });
    });
    
    self.InfoPrice.text=self.masterInfoMode.workRate;
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
