//
//  Tools.h
//  iossbm
//
//  Created by lrw on 15/11/6.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DisegnSize 320
#define CHANNEL_GAP_SPACE           4.0
#define AD_WIDTH                    312.0
#define AD_HEIGHT                   170.0

#define ScreecSIze  [UIScreen mainScreen].bounds.size
#define ScreecSIzeW ScreecSIze.width
#define ScreecSIzeH ScreecSIze.height
#define SCALETO   ScreecSIzeW*1.000/DisegnSize

@interface Tools : NSObject

@end
