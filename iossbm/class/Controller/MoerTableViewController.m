//
//  MoerTableViewController.m
//  iossbm
//
//  Created by lrw on 15/11/7.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "MoerTableViewController.h"
#import "LoginViewController.h"
#import "LeagueFlowViewController.h"
#import "AboutMeViewController.h"
#import "GameViewController.h"
#import "FeedbackViewController.h"
#import "commonTools.h"
@interface MoerTableViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headerView;
@property (strong, nonatomic) IBOutlet UITableViewCell *otherCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contactUs;
@property (strong, nonatomic) IBOutlet UITableViewCell *aboutME;
@property (strong, nonatomic) IBOutlet UITableViewCell *feedback;
@property (strong, nonatomic) IBOutlet UITableViewCell *quitLogin;
@property (strong, nonatomic) IBOutlet UITableViewCell *theGame;
@property (strong, nonatomic) IBOutlet UITableViewCell *lineBlow;

@end

@implementation MoerTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"更多...";
      self.tableView.tableHeaderView = self.headerView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
    {
        return 3;
    }
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0)
    {
        return 5;
    }
    else
    {
        return 1;
    }
    
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//{
//    if(section==1)
//    {
//        return @"点击立即拨打";
//    }
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        return  self.otherCell;
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        return  self.feedback;
    }
    else if(indexPath.section==0&&indexPath.row==2)
    {
        return  self.aboutME;
    }
    else if(indexPath.section==0&&indexPath.row==3)
    {
        return  self.lineBlow;
    }
    else if(indexPath.section==0&&indexPath.row==4)
    {
        return  self.theGame;
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        return  self.contactUs;
    }
    else
    {
        return self.quitLogin;
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

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return 0.0f;
//    return 0.0f;
//}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        LeagueFlowViewController* league = [[LeagueFlowViewController alloc]initWithNibName:@"LeagueFlowViewController" bundle:nil];
        [self.navigationController pushViewController:league animated:YES];
        NSLog(@"加盟");
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        NSLog(@"意见反馈");
        if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
        {
            FeedbackViewController* FeedView = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
            [self.navigationController pushViewController:FeedView animated:YES];
        }
        else
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请登录" message:@"登陆后可见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
    else if(indexPath.section==0&&indexPath.row==2)
    {
        NSLog(@"关于我们");
        AboutMeViewController * aboutView = [[AboutMeViewController alloc]initWithNibName:@"AboutMeViewController" bundle:nil];
        [self.navigationController pushViewController:aboutView animated:YES];
    }
    else if(indexPath.section==0&&indexPath.row==3)
    {
        NSLog(@"线下体验店");
    }
    else if(indexPath.section==0&&indexPath.row==4)
    {
        
        GameViewController * gameContr = [[GameViewController alloc]initWithNibName:@"GameViewController" bundle:nil];
        [self.navigationController pushViewController:gameContr animated:YES];
        NSLog(@"游戏中心");
       
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        NSLog(@"联系客服");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://13924087548"]];
    }
    else if(indexPath.section==2&&indexPath.row==0)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:IsLogin];
        [(UITabBarController*)self.parentViewController.parentViewController setSelectedIndex:2];
        NSLog(@"退出登录");
    }
    else
    {
        
    }
    
    
    // Push the view controller.
    //    [self.navigationController pushViewController:detailViewController animated:YES];
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
