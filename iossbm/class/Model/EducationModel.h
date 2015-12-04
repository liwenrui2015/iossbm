//
//  EducationModel.h
//  iossbm
//
//  Created by lrw on 15/11/17.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface EducationModel : NSObject
@property(nonatomic,assign)NSInteger spaceId;
@property(nonatomic,copy)NSString * rspaceComent;
@property(nonatomic,copy)NSString *spaceTime;
@property(nonatomic,copy)NSString * spaceTile;
@property(nonatomic,assign)NSInteger spaceType;
@property(nonatomic,copy)NSString *pulisher;
@property(nonatomic,copy)NSString* spaceImage;
@property(nonatomic,copy)NSString* contentCount;
@property(nonatomic ,strong)NSArray * nextStepData;
@end
