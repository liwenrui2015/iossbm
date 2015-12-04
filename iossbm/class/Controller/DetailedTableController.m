//
//  DetailedTableController.m
//  iossbm
//
//  Created by lrw on 15/11/17.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "DetailedTableController.h"
#import "AFNetworking.h"
#import "commonTools.h"
#import "DetailedImageCell.h"
#import "InfoTextCell.h"
#import "DetailcomentMode.h"
#import "DetailedCommentCell.h"
#import <MediaPlayer/MediaPlayer.h>
//#import <AVFoundation/AVFoundation.h>

@interface DetailedTableController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *headName;
@property (weak, nonatomic) IBOutlet UILabel *headTime;
@property (weak, nonatomic) IBOutlet UILabel *headTitle;
@property (strong, nonatomic) IBOutlet UITableViewCell *headCell;
@property (strong, nonatomic) IBOutlet UIView *PlayerView;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondHead;
@property (strong, nonatomic) IBOutlet UITableViewCell *endCell;
///评论的内容
@property (weak, nonatomic) IBOutlet UITextField *commentText;
///评论的数据
@property(nonatomic,strong) NSMutableArray* commentData;
@end

@implementation DetailedTableController
static NSString*CellTextId =@"InfoTextCell";
static NSString*CellImageId =@"DetailedImageCell";
static NSString*CommentIdentifer =@"DetailedCommentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情页";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // 设置为一个接近“平均”行高的值
    //图片详情
    UINib * nibImage = [UINib nibWithNibName:@"DetailedImageCell" bundle:nil];
    [self.tableView registerNib:nibImage forCellReuseIdentifier:CellImageId];
    //字详情
    UINib * nibText = [UINib nibWithNibName:@"InfoTextCell" bundle:nil];
    [self.tableView registerNib:nibText forCellReuseIdentifier:CellTextId];
    //评论
    UINib * nibCom = [UINib nibWithNibName:@"DetailedCommentCell" bundle:nil];
    [self.tableView registerNib:nibCom forCellReuseIdentifier:CommentIdentifer];

    NSString * path =[NSString stringWithFormat:@"%@getContents?",IP];
    NSDictionary * parsms =@{@"spaceId":[NSString stringWithFormat:@"%d",(int)self.selfMode.spaceId]};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray * array =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         self.commentData = [commonTools ParserDetailedByArrs:array];
         [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
    
    
    self.headName.text = self.selfMode.headName;
    self.headTime.text = self.selfMode.headTime;
    self.headTitle.text= self.selfMode.headTitle;
    NSString * headpath =[NSString stringWithFormat:@"%@getLoveSellerById?",IP];
    NSDictionary * headparsms =@{@"sellerName":self.selfMode.headName};
    AFHTTPRequestOperationManager * headmanager = [AFHTTPRequestOperationManager manager];
    [headmanager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [headmanager GET:headpath parameters:headparsms success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       
         if(![[dic objectForKey:@"seller_image"] isEqualToString:@""])
         {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,[dic objectForKey:@"seller_image"]]]];
                 UIImage *image = [UIImage imageWithData:data];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.headImage.image = image;
                 });
             });
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"111请求失败%@",error);
     }];
    
    
    
    
    NSLog(@"现在：%ld",[self.arrayData count]);
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
        return [self.arrayData count]+1;
    }
    else
    {
        return [self.commentData count]+1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.selfMode.CellType==1)//1是帖子
    {
        if(section==0)
        {
            return 1;
        }
        else
        {
            return 60;
        }
    }
    else
    {
        if(section==0)
        {
            return 1;
        }
        else
        {
            return 60;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return self.PlayerView;
    }else
    {
        return self.secondHead;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0&&indexPath.row==0)
    {
        return self.headCell;
    }else if(indexPath.section==0&&indexPath.row!=0)
    {
        if ([[self.arrayData objectAtIndex:indexPath.row-1]rangeOfString:@".mp4"].location==NSNotFound&&[[self.arrayData objectAtIndex:indexPath.row-1]rangeOfString:@".png"].location==NSNotFound)
        {
             InfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTextId forIndexPath:indexPath];
            cell.InfoText.text=[self.arrayData objectAtIndex:indexPath.row-1];
            return cell;
        }
        else
        {
            DetailedImageCell * cell  = [tableView dequeueReusableCellWithIdentifier:CellImageId forIndexPath:indexPath];
            
            NSLog(@"图片路径是：%@",[NSString stringWithFormat:@"%@%@",IP,[self.arrayData objectAtIndex:indexPath.row-1]]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,[self.arrayData objectAtIndex:indexPath.row-1]]]];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.showImage.image = image;
                    [cell setNeedsLayout];
                });
            });
            return cell;
        }
    }
    else if(indexPath.section==1&&indexPath.row!=[self.commentData count])
    {
        DetailedCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentIdentifer forIndexPath:indexPath];
        DetailcomentMode * CellMode = [self.commentData objectAtIndex:indexPath.row];
        
        cell.commentName.text=CellMode.userId;
        cell.commentTime.text= CellMode.contentTime;
        cell.commemtInfo.text=CellMode.contentComent;
        return cell;
    }
    else
    {
        return _endCell;
    }
}

- (IBAction)SendComment:(UIButton *)sender
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:IsLogin])
    {
        if([_commentText.text isEqualToString:@""])
        {
            UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"内容空" message:@"亲空评论让人遐想联翩！" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
            [alerView show];
        }else
        {
            
            NSString * path =[NSString stringWithFormat:@"%@insertContent?",IP];
            NSDictionary * parsms =@{@"comtent":_commentText.text,@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName],@"spaceId":[NSString stringWithFormat:@"%d",(int)self.selfMode.spaceId]};
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            [manager GET:path parameters:parsms success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSLog(@"=======%@",[dic objectForKey:@"result"]);
                 if([[dic objectForKey:@"result"] isEqualToString:@"success"])
                 {
                     DetailcomentMode * mode= [[DetailcomentMode alloc]init];
                     mode.userId=[[NSUserDefaults standardUserDefaults]objectForKey:UserLoginName];
                     mode.contentComent= _commentText.text;
                     //得到当前系统日期
                     NSDate *date1 = [NSDate date];
                     //然后您需要定义一个NSDataFormat的对象
                     NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
                     //然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
                     dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:SS";
                     //之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
                     NSString * dateToString = [dateFormater stringFromDate:date1];
                     //打印结果就是当前日期了
                     mode.contentTime=dateToString;
                   
                     NSLog(@"用户名是：%@",mode.userId);
                     [_commentData addObject:mode];
                     NSIndexPath *newPath = [NSIndexPath indexPathForRow:[_commentData count] inSection:1];
                     NSArray* indexs=@[newPath];
                     [self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];
                     [self.tableView reloadData];
                 }
                 else
                 {
                     UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"亲失败" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
                     [alerView show];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"111请求失败%@",error);
             }];
            
        }
    }
    else
    {
        UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"尚未登录" message:@"亲登录后才可以评论！" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        [alerView show];
    }
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if(self.selfMode.CellType==3)//2是视频
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://192.168.1.117:3000/images/jiqimao001.mp4"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [movie.moviePlayer prepareToPlay];
                [self presentMoviePlayerViewControllerAnimated:movie];
                movie.moviePlayer.controlStyle= MPMovieControlStyleEmbedded;
                movie.moviePlayer.scalingMode=MPMovieScalingModeAspectFill;
                [movie.view setBackgroundColor:[UIColor clearColor]];
                [movie.view setFrame:self.PlayerView.frame];
                [self.PlayerView addSubview:movie.view];
            });
        });
    }
    //    NSLog(@"%@",self.arrayData);
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table viewindexPath
//        
//        
//        
//    }
//}


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

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
