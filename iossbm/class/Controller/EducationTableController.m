//
//  EducationTableController.m
//  iossbm
//
//  Created by lrw on 15/11/17.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "EducationTableController.h"
#import "EducationModel.h"
#import "DetailedMode.h"
#import "AFNetworking.h"
#import "EducationCell.h"
#import "DetailedTableController.h"
#import "commonTools.h"
@interface EducationTableController ()
@property(nonatomic,strong)NSMutableArray * tableData;
@end
static NSString*CellIdentifer =@"EducationCell";
@implementation EducationTableController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // 设置为一个接近“平均”行高的值
    self.title=@"美学教育";
    UINib * nib = [UINib nibWithNibName:@"EducationCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifer];
    
    
    NSString * path =[NSString stringWithFormat:@"%@selectAllSpace",IP];
    NSDictionary * parsms =nil;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         
         
         self.tableData = [commonTools ParserEducationEByDic:dic];
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.tableData count];
}

//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0;
//}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.tableView reloadData];
    NSLog(@"转屏了");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EducationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    EducationModel * EducMode = self.tableData[indexPath.row];
    if(EducMode.spaceType==1)
    {
        cell.ModeType.text=@"帖子|";
    }else
    {
        cell.ModeType.text=@"视频|";
    }
    cell.CellTitle.text=EducMode.spaceTile;
    cell.countNumber.text=EducMode.contentCount;
    cell.commentTime.text=EducMode.spaceTime;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"要请求的数据是：%@",[NSString stringWithFormat:@"%@%@",IP,EducMode.rspaceComent]);
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,EducMode.rspaceComent]] options:NSDataReadingMappedIfSafe error:nil];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            EducMode.nextStepData = [commonTools ParserEducationEByArrs:array];
            
           
                
                for (NSString * comp in EducMode.nextStepData)
                {
                 
                    if ([comp rangeOfString:@".mp4"].location == NSNotFound&&[comp rangeOfString:@".png"].location == NSNotFound) {
                      cell.CellInfo.text=comp;
                        break;
                    }
                }
                
            [cell setNeedsLayout];
        });
    });
    
    
    //异步加载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,EducMode.spaceImage]]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.infoImage.image = image;
            [cell setNeedsLayout];
        });
    });
    // Configure the cell...
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.tableView reloadData];
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
    DetailedTableController *detailViewController = [[DetailedTableController alloc] initWithNibName:@"DetailedTableController" bundle:nil];
    EducationModel * passData = self.tableData[indexPath.row];
    detailViewController.arrayData=[NSMutableArray arrayWithArray:passData.nextStepData];
    detailViewController.selfMode=[[DetailedMode alloc]init];
    detailViewController.selfMode.CellType = passData.spaceType;
    detailViewController.selfMode.spaceId=passData.spaceId;
    detailViewController.selfMode.headTitle=passData.spaceTile;
    detailViewController.selfMode.headTime=passData.spaceTime;
    detailViewController.selfMode.headName =passData.pulisher;
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
