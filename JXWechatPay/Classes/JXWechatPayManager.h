//
//  JXWechatPayManager.h
//  JXWechatPay
//
//  Created by augsun on 8/30/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 支付结果 */
typedef NS_ENUM(NSUInteger, JXWechatPayResult) {
    JXWechatPayResultSuccess = 1, ///< 支付成功
    JXWechatPayResultNoAppInstalled, ///< 没安装微信
    JXWechatPayResultUserCancel, ///< 用户取消
    JXWechatPayResultFailure ///< 支付失败
};

/**
 支付结果回调

 @param result 支付结果
 @param msg 结果消息
 */
typedef void (^JXWechatPayResultCallback)(JXWechatPayResult result, NSString *msg);

/**
 基于 WechatOpenSDK (版本见 JXWechatPay.podspec 中的 s.dependency 'WechatOpenSDK', 'X.X.X') 封装.
 */
@interface JXWechatPayManager : NSObject

+ (JXWechatPayManager *)sharedWechatPay; ///< 单例
+ (BOOL)wechatInstalled; ///< 是否安装了微信
+ (BOOL)registerApp:(NSString *)appID; ///< 注册微信支付

+ (BOOL)canHandleOpenURL:(NSURL *)url; ///< 能否处理该 URL
+ (BOOL)handleOpenURL:(NSURL *)url; ///< 处理支付回调 URL

/**
 调起微信支付

 @param reqDic 支付参数 @{@"partnerid": xx, @"prepayid": xx, @"noncestr": xx, @"timestamp": xx, @"package": xx, @"sign": xx, @"appid": xx}, 前面 6 个参数必须传入, appid 最好传入
 @param result 支付结果回调
 */
- (void)payWithReqDic:(NSDictionary *)reqDic result:(JXWechatPayResultCallback)result;

@end

NS_ASSUME_NONNULL_END










