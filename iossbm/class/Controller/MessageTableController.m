//
//  MessageTableController.m
//  iossbm
//
//  Created by lrw on 15/11/30.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import "MessageTableController.h"
#import "AFNetworking.h"
#import "commonTools.h"
#import "MessageMode.h"
@interface MessageTableController ()
@property(nonatomic,strong)NSMutableArray * messageDatas;
@end

@implementation MessageTableController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight=44;
    NSString * path =[NSString stringWithFormat:@"%@selectAllNews?",IP];
    NSDictionary * parsms = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName]};
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.messageDatas = [commonTools ParserMessageByDic:dic];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(tableViewEdit:)];
    
    //    self.navigationController.navigationItem.rightBarButtonItem=
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableViewEdit:(id)seder
{
    if(self.tableView.editing==YES)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        
        [self.tableView setEditing:NO animated:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消编辑"];
        [self.tableView setEditing:YES animated:YES];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.messageDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    //判断
    if(nil == cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    MessageMode * tempMesMod = self.messageDatas[indexPath.row];
    cell.textLabel.textColor=[UIColor orangeColor];
    cell.textLabel.text= tempMesMod.myNewsTitle;
    cell.detailTextLabel.text=tempMesMod.myNewsComent;
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return UITableViewCellEditingStyleDelete;
    
    //    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        MessageMode* messagemode = self.messageDatas[indexPath.row];
        
       
        NSString * path =[NSString stringWithFormat:@"%@deleteMessage?",IP];
        
        NSArray * parestr =@[@0,messagemode.myNewsID];
      NSDictionary * parsms = @{@"messageIds":parestr};
        
        AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if([[dic objectForKey:@"result"]isEqualToString:@"success"])
            {
                NSLog(@"成功");
                [self.messageDatas removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                NSLog(@"系统繁忙");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@请求失败%@",operation,error);
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}



// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
