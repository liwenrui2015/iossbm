//
//  DetailedMode.h
//  iossbm
//
//  Created by lrw on 15/11/18.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailedMode : NSObject
@property(nonatomic,assign)NSInteger spaceId;
@property(nonatomic,assign)NSInteger CellType;
@property(nonatomic,copy)NSString* headImagePath;
@property(nonatomic,copy)NSString* headName;
@property(nonatomic,copy)NSString* headTime;
@property(nonatomic,copy)NSString* headTitle;
@end
