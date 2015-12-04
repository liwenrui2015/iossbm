//
//  DesignerOneCell.h
//  iossbm
//
//  Created by lrw on 15/11/20.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignerOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellheadImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *pirce;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end
