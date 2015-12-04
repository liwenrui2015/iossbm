//
//  OrderTableViewCell.h
//  iossbm
//
//  Created by lrw on 15/11/30.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *orderTitel;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderInfo;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@end
