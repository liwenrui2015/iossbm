//
//  DesignerViewController.m
//  iossbm
//
//  Created by lrw on 15/11/23.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "DesignerViewController.h"
#import "AFNetworking.h"
#import "commonTools.h"
#import "DBImageView.h"
#import "DesignerOneCell.h"
#import "DesignerMode.h"
#import "DesignerInfoTableController.h"
@interface DesignerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,assign)BOOL isShopData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mysegment;
//店铺
@property (nonatomic ,strong)NSMutableArray* shopData;
///个人
@property (nonatomic ,strong)NSMutableArray* individualData;
@end

@implementation DesignerViewController
- (IBAction)changSegmentedOnTouch:(UISegmentedControl *)sender
{
   
    if(sender.selectedSegmentIndex==1)
    {
        [self bubbleSort:NO];
        NSLog(@"销量");
    }else if (sender.selectedSegmentIndex==2)
    {
        [self bubbleSort:YES];
        NSLog(@"距离");
    }else
    {
        NSLog(@"全部");
    }
}
- (IBAction)switchChang:(UISwitch *)sender
{
    [_mysegment setSelectedSegmentIndex:0];
    if ([sender isOn])
    {
        _isShopData=YES;
        [self.tableView reloadData];
        NSLog(@"是店铺");
    }
    else
    {
        _isShopData=NO;
        if(_individualData==nil)
        {
            NSString * path =[NSString stringWithFormat:@"%@getAllEach?",IP];
            NSDictionary * parsms =@{@"sellerType":@1};
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 self.individualData=[commonTools ParserDesigerByDic:dic];
                 [self.tableView reloadData];
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"111请求失败%@",error);
             }];
        }
        else
        {
            [self.tableView reloadData];
        }
        NSLog(@"是技师");
    }
    
}
-(float)getFloatByStr:(NSString*)originalString
{
    
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    int number = [numberString floatValue];
    return number;
    
}
-(void)bubbleSort:(BOOL)isPrice
{
    if(_isShopData)
    {
        for (int i = 0; i < _shopData.count - 1; i++)
        {
            bool flag = true;
            for (int j = 0; j < _shopData.count - i -1; j++)
            {
                
                DesignerMode* tempMode1 = _shopData[j];
                DesignerMode* tempMode2 = _shopData[j+1];
                if(isPrice)//店铺信息价格排序
                {
                    if ([self getFloatByStr:tempMode1.sellerDistance] >[self getFloatByStr:tempMode2.sellerDistance]) {
                        [_shopData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
                else
                {
                    if ([self getFloatByStr:tempMode1.sellerSingleNum] <[self getFloatByStr:tempMode2.sellerSingleNum])
                    {
                        [_shopData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
            }
            if (flag) {
                [self.tableView reloadData];
                return;
            }
        }
    }
    else
    {
        for (int i = 0; i < _individualData.count - 1; i++)
        {
            bool flag = true;
            for (int j = 0; j < _individualData.count - i -1; j++)
            {
                
                DesignerMode* tempMode1 = _individualData[j];
                DesignerMode* tempMode2 = _individualData[j+1];
                if(isPrice)//店铺信息价格排序
                {
                    if ([self getFloatByStr:tempMode1.sellerDistance] >[self getFloatByStr:tempMode2.sellerDistance]) {
                        [_individualData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
                else
                {
                    if ([self getFloatByStr:tempMode1.sellerSingleNum] <[self getFloatByStr:tempMode2.sellerSingleNum])
                    {
                        [_individualData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
            }
            if (flag) {
                [self.tableView reloadData];
                return;
            }
        }
    }
    [self.tableView reloadData];
}
static NSString* CellIdentifer = @"DesignerOneCell";
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title =@"技师";
    _individualData=nil;
    _isShopData=YES;
    //店铺设计师
    self.edgesForExtendedLayout=UIEventSubtypeNone;
    NSString * path =[NSString stringWithFormat:@"%@getAllEach?",IP];
    NSDictionary * parsms =@{@"sellerType":@2};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.shopData=[commonTools ParserDesigerByDic:dic];
      
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];
    
    UINib * nib = [UINib nibWithNibName:@"DesignerOneCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifer];
    
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
    if(_isShopData)
    {
        return [_shopData count];
    }
    else
    {
        return [_individualData count];
    }
}
//cell的高度是
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 119.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DesignerOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    DesignerMode * desingerM=nil;
    if(_isShopData)
    {
        desingerM= _shopData[indexPath.row];
    }
    else
    {
        desingerM= _individualData[indexPath.row];
    }
    cell.userName.text = desingerM.sellerName;
    //评价价格是
    cell.pirce.text = desingerM.sellerAverageRate;
    //距离是
    cell.distance.text = desingerM.sellerDistance;
    //解单数
    cell.amount.text = desingerM.sellerSingleNum;


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,desingerM.sellerImage]]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.cellheadImage.image = image;
            [cell setNeedsLayout];
        });
    });
    
    cell.starImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"heat%d.png",[desingerM.contentType intValue]]];
    
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    DesignerInfoTableController *designerInfoView = [[DesignerInfoTableController alloc] initWithNibName:@"DesignerInfoTableController" bundle:nil];
    DesignerMode * desingerM=nil;
    if(_isShopData)
    {
        desingerM= _shopData[indexPath.row];
    }
    else
    {
        desingerM= _individualData[indexPath.row];
    }
    designerInfoView.designerMode=desingerM;
    // Push the view controller.
    [self.navigationController pushViewController:designerInfoView animated:YES];
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
