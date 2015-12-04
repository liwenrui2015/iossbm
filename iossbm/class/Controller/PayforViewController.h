//
//  PayforViewController.h
//  iossbm
//
//  Created by apple on 15/11/25.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterModel.h"
@interface PayforViewController : UIViewController
@property(nonatomic,strong)MasterModel* payInfoMode;
@property(nonatomic,copy)NSString* theTiem;
@property(nonatomic,copy)NSString* theAdress;
@property(nonatomic,copy)NSString* passOrderId;
@property(nonatomic,assign)Boolean isCanPay;

@end
