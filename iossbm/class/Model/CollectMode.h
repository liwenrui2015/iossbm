//
//  collectMode.h
//  iossbm
//
//  Created by lrw on 15/12/1.
//  Copyright © 2015年 liwenrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterModel.h"
#import "DesignerMode.h"
@interface CollectMode : NSObject
@property(nonatomic,copy)NSString* couponId;
@property(nonatomic,copy)NSString* couponType;
@property(nonatomic,copy)NSString* couponThingId;
@property(nonatomic,copy)NSString* userId;
@property(nonatomic,strong)MasterModel* collentMasterModel;
@property(nonatomic,strong)DesignerMode* collentDesignerMode;
@end
