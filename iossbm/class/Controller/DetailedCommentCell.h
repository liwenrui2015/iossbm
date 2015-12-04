//
//  DetailedCommentCell.h
//  iossbm
//
//  Created by lrw on 15/11/18.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentName;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UILabel *commemtInfo;
@property (weak, nonatomic) IBOutlet UILabel *commentType;
@end
