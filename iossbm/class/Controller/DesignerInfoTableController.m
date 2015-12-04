//
//  DesignerInfoTableController.m
//  iossbm
//
//  Created by apple on 15/11/27.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import "DesignerInfoTableController.h"
#import "commonTools.h"
#import "AFNetworking.h"
#import "MasterModel.h"
#import "DesignComentMode.h"
#import "DesInfoTableViewCell.h"
#import "DetailedCommentCell.h"
//作品页面
#import "MasterInfoViewController.h"

@interface DesignerInfoTableController ()
@property(nonatomic,strong)NSMutableArray *designerWorkData;
@property(nonatomic,strong)NSMutableArray *designerContentData;

@property (strong, nonatomic) IBOutlet UITableViewCell *pesonalCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *shopCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *DesignInfoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentCountCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contentType;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end



@implementation DesignerInfoTableController



static NSString * DesInfoCell =@"DesInfoTableViewCell";
static NSString * DesCommentCell =@"DesCommentCell";
-(void)collectBut:(id)seder
{

    
    NSString * path =[NSString stringWithFormat:@"%@insertCoupons?",IP];
    NSDictionary * parsms =@{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName],@"couponType":@2,@"couponThing":self.designerMode.sellerId};
        
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[dic objectForKey:@"result"] isEqualToString:@"success"])
         {
             [commonTools showMessage:@"收藏成功"];
         }
         else if([[dic objectForKey:@"result"] isEqualToString:@"alreay"])
         {
             [commonTools showMessage:@"已经收藏"];
         }
         else
         {
             [commonTools showMessage:@"收藏失败"];
             
         }
         
        
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];

    NSLog(@"收藏");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";

     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collectBut:)];
    
    
    [self disablesAutomaticKeyboardDismissal];
    UINib * nib = [UINib nibWithNibName:@"DesInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:DesInfoCell];
    UINib *nibCommentCell=[UINib nibWithNibName:@"DetailedCommentCell" bundle:nil];
    [self.tableView registerNib:nibCommentCell forCellReuseIdentifier:DesCommentCell];
 
    if([self.designerMode.sellerType isEqualToString:@"1"])
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,self.designerMode.sellerImage]]];
            UIImage *image=nil;
            if(data)
                image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image)
                    ((UIImageView*)[ self.pesonalCell viewWithTag:3001]).image=image;
            });
        });
         ((UILabel*)[self.pesonalCell viewWithTag:3002]).text=self.designerMode.sellerName;
        NSString * name =[NSString stringWithFormat:@"heat%d.png",[self.designerMode.contentType intValue]];
        NSLog(@"图片的名字是：%@",name);
        ((UIImageView*)[self.pesonalCell viewWithTag:3003]).image=[UIImage imageNamed:name];

       
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,self.designerMode.sellerImage]]];
            UIImage *image=nil;
            if(data)
                image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image)
                    ((UIImageView*)[self.shopCell viewWithTag:1001]).image=image;
            });
        });
        ((UILabel*)[self.shopCell viewWithTag:1002]).text=self.designerMode.sellerName;
        ((UILabel*)[self.shopCell viewWithTag:1003]).text=[NSString stringWithFormat:@"店铺评分：%@分",self.designerMode.contentType];
        ((UILabel*)[self.shopCell viewWithTag:1004]).text=[NSString stringWithFormat:@"所在地址：%@",self.designerMode.sellerAddress];
    }
    
    NSString * path =[NSString stringWithFormat:@"%@getSelfWork?",IP];
    NSDictionary * parsms =@{@"sellerId":self.designerMode.sellerId};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.designerWorkData=[commonTools ParserDesigerInfoByDic:dic];
         
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];
    NSString * path2 =[NSString stringWithFormat:@"%@getAllContent?",IP];
    [manager GET:path2 parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray * arrs =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         self.designerContentData = [commonTools ParserDesigerContentByArr:arrs];
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 44;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if(section==0)
    {
        return 2;
    }
    else if (section ==1)
    {
        return _designerWorkData.count;
    }
    else if(section ==2)
    {
        return _designerContentData.count;
    }
    else
    {
        return 1;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    else if (section ==1)
    {
        if(_designerWorkData.count>0)
        {
            return @"设计师作品";
        }
        else
        {
            return @"没有作品";
        }
    }
    else if(section ==2)
    {
        if(_designerContentData.count==0)
        {
            return @"没有评价";
        }
        else
        {
            return @"评价";
        }
    }
    else
    {
        return @"发表评论";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0.5;
    }
    else
    {
        return 10.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0&&indexPath.row==0)
    {
        if([self.designerMode.sellerType isEqualToString:@"1"])
        {
            return self.pesonalCell;
        }
        else
        {
            return self.shopCell;
        }
    }
    
    if(indexPath.section==0&&indexPath.row==1)
    {
        ((UILabel*)[self.DesignInfoCell viewWithTag:2001]).text=self.designerMode.sellerProfile;
        return self.DesignInfoCell;
        
    }

    if(indexPath.section==1)
    {
          DesInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DesInfoCell forIndexPath:indexPath];
         MasterModel * mode = _designerWorkData[indexPath.row];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,mode.workImage]]];
            UIImage *image=nil;
            if(data)
                image = [UIImage imageWithData:data];
           dispatch_async(dispatch_get_main_queue(), ^{
               if(image)
               cell.CellImage.image=image;
           });
        });
        cell.CellTitle.text=mode.workName;
        cell.CellCount.text=mode.workPayNum;
        cell.CellPrice.text=mode.workRate;
        return cell;
    }
    
    if(indexPath.section==2)
    {
      DetailedCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:DesCommentCell forIndexPath:indexPath];
        DesignComentMode * desingMode = self.designerContentData[indexPath.row];



//     commentType;
        cell.commentName.text=desingMode.userName;
        cell.commentTime.text=desingMode.contentTime;
        cell.commemtInfo.text=desingMode.contentComent;
        
        if([desingMode.contentType isEqualToString:@"1"])
        {
        cell.commentType.text=@"差评";
        }
        else if([desingMode.contentType isEqualToString:@"3"])
        {
            cell.commentType.text=@"中评";
        }
        else
        {
            cell.commentType.text=@"好评";
        }
        
///    commentImage;    是死数据：
// dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,desingMode.]]];
//            UIImage *image=nil;
//            if(data)
//                image = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(image)
//                    cell.commentImage.image=image;
//            });
//        });
        return cell;
    }
    if(indexPath.section==3)
    {
        return self.contentCell;
    }
    
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    return cell;
}
- (IBAction)dismissKeyboard:(UIButton *)sender
{
    [self.contentTextView  resignFirstResponder];
}

- (IBAction)submitOK:(id)sender
{
    

  
    
    
    NSString * comentType= [NSString stringWithFormat:@"%ld",(2-self.contentType.selectedSegmentIndex)*2+1];
    NSString * path =[NSString stringWithFormat:@"%@insertContentById?",IP];
    NSDictionary * parsms =@{@"comentType":comentType,@"sellerId":self.designerMode.sellerId,@"coment":self.contentTextView.text,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName]};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
          NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",dic);
         
         if([[dic objectForKey:@"result"]isEqualToString:@"success"])
         {
           
             DesignComentMode* coment =[[DesignComentMode alloc]init];
             coment.userName=[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName];
             //得到当前系统日期
             NSDate *date1 = [NSDate date];
             //然后您需要定义一个NSDataFormat的对象
             NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
             //然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
             dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:SS";
             //之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
             NSString * dateToString = [dateFormater stringFromDate:date1];
             //打印结果就是当前日期了
             coment.contentTime=dateToString;
             coment.contentComent=self.contentTextView.text;
             coment.contentType=[NSString stringWithFormat:@"%ld",(2-self.contentType.selectedSegmentIndex)*2+1];
             
             
             [_designerContentData addObject:coment];
             [self.tableView reloadData];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"111请求失败%@",error);
     }];
}


 // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
// return YES;
// }
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}




 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
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
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
     if(indexPath.section==1)
     {
 MasterInfoViewController *detailViewController = [[MasterInfoViewController alloc] initWithNibName:@"MasterInfoViewController" bundle:nil];
         detailViewController.masterInfoMode=_designerWorkData[indexPath.row];
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
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
