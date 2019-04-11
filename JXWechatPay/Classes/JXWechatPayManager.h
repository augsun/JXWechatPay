//
//  JXWechatPayManager.h
//  mixc
//
//  Created by augsun on 8/30/16.
//  Copyright © 2016 crland. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 支付结果 */
typedef NS_ENUM(NSUInteger, JXWechatPayResult) {
    JXWechatPaySuccess = 1,         ///< 支付成功
    JXWechatPayNoAppInstalled,      ///< 没安装微信
    JXWechatPayUserCancel,          ///< 用户取消
    JXWechatPayFailure              ///< 支付失败
};

@interface JXWechatPayManager : NSObject

+ (JXWechatPayManager *)sharedWechatPay; ///< 单例
+ (BOOL)wechatInstalled; ///< 是否安装了微信
+ (BOOL)registerApp:(NSString *)appID; ///< 注册微信支付

// 微信跳转回app
+ (BOOL)canHandleOpenURL:(NSURL *)url; ///< 能否处理该 URL
+ (BOOL)handleOpenURL:(NSURL *)url; ///< 处理支付回调 URL

/**
 调起微信支付

 @param payReqDictionary 支付参数 @{@"partnerid": xx, @"prepayid": xx, @"noncestr": xx, @"timestamp": xx, @"package": xx, @"sign": xx, @"appid": xx}, 前面 6 个参数必须传入, appid 最好传入
 @param onRespCallBack 支付结果回调
 */
- (void)payReqDictionary:(NSDictionary *)payReqDictionary onRespCallBack:(void(^)(JXWechatPayResult result, NSString *msg))onRespCallBack;

@end

NS_ASSUME_NONNULL_END










