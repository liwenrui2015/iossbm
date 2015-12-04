//
//  myOrderViewController.m
//  iossbm
//
//  Created by lrw on 15/11/30.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import "myOrderViewController.h"
#import "AFNetworking.h"
#import "commonTools.h"
#import "AllOrderMode.h"
#import "OrderTableViewCell.h"
#import "PayforViewController.h"
@interface myOrderViewController ()

@property(nonatomic,retain)NSMutableArray * paiedOrder;
@property(nonatomic,retain)NSMutableArray * willPayOrder;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentStade;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@end

@implementation myOrderViewController
- (IBAction)segmentValueChang:(UISegmentedControl *)sender
{
    [self.myTable reloadData];
}
static NSString * CellIdentif=@"OrderCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的订单";
    self.myTable.estimatedRowHeight=44;
    UINib * nib = [UINib nibWithNibName:@"OrderTableViewCell" bundle:nil];
    [self.myTable registerNib:nib forCellReuseIdentifier:CellIdentif];
    
    self.paiedOrder=[[NSMutableArray alloc]init];
    self.willPayOrder=[[NSMutableArray alloc]init];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.paiedOrder removeAllObjects];
     [self.willPayOrder removeAllObjects];
    NSString * path =[NSString stringWithFormat:@"%@selectAllOrders?",IP];
    NSDictionary * parsms =@{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName]};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * tempArr= [commonTools ParserOrderByDic:dic];
        
        for (AllOrderMode*temp in tempArr)
        {
            
            if([temp.orderState isEqualToString:@"0"])
            {
                [self.willPayOrder addObject:temp];
            }
            else
            {
                [self.paiedOrder addObject:temp];
            }
            
        }
        [self.myTable reloadData];
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
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if(_segmentStade.selectedSegmentIndex==0)
    {
        return self.paiedOrder.count;
    }
    else
    {
        return self.willPayOrder.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentif forIndexPath:indexPath];
    AllOrderMode* allOrder = nil;
    if(_segmentStade.selectedSegmentIndex==0)
    {
        allOrder=self.paiedOrder[indexPath.row];
    }
    else
    {
        allOrder=self.willPayOrder[indexPath.row];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,allOrder.workImage]]];
        UIImage *image=nil;
        if(data)
            image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image)
                cell.titleImage.image=image;
        });
    });
    
    cell.orderTitel.text=allOrder.workName;
    cell.orderPrice.text=allOrder.workRate;
    cell.orderInfo.text=allOrder.workProfile;
    cell.orderTime.text=allOrder.orderDate;
    
    
    
    return cell;
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
    PayforViewController *detailViewController = [[PayforViewController alloc] initWithNibName:@"PayforViewController" bundle:nil];
    

    AllOrderMode* allOrder = nil;
    if(_segmentStade.selectedSegmentIndex==0)
    {
        allOrder=self.paiedOrder[indexPath.row];
        detailViewController.isCanPay=NO;
    }
    else
    {
        allOrder=self.willPayOrder[indexPath.row];
        detailViewController.isCanPay=YES;
    }
    
    
    
    MasterModel* mode =[[MasterModel alloc]init];
    mode.workId=allOrder.workId;
    mode.workName=allOrder.workName;
    mode.workRate=allOrder.workRate;
    mode.sellerId=allOrder.sellerId;
    mode.workImage=allOrder.workImage;
    mode.workSort=allOrder.worksort;
    detailViewController.payInfoMode=mode;
    
    detailViewController.theTiem=allOrder.serviceDate;
    detailViewController.theAdress=allOrder.orderAddress;
    detailViewController.passOrderId=allOrder.orderId;
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
