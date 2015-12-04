//
//  MasterModel.h
//  iossbm
//
//  Created by lrw on 15/11/24.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterModel : NSObject
@property(nonatomic,copy)NSString* workId;
@property(nonatomic,copy)NSString* workName;
@property(nonatomic,copy)NSString* workRate;
@property(nonatomic,copy)NSString* workPayNum;
@property(nonatomic,copy)NSString* sellerId;
@property(nonatomic,copy)NSString* workImage;
@property(nonatomic,copy)NSString* workSort;
///增长的数据在技师的作品中要用到
@property(nonatomic,copy)NSString* workType;
///增长的数据在技师的作品中要用到
@property(nonatomic,copy)NSString* workProfile;

@end
