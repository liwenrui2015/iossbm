//
//  MasterpieceViewController.m
//  iossbm
//
//  Created by lrw on 15/11/24.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "MasterpieceViewController.h"
#import "MasterCollecCell.h"
#import "AFNetworking.h"
#import "DBImageView.h"
#import "MasterModel.h"
#import "commonTools.h"
#import "MasterInfoViewController.h"
@interface MasterpieceViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,assign)BOOL isShopData;
@property(nonatomic,strong)NSMutableArray* workShopData;
@property(nonatomic,strong)NSMutableArray* workIndividuaData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mysegment;
@end

@implementation MasterpieceViewController
- (IBAction)changSegment:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==1)
    {
        [self workDataBubbleSort:NO];
        NSLog(@"销量");
    }else if (sender.selectedSegmentIndex==2)
    {
        [self workDataBubbleSort:YES];
        NSLog(@"价格");
    }else
    {
        NSLog(@"全部");
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



- (IBAction)changSwitch:(UISwitch *)sender {
    [_mysegment setSelectedSegmentIndex:0];
    if ([sender isOn])
    {
        _isShopData=YES;
         [self.collectionView reloadData];
        NSLog(@"是到店");
    }
    else
    {
        _isShopData=NO;
        if(_workIndividuaData==nil)
        {
            NSString * path =[NSString stringWithFormat:@"%@getAllWorks?",IP];
            NSDictionary * parsms =@{@"workSort":@1};
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                 _workIndividuaData=[commonTools ParserMasterByArrs:array];
                 [self.collectionView reloadData];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"111请求失败%@",error);
             }];
        }
        else
        {
            [self.collectionView reloadData];
        }
        
        NSLog(@"是上门");
    }
}

-(void)workDataBubbleSort:(BOOL)isPrice
{
    if(_isShopData)
    {
        for (int i = 0; i < _workShopData.count - 1; i++)
        {
            bool flag = true;
            for (int j = 0; j < _workShopData.count - i -1; j++)
            {
                
                MasterModel* tempMode1 = _workShopData[j];
                MasterModel* tempMode2 = _workShopData[j+1];
                if(isPrice)//店铺信息价格排序
                {
                    if ([self getFloatByStr:tempMode1.workRate] >[self getFloatByStr:tempMode2.workRate]) {
                        [_workShopData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
                else
                {
                    if ([self getFloatByStr:tempMode1.workPayNum] <[self getFloatByStr:tempMode2.workPayNum])
                    {
                        [_workShopData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
            }
            if (flag) {
                [self.collectionView reloadData];
                return;
            }
        }
    }
    else
    {
        for (int i = 0; i < _workIndividuaData.count - 1; i++)
        {
            bool flag = true;
            for (int j = 0; j < _workIndividuaData.count - i -1; j++)
            {
                
                MasterModel* tempMode1 = _workIndividuaData[j];
                MasterModel* tempMode2 = _workIndividuaData[j+1];
                if(isPrice)//店铺信息价格排序
                {
                    if ([self getFloatByStr:tempMode1.workRate] >[self getFloatByStr:tempMode2.workRate]) {
                        [_workIndividuaData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
                else
                {
                    if ([self getFloatByStr:tempMode1.workPayNum] <[self getFloatByStr:tempMode2.workPayNum])
                    {
                        [_workIndividuaData exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        flag = false;
                    }
                }
            }
            if (flag) {
                [self.collectionView reloadData];
                return;
            }
        }
    }
    [self.collectionView reloadData];
}

static NSString * const reuseIdentifier = @"MasterCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"作品";
    _isShopData=YES;
    _workIndividuaData=nil;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MasterCollecCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //店铺设计师
    NSString * path =[NSString stringWithFormat:@"%@getAllWorks?",IP];
    NSDictionary * parsms =@{@"workSort":@2};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         _workShopData=[commonTools ParserMasterByArrs:array];
         [self.collectionView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];

    // Do any additional setup after loading the view.
    
}

-(void)Selectbutton:(id)seder
{
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;//左右
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;//上下
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((self.view.bounds.size.width-12)*0.5, (self.view.bounds.size.width-12)*0.5+52);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(UIView*)rotatingHeaderView
//{
//
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    
    if(_isShopData)
    {
        return [_workShopData count];
    }
    else
    {
        return [_workIndividuaData count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MasterCollecCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    MasterModel * tempMode = nil;

    
    if(_isShopData)
    {
        tempMode=_workShopData[indexPath.row];
    }else
    {
        tempMode=_workIndividuaData[indexPath.row];
    }
    
    
//    DBImageView * imageView = [[DBImageView alloc]initWithFrame:cell.infoImage.frame];
//    
//    [imageView setImageWithPath:[NSString stringWithFormat:@"%@%@",IP,tempMode.workImage]];
//    [cell.infoImage.superview addSubview:imageView];
//    cell.infoImage.hidden=YES;
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,tempMode.workImage]]];
        UIImage * imge = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.infoImage.image=imge;
        });
    });
    cell.title.text=tempMode.workName;
    cell.price.text = tempMode.workRate;
    cell.sellNum.text=tempMode.workPayNum;
    return cell;
}
-(void)viewDidAppear:(BOOL)animated
{
   }
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MasterInfoViewController * masterInfor = [[MasterInfoViewController alloc]initWithNibName:@"MasterInfoViewController" bundle:nil];
        MasterModel * tempMode = nil;
    if(_isShopData)
    {
       tempMode= _workShopData[indexPath.row];
    }
    else
    {
        tempMode= _workIndividuaData[indexPath.row];
    }
    masterInfor.masterInfoMode=tempMode;
    [self.navigationController pushViewController:masterInfor animated:YES];
}

 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }


/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
