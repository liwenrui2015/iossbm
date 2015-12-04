//
//  DetailedTableController.h
//  iossbm
//
//  Created by lrw on 15/11/17.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedMode.h"
@interface DetailedTableController : UITableViewController
///步骤数据（上半部分）
@property(nonatomic,strong)NSMutableArray * arrayData;
///头部数据
@property(nonatomic,strong)DetailedMode * selfMode;
@end
