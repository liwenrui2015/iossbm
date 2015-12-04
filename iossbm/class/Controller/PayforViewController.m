//
//  PayforViewController.m
//  iossbm
//
//  Created by apple on 15/11/25.
//  Copyright (c) 2015年 liwenrui. All rights reserved.

//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "Product.h"


#import "PayforViewController.h"
#import "commonTools.h"
#import "sellerMode.h"
@interface PayforViewController ()
@property (strong, nonatomic) IBOutlet UILabel *sellerName;
@property (strong, nonatomic) IBOutlet UILabel *sellSingNum;


@property (strong, nonatomic) IBOutlet UILabel *orderTitle;
@property (strong, nonatomic) IBOutlet UIImageView *TopImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderCount;

@property (strong, nonatomic) IBOutlet UILabel *oldPrice;
@property (strong, nonatomic) IBOutlet UIButton *callmeButton;

@property (strong, nonatomic) IBOutlet UILabel *theTime;
@property (strong, nonatomic) IBOutlet UILabel *adressLable;
@property (strong, nonatomic) IBOutlet UILabel *PayPrice;

@property (strong, nonatomic) IBOutlet UIButton *buttonPay;

@end

@implementation PayforViewController
- (IBAction)callMe:(UIButton *)sender {
    if([commonTools validateMobile:sender.titleLabel.text])
    {
        NSString * strUrl=[NSString stringWithFormat:@"%@%@",@"tel://",sender.titleLabel.text];
        NSLog(@"卖家的电话是%@",strUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"号码有误" message:@"号码没有请求到稍后！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)cancalBut:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

#pragma mark   ==============产生随机订单号==============
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (IBAction)submitOK:(id)sender
{
    NSLog(@"提交%@",_passOrderId);
  
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088001253325081";
    NSString *seller = @"yanghuitianxia@alibaba.com.cn";
    NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBAL4e60V5Yx3UNTNf9kIqC6dlChQx/ocB9M4Ll7ZuArgNbiFPCGWBgMaIIdImmq/Vg/Kc1Y8kQHaAjvctOQgPJeHKLa4+iZWKgqkNOTkDX6kjXTVvi92P03niidi03wVqXd9sXGk5Rq4W8vmne7mXjnMBkzYVN+dIRYv4F6SgFE9fAgMBAAECgYEArhTRiEOlpeJw9CGh8uNc2GGD4QoF7Mi1xxSGTdxdUPm7JXSgU5FIwIBVt37xlJ8Eulkwkmi3PcppHZqi5eY43/d+fRnBZeetRUUr/fQat8hB2lsO6VXdxHF2cyU7S+YEvVZ+gBXbUpn3Z2Mk57rnOCTfhgwfUUg+nh7Djp9kcAECQQD0lGxFhnoR4MtRjVz4cu2x/9RGhnVHKh9TM35bikuYxwFMJUnkGirwHvqOTaK6a7uDq9XuHKDtaGxAcUc4mT0BAkEAxv+FpidjPU2MBLOX69Se5gKNO9IX0mi89NuspuDR1vqcnnD6C6VcQaUQSdRRf3TiyKWzCTiRgiV74FL/2DqsXwJBANpipQK3fsvz4tfg18DoLiGgA1Utvg5bKDlMY2ktZS73kssBCKdqTii2IJdr7v9yLq71gkHowjD56p7oBuYcvgECQQCakbVlFukNn+Nnb3xMsQ1viYHcelcIl1RWOR+FS9GSU3090HFYhGwBjU32mtVm1AqnYZWMTwUu+yCaYL3bXc+vAkEAxBgmEgetXdbWjR+Cn0/j1vBz7UiThmdwm9eYJ/c5g1+QH3/m9IRn0Q0ILCUl430N+lEJRnEtHxu6ko73HLghrg==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = self.payInfoMode.workName; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[self.payInfoMode.workRate floatValue]]; //商品价格
#warning 回调地址
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkiossbm";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"])
             {
                 NSLog(@"支付成功");
                 NSLog(@"%@",_passOrderId);
                 NSString * path =[NSString stringWithFormat:@"%@updateOrder?",IP];
                 NSDictionary * parsms =@{@"orderId":_passOrderId};
                 AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                 [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                 [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
                  {
                      NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                      
                      if([[dic objectForKey:@"result"] isEqualToString:@"success"])
                      {
                          UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"主人我回到,设计页看看其它商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                          [alert show];

                      [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                      }
                  }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error){
                      NSLog(@"111请求失败%@",error);
                  }];
             }
             else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"6001"])
             {
                 NSLog(@"用户中途取消");
             }
             else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"6002"])
             {
                 NSLog(@"网络连接出错");
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"原因：网络出错！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
             else
             {
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"原因：其它" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
             
             
        }];
  
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单支付";
    self.theTime.text = self.theTiem;
    self.adressLable.text = self.theAdress;
    self.buttonPay.enabled=self.isCanPay;
    self.orderCount.text=self.payInfoMode.workPayNum;
    self.orderTitle.text =self.payInfoMode.workName;
    self.oldPrice.text=self.payInfoMode.workRate;
#warning  如果有折扣在这处理
    self.PayPrice.text=self.payInfoMode.workRate;
    NSString * path =[NSString stringWithFormat:@"%@getSellerOnOrder?",IP];
    NSDictionary * parsms =@{@"sellerId":self.payInfoMode.sellerId};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         
         
         sellerMode* sellmode = [commonTools ParserPayForByDic:dic];
         
         
         if([self.payInfoMode.workSort isEqualToString:@"2"])//2表示店铺
         {
             self.sellerName.text=[NSString stringWithFormat:@"%@%@",@"店铺名：",sellmode.sellerName ];
         }
         else
         {
             self.sellerName.text=[NSString stringWithFormat:@"%@%@",@"技师名：",sellmode.sellerName ];
         }
         self.sellSingNum.text=sellmode.sellerSingleNum;
         
         [self.callmeButton setTitle:sellmode.sellerPhone forState:UIControlStateNormal];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,self.payInfoMode.workImage]]];
        UIImage * imge = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TopImageView.image=imge;
        });
    });
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
