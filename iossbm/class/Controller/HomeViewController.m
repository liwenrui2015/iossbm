//
//  HomeViewController.m
//  iossbm
//
//  Created by lrw on 15/11/16.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "HomeViewController.h"
#import "Tools.h"
#import "commonTools.h"
#import "DBImageView.h"
#import "WeiBoShopViewController.h"
#import "EducationTableController.h"

#import "DesignerViewController.h"

#import "MasterpieceViewController.h"


@interface HomeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIView *contenView;
//广告的图片1234
@property (weak, nonatomic) IBOutlet UIImageView *adImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView4;
///关联爱设计
@property (weak, nonatomic) IBOutlet UIImageView *loveDesignView;
///美学教育
@property (weak, nonatomic) IBOutlet UIImageView *educationView;
///美业联盟
@property (weak, nonatomic) IBOutlet UIImageView *coalitionView;
//结束图片（微商城）
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;
@end

@implementation HomeViewController
-(void)contentAppLoveDesign:(id)sender
{
#pragma mark - APP链接APP
    NSURL *url  = [NSURL URLWithString:@"isaknoxLoveDesign://"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        NSLog(@"canOpenURL");
        [[UIApplication sharedApplication] openURL:url];
    } else
    {
        NSLog(@"can not OpenURL");
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id958922782"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}
-(void)goToEducation:(id)sender
{
    EducationTableController * educat = [[EducationTableController alloc]initWithNibName:@"EducationTableController" bundle:nil];
    [self.navigationController pushViewController:educat animated:YES];
}
-(void)WeiBoShopView:(id)sender
{
    WeiBoShopViewController* webBoShop =[[WeiBoShopViewController alloc]initWithNibName:@"WeiBoShopViewController" bundle:nil];
   webBoShop.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webBoShop animated:YES];
}
-(void)goToconalition:(id)sender
{
    NSLog(@"美业联盟");
    
    DesignerViewController * designerView=[[DesignerViewController alloc]initWithNibName:@"DesignerViewController" bundle:nil];
    designerView.title=@"技师";
    designerView.tabBarItem.image=[UIImage imageNamed:@"artificer"];
    
    MasterpieceViewController * masterpieceViewController = [[MasterpieceViewController alloc]initWithNibName:@"MasterpieceViewController" bundle:nil];
    masterpieceViewController.title=@"作品";
    masterpieceViewController.tabBarItem.image=[UIImage imageNamed:@"work.png"];
    
    UITabBarController * tabBarController = [[UITabBarController alloc] init];

    tabBarController.title=@"spamao设计";
    tabBarController.viewControllers = @[designerView,masterpieceViewController];
    tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tabBarController.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:tabBarController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ///关联爱设计
    self.loveDesignView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentAppLoveDesign:)];
    [self.loveDesignView addGestureRecognizer:singleTap0];
    ///关联美学教育
    self.educationView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToEducation:)];
    [self.educationView addGestureRecognizer:singleTap2];
    
    ///关联美业联盟
    self.coalitionView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToconalition:)];
    [self.coalitionView addGestureRecognizer:singleTap1];
    
    ///关联微商城
    self.endImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WeiBoShopView:)];
    [self.endImageView addGestureRecognizer:singleTap3];
    //计算点得个数pageControll
    self.pageControll.numberOfPages =round(self.contenView.frame.size.width/self.scrollView.frame.size.width);
    
    
    
    NSString * path =[NSString stringWithFormat:@"%@getGuideImage",IP];
    NSDictionary * parsms =nil;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSArray* arr = [dic objectForKey:@"guide"];
         for(int i=0;i<arr.count;i++)
         {
             NSDictionary * tempDic = [arr objectAtIndex:i];
           if(i==0)
           {
             DBImageView * imageView = [[DBImageView alloc]initWithFrame:self.adImageView1.frame];
             [imageView setImageWithPath:[NSString stringWithFormat:@"%@%@",IP,[tempDic objectForKey:@"guide_image"]]];
             [self.adImageView1.superview addSubview:imageView];
             self.adImageView1.hidden=YES;
           }
             if(i==1)
             {
                 DBImageView * imageView = [[DBImageView alloc]initWithFrame:self.adImageView2.frame];
                 [imageView setImageWithPath:[NSString stringWithFormat:@"%@%@",IP,[tempDic objectForKey:@"guide_image"]]];
                 [self.adImageView2.superview addSubview:imageView];
                  self.adImageView2.hidden=YES;
             }
             if(i==2)
             {
                 DBImageView * imageView = [[DBImageView alloc]initWithFrame:self.adImageView3.frame];
                 [imageView setImageWithPath:[NSString stringWithFormat:@"%@%@",IP,[tempDic objectForKey:@"guide_image"]]];
                 [self.adImageView3.superview addSubview:imageView];
                  self.adImageView3.hidden=YES;
             }
             if(i==3)

             {
                 DBImageView * imageView = [[DBImageView alloc]initWithFrame:self.adImageView4.frame];
                 [imageView setImageWithPath:[NSString stringWithFormat:@"%@%@",IP,[tempDic objectForKey:@"guide_image"]]];
                 [self.adImageView4.superview addSubview:imageView];
                 self.adImageView4.hidden=YES;
             }
             
             
//             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,[tempDic objectForKey:@"guide_image"]]]];
//                 UIImage *image=nil;
//                 
//                 if(data)
//                     image = [UIImage imageWithData:data];
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     if(image&&i==0)
//                         [self.adImageView1 setImage:image];
//                     if(image&&i==1)
//                         [self.adImageView2 setImage:image];
//                     if(image&&i==2)
//                         [self.adImageView3 setImage:image];
//                     if(image&&i==3)
//                         [self.adImageView4 setImage:image];
//                 });
//             });
         }

       
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
    
   
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changPageAuto:) userInfo:nil repeats:YES];
  

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)changPageAuto:(id)seder
{
    
    self.pageControll.currentPage=(self.pageControll.currentPage+1)%self.pageControll.numberOfPages;
    
    [self.scrollView setContentOffset:(CGPoint){self.pageControll.currentPage* (ScreecSIzeW),0} animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.pageControll.currentPage = round(offset.x / scrollView.frame.size.width);
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
