//
//  JXWechatPayManager.m
//  JXWechatPay
//
//  Created by shiba_iosJX on 3/30/16.
//  Copyright © 2016 shiba_iosJX. All rights reserved.
//

#import "JXWechatPayManager.h"

@interface JXWechatPayManager () <WXApiDelegate>

@property (nonatomic, copy) JXBlockWechatPayResult blockPayResult;

@end

static JXWechatPayManager *_singleton;

@implementation JXWechatPayManager

+ (JXWechatPayManager *)shareManager {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{ _singleton = [[self alloc] init]; });
    return _singleton;
}

- (BOOL)jx_registerApp:(NSString *)appid withDescription:(NSString *)appdesc {
    return [WXApi registerApp:appid withDescription:appdesc];
}

- (BOOL)jx_handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)jx_payWechat:(PayReq *)payReq callBack:(JXBlockWechatPayResult)blockPayResult {
    _blockPayResult = blockPayResult;
    if (![WXApi isWXAppInstalled]) {
        if (self.blockPayResult) { self.blockPayResult(JXWechatPayNoAppInstalled); }
    }
    else {
        [WXApi sendReq:payReq];
    }
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
                if (self.blockPayResult) { self.blockPayResult(JXWechatPaySuccess); }
            } break;
                
            case WXErrCodeUserCancel: {
                if (self.blockPayResult) { self.blockPayResult(JXWechatPayUserCancel); }
            } break;
                
            default: {
                if (self.blockPayResult) { self.blockPayResult(JXWechatPayFailure); }
            } break;
        }
    }
    self.blockPayResult = nil;
}

@end









