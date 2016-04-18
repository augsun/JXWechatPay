//
//  JXWechatPayManager.h
//  JXWechatPay
//
//  Created by shiba_iosJX on 3/30/16.
//  Copyright © 2016 shiba_iosJX. All rights reserved.
//

//  JXWechatPayManager /* https://github.com/augsun/JXWechatPay */

/*
 * 1, 导入 sdk
 * 2, 导入 frameworks:
 *    SystemConfiguration.framework
 *    CoreTelephony.framework
 *    libz.tbd
 *    libsqlite3.0.tbd
 *    libc++.tbd
 * 3, Info.plist 里加入数组 LSApplicationQueriesSchemes weixin
 * 4, URL types 里加入 对应的 appid
 * 5, 在 AppDelegate 里注册: - (BOOL)jx_registerApp:(NSString *)appid withDescription:(NSString *)appdesc;
 *    在 AppDelegate 里重写: - (BOOL)jx_handleOpenURL:(NSURL *)url;
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WXApi.h"

typedef NS_ENUM(NSUInteger, JXWechatPayResult) {
    JXWechatPaySuccess,
    JXWechatPayNoAppInstalled,
    JXWechatPayUserCancel,
    JXWechatPayFailure
};

typedef void(^JXBlockWechatPayResult)(JXWechatPayResult result);

@interface JXWechatPayManager : NSObject

+ (JXWechatPayManager *)shareManager;

- (BOOL)jx_registerApp:(NSString *)appid withDescription:(NSString *)appdesc;

- (BOOL)jx_handleOpenURL:(NSURL *)url;

- (void)jx_payWechat:(PayReq *)payReq callBack:(JXBlockWechatPayResult)blockPayResult;

@end









