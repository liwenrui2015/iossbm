//
//  MasterCollecCell.h
//  iossbm
//
//  Created by lrw on 15/11/20.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCollecCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView * infoImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sellNum;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
