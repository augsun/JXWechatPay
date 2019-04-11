//
//  JXWechatPayManager.m
//  mixc
//
//  Created by augsun on 8/30/16.
//  Copyright © 2016 crland. All rights reserved.
//

#import "JXWechatPayManager.h"
#import <WXApi.h>

#define JX_BLOCK_EXEC(block, ...) !block ? nil : block(__VA_ARGS__)

@interface JXWechatPayManager () <WXApiDelegate>

@property (nonatomic, copy) void(^onRespCallBack)(JXWechatPayResult result, NSString * _Nonnull msg);

@end

@implementation JXWechatPayManager

static JXWechatPayManager *singleton_;
+ (JXWechatPayManager *)sharedWechatPay {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton_ = [[self alloc] init];
    });
    return singleton_;
}

+ (BOOL)wechatInstalled {
    BOOL ret = [WXApi isWXAppInstalled];
    return ret;
}

+ (BOOL)registerApp:(NSString *)appID {
    BOOL ret = [WXApi registerApp:appID];
    return ret;
}

+ (BOOL)canHandleOpenURL:(NSURL *)URL {
    if ([URL.scheme hasPrefix:@"wx"] && [URL.host isEqualToString:@"pay"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    JXWechatPayManager *sharedManager = [JXWechatPayManager sharedWechatPay];
    BOOL ret = [WXApi handleOpenURL:url delegate:sharedManager];
    return ret;
}

- (void)payWithReqDic:(NSDictionary *)reqDic onRespCallBack:(void (^)(JXWechatPayResult, NSString * _Nonnull))onRespCallBack {

    _onRespCallBack = onRespCallBack;

    if ([reqDic.allKeys containsObject:@"appid"]) {
        [WXApi registerApp:reqDic[@"appid"]];
    }

    if (![WXApi isWXAppInstalled]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayNoAppInstalled, @"未安装微信");
        return;
    }

    //
    if (![reqDic.allKeys containsObject:@"partnerid"]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayFailure, @"missing \"partnerid\".");
        return;
    }
    if (![reqDic.allKeys containsObject:@"prepayid"]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayFailure, @"missing \"prepayid\".");
        return;
    }
    if (![reqDic.allKeys containsObject:@"noncestr"]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayFailure, @"missing \"noncestr\".");
        return;
    }
    if (![reqDic.allKeys containsObject:@"timestamp"]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayFailure, @"missing \"timestamp\".");
        return;
    }
    if (![reqDic.allKeys containsObject:@"package"]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayFailure, @"missing \"package\".");
        return;
    }
    if (![reqDic.allKeys containsObject:@"sign"]) {
        JX_BLOCK_EXEC(self.onRespCallBack, JXWechatPayFailure, @"missing \"sign\".");
        return;
    }
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = reqDic[@"partnerid"];
    req.prepayId            = reqDic[@"prepayid"];
    req.nonceStr            = reqDic[@"noncestr"];
    
    NSString *timestamp_string = [NSString stringWithFormat:@"%@", reqDic[@"timestamp"]];
    req.timeStamp           = (UInt32)[timestamp_string integerValue];
    
    req.package             = reqDic[@"package"];
    req.sign                = reqDic[@"sign"];
    
    [WXApi sendReq:req];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        
    }
    else if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess: {
                !self.onRespCallBack ? : self.onRespCallBack(JXWechatPaySuccess, resp.errStr);
            } break;
                
            case WXErrCodeUserCancel: {
                NSString *msg = resp.errStr;
                if (msg.length == 0) {
                    msg = @"支付取消";
                }
                !self.onRespCallBack ? : self.onRespCallBack(JXWechatPayUserCancel, msg);
            } break;
                
            default: {
                !self.onRespCallBack ? : self.onRespCallBack(JXWechatPayFailure, resp.errStr);
            } break;
        }
    }
    self.onRespCallBack = nil;
}

@end

#undef JX_BLOCK_EXEC

#if 0
// 微信支付结果
    WXSuccess           = 0,    //成功
    WXErrCodeCommon     = -1,   //普通错误类型
    WXErrCodeUserCancel = -2,   //用户点击取消并返回
    WXErrCodeSentFail   = -3,   //发送失败
    WXErrCodeAuthDeny   = -4,   //授权失败
    WXErrCodeUnsupport  = -5,   //微信不支持

// 微信发起支付参数
    noncestr = 81d7118d88d5575609ace943bd14f142;
    package = "Sign=WXPay";
    partnerid = 1408978423;
    prepayid = wx20161017162556f9292895e80815037713;
    sign = 8FDED5E9221AB1AIYGB9F93FBA69848;
    timestamp = 1476692758;
#endif
















