//
//  commonTools.m
//  iossbm
//
//  Created by lrw on 15/11/10.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "commonTools.h"
#import "EducationModel.h"
#import "DetailcomentMode.h"
#import "DesignerMode.h"
#import "MasterModel.h"
#import "DesignComentMode.h"
#import "AllOrderMode.h"
#import "MessageMode.h"
#import "collectMode.h"
@implementation commonTools

+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.7f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    [window bringSubviewToFront:showview];
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - LabelSize.width - 20)/2, [[UIScreen mainScreen] bounds].size.height - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18 ，17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL) validateQQ:(NSString *)UserQQ
{
    NSString *passWordRegex = @"[1-9][0-9]{4,}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:UserQQ];
}
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

+(NSMutableArray*)ParserEducationEByDic:(NSDictionary*)dic
{
    NSMutableArray *resulData =[NSMutableArray array];
    
    NSArray *data=[dic objectForKey:@"content"];
    NSArray *data2=[dic objectForKey:@"result"];
    for (int i=0; i<[data count]; i++)
    {
        EducationModel * eduMode =[[EducationModel alloc]init];
        NSDictionary *Dic1=[data objectAtIndex:i];
        NSDictionary *Dic2=[data2 objectAtIndex:i];
        eduMode.contentCount=[NSString stringWithFormat:@"%@",[Dic1 objectForKey:@"content_count"]];
        eduMode.spaceId=[[Dic2 objectForKey:@"space_id"]integerValue];
        eduMode.rspaceComent=[Dic2 objectForKey:@"space_coment"];
        NSString * tempstring =[Dic2 objectForKey:@"space_time"];
        NSString * sub1= [tempstring substringToIndex:10];
        NSString * sub2 =[tempstring substringWithRange:NSMakeRange(11,8)];
        eduMode.spaceTime =[NSString stringWithFormat:@"%@ %@",sub1,sub2];
        eduMode.spaceTile= [Dic2 objectForKey:@"space_tile"];
        eduMode.spaceType= [[Dic2 objectForKey:@"space_type"]integerValue];
        eduMode.pulisher=[Dic2 objectForKey:@"pulisher"];
        eduMode.spaceImage=[Dic2 objectForKey:@"space_image"];
        [resulData addObject:eduMode];
    }
    
    return resulData;
}

+(NSMutableArray*)ParserEducationEByArrs:(NSArray*)arr
{
    NSMutableArray *resulData =[NSMutableArray array];
    
    for (NSDictionary* dic in arr)
    {
        NSString * string = [dic objectForKey:@"coment"];
        [resulData addObject:string];
    }
//        NSLog(@"解析下详情一步的数据是%@",resulData);
    return  resulData;
}

+(NSMutableArray*)ParserDetailedByArrs:(NSArray*)arr
{
    
    NSMutableArray *resulData =[NSMutableArray array];
    
    for (NSDictionary* dic in arr)
    {
        DetailcomentMode * detComMod = [[DetailcomentMode alloc]init];
        detComMod.userId= [dic objectForKey:@"user_id"];
        NSString * timeTring = [dic objectForKey:@"content_time"];
        NSString * sub1= [timeTring substringToIndex:10];
        NSString * sub2 =[timeTring substringWithRange:NSMakeRange(11,8)];
        detComMod.contentTime =[NSString stringWithFormat:@"%@ %@",sub1,sub2];
        detComMod.contentComent= [dic objectForKey:@"content_coment"];
        [resulData addObject:detComMod];
    }
    //    NSLog(@"解析下详情一步的数据是%@",resulData);
    return  resulData;
}

+(NSMutableArray*)ParserDesigerByDic:(NSDictionary*)dic
{
    NSMutableArray *resulData =[NSMutableArray array];
    NSArray *data=[dic objectForKey:@"content"];
    NSArray *data2=[dic objectForKey:@"result"];
    
    for (int i=0; i<[data count]; i++)
    {
        DesignerMode * designer =[[DesignerMode alloc]init];
        NSDictionary *contentDic1=[data objectAtIndex:i];
        NSDictionary *resultDic2=[data2 objectAtIndex:i];
        designer.contentType=[NSString stringWithFormat:@"%@",[contentDic1 objectForKey:@"content_type"]];
        designer.sellerId=[resultDic2 objectForKey:@"seller_id"];
        designer.sellerName=[resultDic2 objectForKey:@"seller_name"];
        designer.sellerVocation=[resultDic2 objectForKey:@"seller_vocation"];
        designer.sellerPassword=[resultDic2 objectForKey:@"seller_password"];
        designer.sellerPhone=[resultDic2 objectForKey:@"seller_phone"];
        designer.sellerLat=[resultDic2 objectForKey:@"seller_lat"];
        designer.sellerLng=[resultDic2 objectForKey:@"seller_lng"];
        designer.sellerAverageRate=[resultDic2 objectForKey:@"seller_average_rate"];
        designer.sellerImage=[resultDic2 objectForKey:@"seller_image"];
        designer.sellerDistance=[resultDic2 objectForKey:@"seller_distance"];
        designer.sellerProfile=[resultDic2 objectForKey:@"seller_profile"];
        designer.sellerType=[NSString stringWithFormat:@"%@",[resultDic2 objectForKey:@"seller_type"]];
        designer.sellerSingleNum=[resultDic2 objectForKey:@"seller_single_num"];
        designer.sellerAddress=[resultDic2 objectForKey:@"seller_address"];
        
        [resulData addObject:designer];
    }
    
    return  resulData;
}

+(NSMutableArray*)ParserMasterByArrs:(NSArray*)arr;
{
    NSMutableArray *resulData =[NSMutableArray array];
    
    for (NSDictionary* dic in arr)
    {
        MasterModel* masterModel = [[MasterModel alloc]init];
        
        masterModel.workId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"work_id"]];
        masterModel.workName=[dic objectForKey:@"work_name"];
        masterModel.workRate=[dic objectForKey:@"work_rate"];
        masterModel.workPayNum=[dic objectForKey:@"work_pay_num"];
        masterModel.sellerId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"seller_id"]];
        masterModel.workImage=[dic objectForKey:@"work_image"];
        masterModel.workSort=[NSString stringWithFormat:@"%@",[dic objectForKey:@"work_sort"]];
        [resulData addObject:masterModel];
    }
    return  resulData;
}


+(sellerMode*)ParserPayForByDic:(NSDictionary*)dic
{
    sellerMode * sellMode = [[sellerMode alloc]init];
    NSDictionary * modeDic = [dic objectForKey:@"seller"];
    sellMode.sellerName=[modeDic objectForKey:@"seller_name"];
    sellMode.sellerSingleNum=[modeDic objectForKey:@"seller_single_num"];
    sellMode.sellerPhone=[modeDic objectForKey:@"seller_phone"];
    sellMode.sellerLat=[modeDic objectForKey:@"seller_lat"];
    sellMode.sellerLng=[modeDic objectForKey:@"seller_lng"];
    return sellMode;
}


+(NSMutableArray*)ParserDesigerInfoByDic:(NSDictionary*)dic
{
    NSMutableArray *resulData =[NSMutableArray array];
    NSArray* arr = [dic objectForKey:@"result"];
    for (NSDictionary* tempDic in arr)
    {
        MasterModel* masterModel = [[MasterModel alloc]init];
        
        masterModel.workId=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"work_id"]];
        masterModel.workName=[tempDic objectForKey:@"work_name"];
        masterModel.workRate=[tempDic objectForKey:@"work_rate"];
        masterModel.workPayNum=[tempDic objectForKey:@"work_pay_num"];
        masterModel.sellerId=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"seller_id"]];
        masterModel.workImage=[tempDic objectForKey:@"work_image"];
        masterModel.workSort=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"work_sort"]];
        masterModel.workType= [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"work_type"]];
        masterModel.workProfile= [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"work_profile"]];
        [resulData addObject:masterModel];
    }
    return resulData;
}


+(NSMutableArray*)ParserDesigerContentByArr:(NSArray*)arr
{
    
    NSMutableArray *resulData =[NSMutableArray array];
    
    for (NSDictionary* dic in arr)
    {
        DesignComentMode * DesComMod = [[DesignComentMode alloc]init];
        DesComMod.userName= [dic objectForKey:@"user_name"];
        NSString * timeTring = [dic objectForKey:@"content_date"];
        NSString * sub1= [timeTring substringToIndex:10];
        NSString * sub2 =[timeTring substringWithRange:NSMakeRange(11,8)];
        DesComMod.contentTime =[NSString stringWithFormat:@"%@ %@",sub1,sub2];
        DesComMod.contentComent= [dic objectForKey:@"content_coment"];
        DesComMod.contentType=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content_type"]];
        [resulData addObject:DesComMod];
    }
    //    NSLog(@"解析下详情一步的数据是%@",resulData);
    return  resulData;
    
    
}

+(NSMutableArray*)ParserOrderByDic:(NSDictionary*)dic
{
    NSMutableArray *resulData =[NSMutableArray array];
    NSArray *ordersData=[dic objectForKey:@"orders"];
    NSArray *workData=[dic objectForKey:@"work"];
    
    for (int i=0; i<[ordersData count]; i++)
    {
        
        AllOrderMode * allOrder = [[AllOrderMode alloc]init];
        NSDictionary *ordersDataDic=[ordersData objectAtIndex:i];
        NSDictionary *workDataDic=[workData objectAtIndex:i];
        allOrder.orderId=[NSString stringWithFormat:@"%@",[ordersDataDic objectForKey:@"order_id"]];
        allOrder.orderDate=[ordersDataDic objectForKey:@"order_date"];
        allOrder.orderAddress=[ordersDataDic objectForKey:@"order_address"];
        allOrder.orderState=[NSString stringWithFormat:@"%@",[ordersDataDic objectForKey:@"order_state"]];
        allOrder.userId=[ordersDataDic objectForKey:@"user_id"];
        allOrder.workId=[NSString stringWithFormat:@"%@",[ordersDataDic objectForKey:@"work_id"]];
        allOrder.serviceDate=[ordersDataDic objectForKey:@"service_date"];
        
        allOrder.workName=[workDataDic objectForKey:@"work_name"];
        allOrder.workRate=[workDataDic objectForKey:@"work_rate"];
        allOrder.workPayNum=[workDataDic objectForKey:@"work_pay_num"];
        allOrder.workType=[NSString stringWithFormat:@"%@",[workDataDic objectForKey:@"work_type"]];
        allOrder.sellerId=[NSString stringWithFormat:@"%@",[workDataDic objectForKey:@"seller_id"]];
        allOrder.workImage=[workDataDic objectForKey:@"work_image"];
        allOrder.worksort=[NSString stringWithFormat:@"%@",[workDataDic objectForKey:@"work_sort"]];
        allOrder.workProfile=[workDataDic objectForKey:@"work_profile"];
        
        [resulData addObject:allOrder];
    }
    
    return  resulData;
}



+(NSMutableArray*)ParserMessageByDic:(NSDictionary*)dic
{
    NSMutableArray *resulData =[NSMutableArray array];
    
    NSArray *allDic=[dic objectForKey:@"news"];
    
    
    for (NSDictionary * tempDic in allDic)
    {
        MessageMode * messageMode = [[MessageMode alloc]init];
        messageMode.myNewsID=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"news_id"]];
        messageMode.myNewsType=[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"news_type"]];
        messageMode.myNewsTitle=[tempDic objectForKey:@"new_tile"];
        messageMode.myNewsComent=[tempDic objectForKey:@"new_coment"];
        messageMode.myNewsUserId=[tempDic objectForKey:@"user_id"];
        [resulData addObject:messageMode];
    }
    return  resulData;
}



+(NSMutableArray*)ParserCollectByDic:(NSDictionary*)dic
{
    NSMutableArray *resulData =[NSMutableArray array];
    
    NSArray * coupons = [dic objectForKey:@"coupons"];
    NSArray * worksArr = [dic objectForKey:@"works"];
    NSArray * sellersArr=[dic objectForKey:@"sellers"];
    
    for(NSDictionary * tempdic in coupons)
    {
        CollectMode * collectMode=[[CollectMode alloc]init];
        collectMode.couponId=[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"coupon_type"]];
        collectMode.couponType=[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"coupon_type"]];
        collectMode.couponThingId=[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"coupon_thing_id"]];
        collectMode.userId=[tempdic objectForKey:@"user_id"];
        
        //1代表的是work作品
        if([collectMode.couponType isEqualToString:@"1"])
        {
            MasterModel* tempMaster=[[MasterModel alloc]init];
            for (NSDictionary* master in worksArr)
            {
                if([[NSString stringWithFormat:@"%@",[master objectForKey:@"work_id"]] isEqualToString:collectMode.couponThingId])
                {
                    tempMaster.workId=[NSString stringWithFormat:@"%@",[master objectForKey:@"work_id"]];
                    tempMaster.workName=[master objectForKey:@"work_name"];
                    tempMaster.workRate=[master objectForKey:@"work_rate"];
                    tempMaster.workPayNum=[master objectForKey:@"work_pay_num"];
                    tempMaster.sellerId=[NSString stringWithFormat:@"%@",[master objectForKey:@"seller_id"]];
                    tempMaster.workImage=[master objectForKey:@"work_image"];
                    tempMaster.workSort=[NSString stringWithFormat:@"%@",[master objectForKey:@"work_sort"]];
                    tempMaster.workType= [NSString stringWithFormat:@"%@",[master objectForKey:@"work_type"]];
                    tempMaster.workProfile= [NSString stringWithFormat:@"%@",[master objectForKey:@"work_profile"]];
                    collectMode.collentMasterModel=tempMaster;
                    break;
                }
            }
        }
        //2代表的是技师
        if([collectMode.couponType isEqualToString:@"2"])
        {
            DesignerMode * tempDesigner=[[DesignerMode alloc]init];
            for (NSDictionary* Designer in sellersArr)
            {
                if([[NSString stringWithFormat:@"%@",[Designer objectForKey:@"seller_id"]] isEqualToString:collectMode.couponThingId])
                {
                    
                    tempDesigner.sellerId=[NSString stringWithFormat:@"%@",[Designer objectForKey:@"seller_id"]];
                    tempDesigner.sellerName=[Designer objectForKey:@"seller_name"];
                    tempDesigner.sellerVocation=[NSString stringWithFormat:@"%@",[Designer objectForKey:@"seller_vocation"]];
                    tempDesigner.sellerPassword=[Designer objectForKey:@"seller_password"];
                    tempDesigner.sellerPhone=[Designer objectForKey:@"seller_phone"];
                    tempDesigner.sellerLat=[NSString stringWithFormat:@"%@",[Designer objectForKey:@"seller_lat"]];
                    tempDesigner.sellerLng=[NSString stringWithFormat:@"%@",[Designer objectForKey:@"seller_lng"]];
                    tempDesigner.sellerAverageRate=[Designer objectForKey:@"seller_average_rate"];
                    tempDesigner.sellerImage=[Designer objectForKey:@"seller_image"];
                    tempDesigner.sellerDistance=[Designer objectForKey:@"seller_distance"];
                    tempDesigner.sellerProfile=[Designer objectForKey:@"seller_profile"];
                    tempDesigner.sellerType=[NSString stringWithFormat:@"%@",[Designer objectForKey:@"seller_type"]];
                    tempDesigner.sellerSingleNum=[Designer objectForKey:@"seller_single_num"];
                    tempDesigner.sellerAddress=[Designer objectForKey:@"seller_address"];
                    collectMode.collentDesignerMode=tempDesigner;
                    break;
                    
                }
            }
            
        }
        [resulData addObject:collectMode];
    }
    return  resulData;
    
}

//用户名
//+ (BOOL) validateUserName:(NSString *)name
//{
//    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
//    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
//    BOOL B = [userNamePredicate evaluateWithObject:name];
//    return B;
//}

//昵称
//+ (BOOL) validateNickname:(NSString *)nickname
//{
//    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
//    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
//    return [passWordPredicate evaluateWithObject:nickname];
//}

//身份证号
//+ (BOOL) validateIdentityCard: (NSString *)identityCard
//{
//    BOOL flag;
//    if (identityCard.length <= 0) {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
//}
////车型
//+ (BOOL) validateCarType:(NSString *)CarType
//{
//    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
//    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
//    return [carTest evaluateWithObject:CarType];
//}
////车牌号验证
//+ (BOOL) validateCarNo:(NSString *)carNo
//{
//    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
//    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
//    return [carTest evaluateWithObject:carNo];
//}

@end
