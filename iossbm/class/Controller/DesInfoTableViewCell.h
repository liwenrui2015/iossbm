//
//  DesInfoTableViewCell.h
//  iossbm
//
//  Created by lrw on 15/11/28.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CellImage;
@property (weak, nonatomic) IBOutlet UILabel *CellTitle;
@property (weak, nonatomic) IBOutlet UILabel *CellCount;
@property (weak, nonatomic) IBOutlet UILabel *CellPrice;

@end
