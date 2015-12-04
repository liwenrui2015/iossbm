//
//  commonTools.h
//  iossbm
//
//  Created by lrw on 15/11/10.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "sellerMode.h"

#define IP @"http://192.168.1.117:3000/"

//远程
//#define IP @"http://112.124.60.251:3000/"
#define IsLogin @"Islogined"
#define UserLoginName @"UserName"
#define UserPassword @"Password"

@interface commonTools : NSObject
+(void)showMessage:(NSString *)message;

///电话号码的判断（目前是以13，15，18）开头的
+ (BOOL) validateMobile:(NSString *)mobile;
///密码判断是（6-20位）大小写字母和数据的组合
+ (BOOL) validatePassword:(NSString *)passWord;
///QQ判断
+ (BOOL) validateQQ:(NSString *)UserQQ;
///邮箱判断
+ (BOOL) validateEmail:(NSString *)email;
///美学教育的数据解析
+(NSMutableArray*)ParserEducationEByDic:(NSDictionary*)dic;
+(NSMutableArray*)ParserEducationEByArrs:(NSArray*)arr;
+(NSMutableArray*)ParserDetailedByArrs:(NSArray*)arr;

///美业联盟技师
+(NSMutableArray*)ParserDesigerByDic:(NSDictionary*)dic;
+(NSMutableArray*)ParserDesigerInfoByDic:(NSDictionary*)dic;
+(NSMutableArray*)ParserDesigerContentByArr:(NSArray*)arr;


///美业联盟作品
+(NSMutableArray*)ParserMasterByArrs:(NSArray*)arr;

//支付页面获取技师或店铺详情
+(sellerMode*)ParserPayForByDic:(NSDictionary*)dic;

///订单详情获取所有的订单
+(NSMutableArray*)ParserOrderByDic:(NSDictionary*)dic;

///所有消息
+(NSMutableArray*)ParserMessageByDic:(NSDictionary*)dic;


///所有收藏
+(NSMutableArray*)ParserCollectByDic:(NSDictionary*)dic;


@end
