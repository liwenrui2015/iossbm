//
//  AppDelegate.m
//  iossbm
//
//  Created by lrw on 15/11/5.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import "AppDelegate.h"

#import <SMS_SDK/SMSSDK.h>

//shareSDK
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
//shareSDK
///支付宝
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

//if ([url.host isEqualToString:@"safepay"]) {} 没有安装支付宝钱包的情况下直接执行回调：
//[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) { NSLog(@"callback reslut = %@",resultDic); }];


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    ///支付宝
    //   url: alisdkiossbm
    if ([url.host isEqualToString:@"safepay"])
    {
        NSLog(@"safepay::%@",url);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
         }];
        return YES;
    }
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSLog(@"链接到其他APP%@",url);
    if ([[url scheme] isEqualToString:@"myMusicAPP"])
    {
        NSLog(@"=======%@",url);
        return YES;
    }
    if ([[url scheme] isEqualToString:@"myMusicAPP"])
    {
        return [ShareSDK handleOpenURL:url wxDelegate:self];
    }
    
 
    return YES;
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SMSSDK registerApp:@"c33a7a3572f0" withSecret:@"6d65e9e36a73c164c2a75847ded434a4"];
    [ShareSDK registerApp:@"c33b27871208"];//字符串api20为您的ShareSDK的AppKey
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    //PASS
    [ShareSDK connectQZoneWithAppKey:@"1104886595"
                           appSecret:@"XES9RexiCDt3iyeO"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"1104886595"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    //PASS
    [ShareSDK connectWeChatWithAppId:@"wx863b474627941e17"
                           appSecret:@"d4624c36b6795d1d99dcf0547af5443d"
                           wechatCls:[WXApi class]];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
