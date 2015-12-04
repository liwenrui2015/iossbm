//
//  EducationCell.h
//  iossbm
//
//  Created by lrw on 15/11/17.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ModeType;
@property (weak, nonatomic) IBOutlet UILabel *CellTitle;
@property (weak, nonatomic) IBOutlet UILabel *CellInfo;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *countNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@end
