//
//  CollectionViewController.m
//  iossbm
//
//  Created by lrw on 15/12/1.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import "CollectionViewController.h"
#import "AFNetworking.h"
#import "CollectMode.h"
#import "commonTools.h"
#import "DesignerOneCell.h"
#import "OrderTableViewCell.h"
#import "DesignerInfoTableController.h"
#import "MasterInfoViewController.h"
@interface CollectionViewController ()
@property(nonatomic,retain)NSMutableArray * collectWorks;
@property(nonatomic,retain)NSMutableArray * collectShops;
@property (weak, nonatomic) IBOutlet UISegmentedControl *collectSegment;
@property (weak, nonatomic) IBOutlet UITableView *collectTableView;

@end
static NSString * CollectIdentifwork=@"CollectCellwork";
static NSString * CollectIdentifDesigner=@"CollectCellDesig";
@implementation CollectionViewController
- (IBAction)collcetSegmentChang:(UISegmentedControl *)sender
{
    [self.collectTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的收藏";
    self.collectTableView.estimatedRowHeight=44;
    UINib * nib = [UINib nibWithNibName:@"DesignerOneCell" bundle:nil];
    [self.collectTableView registerNib:nib forCellReuseIdentifier:CollectIdentifDesigner];
    
    UINib * nib2 = [UINib nibWithNibName:@"OrderTableViewCell" bundle:nil];
    [self.collectTableView registerNib:nib2 forCellReuseIdentifier:CollectIdentifwork];
    
    self.collectWorks=[[NSMutableArray alloc]init];
    self.collectShops=[[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(tableViewEdit:)];
    
    NSString * path =[NSString stringWithFormat:@"%@selectCoupons?",IP];
    NSDictionary * parsms =@{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName]};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * tempArr= [commonTools ParserCollectByDic:dic];
        
        for (CollectMode*temp in tempArr)
        {
            if([temp.couponType isEqualToString:@"1"])//1是作品（现在只有2种情况）
            {
                [self.collectWorks addObject:temp];
            }
            else
            {
                [self.collectShops addObject:temp];
            }
            
        }
        [self.collectTableView reloadData];
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
    if(_collectSegment.selectedSegmentIndex==0)
    {
        return self.collectWorks.count;
    }
    else
    {
        return self.collectShops.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_collectSegment.selectedSegmentIndex==0)
    {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectIdentifwork forIndexPath:indexPath];
        CollectMode* collectMode=self.collectWorks[indexPath.row];
        MasterModel* mastermodel = collectMode.collentMasterModel;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,mastermodel.workImage]]];
            UIImage *image=nil;
            if(data)
                image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image)
                    cell.titleImage.image=image;
            });
        });
        
        cell.orderTitel.text = mastermodel.workName;
        cell.orderPrice.text = mastermodel.workRate;
        cell.orderInfo.text = mastermodel.workProfile;
        cell.orderTime.text = mastermodel.workPayNum;
        return cell;
    }
    else
    {
        CollectMode* collectMode=self.collectShops[indexPath.row];
        
        DesignerOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectIdentifDesigner forIndexPath:indexPath];
        
        DesignerMode* colDesignerMode = collectMode.collentDesignerMode;
        
        
        cell.userName.text = colDesignerMode.sellerName;
        //评价价格是
        cell.pirce.text = colDesignerMode.sellerAverageRate;
        //距离是
        cell.distance.text = colDesignerMode.sellerDistance;
        //解单数
        cell.amount.text = colDesignerMode.sellerSingleNum;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,colDesignerMode.sellerImage]]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.cellheadImage.image = image;
                [cell setNeedsLayout];
            });
        });
        
        cell.starImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"heat%d.png",[colDesignerMode.contentType intValue]]];
        
        
        return cell;
        
    }
    
    
}
-(void)tableViewEdit:(id)seder
{
    if(self.collectTableView.editing==YES)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        
        [self.collectTableView setEditing:NO animated:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消编辑"];
        [self.collectTableView setEditing:YES animated:YES];
    }
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        CollectMode * tempcollect=nil;
        NSArray * parestr=nil;
        if(_collectSegment.selectedSegmentIndex==0)
        {
            tempcollect=[self.collectWorks objectAtIndex:indexPath.row];
            parestr =@[@0,tempcollect.collentMasterModel.workId];
        }
        else
        {
            tempcollect=[self.collectShops objectAtIndex:indexPath.row];
             parestr =@[@0,tempcollect.collentDesignerMode.sellerId];
        }
        
        NSString * path =[NSString stringWithFormat:@"%@deleteCoupons?",IP];
        
        
        NSDictionary * parsms = @{@"ids":parestr,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName],@"couponType":tempcollect.couponType};
        
        AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if([[dic objectForKey:@"result"]isEqualToString:@"success"])
            {
                NSLog(@"成功");
                
                if(_collectSegment.selectedSegmentIndex==0)
                {
                    [self.collectWorks removeObjectAtIndex:indexPath.row];
                }
                else
                {
                    [self.collectShops removeObjectAtIndex:indexPath.row];
                }
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                NSLog(@"系统繁忙");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@请求失败%@",operation,error);
        }];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    if(_collectSegment.selectedSegmentIndex==0)
    {
        MasterInfoViewController * mastercontorller = [[MasterInfoViewController alloc]initWithNibName:@"MasterInfoViewController" bundle:nil];
        mastercontorller.masterInfoMode=((CollectMode*)self.collectWorks[indexPath.row]).collentMasterModel;
        [self.navigationController pushViewController:mastercontorller animated:YES];
    }
    else
    {
        DesignerInfoTableController *designerInfoView = [[DesignerInfoTableController alloc] initWithNibName:@"DesignerInfoTableController" bundle:nil];
       
        designerInfoView.designerMode=((CollectMode*)self.collectShops[indexPath.row]).collentDesignerMode;
        // Push the view controller.
        [self.navigationController pushViewController:designerInfoView animated:YES];
    }

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
