//
//  UserInfoTableViewController.m
//  iossbm
//
//  Created by lrw on 15/11/7.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "CustomTableViewCell.h"
#import "LoginViewController.h"
#import "changPassViewController.h"
#import "CouponTableViewController.h"
#import "myOrderViewController.h"
#import "MessageTableController.h"
#import "CollectionViewController.h"
#import "commonTools.h"
#import <ShareSDK/ShareSDK.h>
#import "Tools.h"
@interface UserInfoTableViewController ()<UIAlertViewDelegate>
{
    NSInteger passErrorCode;
}
@end
static NSString*CellIdentifer =@"custaomCell";
@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib * nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifer];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(section==0)
    {
        return 1;
    }
    else
    {
        return 6;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0&&indexPath.section==0)
    {
        return 160.0*SCALETO;
    }else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==1&&indexPath.row==0)
    {
        return self.shearCell;
    }else if(indexPath.section==1&&indexPath.row==1)
    {
        return self.couponCell;
    }
    else if(indexPath.section==1&&indexPath.row==2)
    {
        return self.orderFromCell;
    }
    
    else if(indexPath.section==1&&indexPath.row==3)
    {
        return self.myMsgCell;
    }
    
    else if(indexPath.section==1&&indexPath.row==4)
    {
        return self.enshrineCell;
    }
    
    else if(indexPath.section==1&&indexPath.row==5)
    {
        return self.passWordCell;
    }
    else
    {
        CustomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
        {
            cell.UserName.text=[[NSUserDefaults standardUserDefaults]stringForKey:UserLoginName];
            cell.changImage.image=[UIImage imageNamed:@"login_alreay.png"];
        }
        else
        {
            cell.UserName.text=@"请登录";
        }
        return cell;
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    
    if(indexPath.section==0&&indexPath.row==0)//登陆
    {
        if(![[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
        {
            LoginViewController *detailViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }else if(indexPath.section==1&&indexPath.row==0)//分享
    {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                           defaultContent:@"测试一下"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:@"ShareSDK"
                                                      url:@"http://www.mob.com"
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            NSLog(@"这是Ipad");
            [container setIPadContainerWithView:self.shearCell arrowDirect:UIPopoverArrowDirectionUp];
        }
        else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NSLog(@"这是Iphone");
            [container setIPhoneContainerWithViewController:self];;
        }
        else
        {
            
        }
        
        NSArray *shareList = [ShareSDK customShareListWithType:
                              SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                              SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                              SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                              SHARE_TYPE_NUMBER(ShareTypeQQ),
                              SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                              nil];
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSResponseStateSuccess)
            {
                NSLog(@"分享成功");
            }
            else if (state == SSResponseStateFail)
            {
                if([error errorCode]==-24002||[error errorCode]==-22003)
                {
                    passErrorCode=[error errorCode];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[error errorDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往AppStore", nil];
                    [alertView show];
                }else
                {
                    passErrorCode=[error errorCode];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[error errorDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alertView show];
                }
                NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
            }
        }];
    }
    else if(indexPath.section==1&&indexPath.row==1)//优惠劵
    {
        CouponTableViewController* couponTable = [[CouponTableViewController alloc]initWithNibName:@"CouponTableViewController" bundle:nil];
        [self.navigationController pushViewController:couponTable animated:YES];
    }
    else if(indexPath.section==1&&indexPath.row==2)//订单
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
        {
        myOrderViewController * myOrderTable = [[myOrderViewController alloc]initWithNibName:@"myOrderViewController" bundle:nil];
        myOrderTable.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myOrderTable animated:YES];
        }
        else
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"未登录" message:@"登陆可见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
     else if(indexPath.section==1&&indexPath.row==3)//我的消息
     {
         if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
         {
         MessageTableController * messageControll = [[MessageTableController alloc]initWithNibName:@"MessageTableController" bundle:nil];
         [self.navigationController pushViewController:messageControll animated:YES];
         }
         else
         {
             UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"未登录" message:@"登陆可见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
         }
     }
     else if(indexPath.section==1&&indexPath.row==4)//我的收藏
     {
         if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
         {
             CollectionViewController * colletControll = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
             [self.navigationController pushViewController:colletControll animated:YES];
         }
         else
         {
             UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"未登录" message:@"登陆可见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
         }
     }
    else if(indexPath.section==1&&indexPath.row==5)//修改密码
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
        {
            changPassViewController* changeView = [[changPassViewController alloc]initWithNibName:@"changPassViewController" bundle:nil];
            [self.navigationController pushViewController:changeView animated:YES];
        }
        else
        {
            LoginViewController * lginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:lginView animated:YES];
        }
        
    }
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        if(passErrorCode==-24002)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id453718989"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }
            else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id444934666"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }else if(passErrorCode==-22003)
        {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id414478124"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
