//
//  ViewController.m
//  JXWechatPay
//
//  Created by shiba_iosJX on 3/30/16.
//  Copyright © 2016 shiba_iosJX. All rights reserved.
//

#import "ViewController.h"
#import "JXWechatPayManager.h"

@interface ViewController ()

- (IBAction)btnWechatPayClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnWechatPayClick:(id)sender {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *error;
            NSDictionary *dicPay = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if(dicPay) {
                NSMutableString *retcode = [dicPay objectForKey:@"retcode"];
                if (retcode.intValue == 0) {
                    
                    //以上所有代码为得到支付的以下6个参数(实际开发由后台生成)
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dicPay objectForKey:@"partnerid"];
                    req.prepayId            = [dicPay objectForKey:@"prepayid"];
                    req.nonceStr            = [dicPay objectForKey:@"noncestr"];
                    req.timeStamp           = [[dicPay objectForKey:@"timestamp"] intValue];
                    req.package             = [dicPay objectForKey:@"package"];
                    req.sign                = [dicPay objectForKey:@"sign"];
                    
                    //支付只要调起这个方法即可
                    [[JXWechatPayManager shareManager] jx_payWechat:req callBack:^(JXWechatPayResult result) {
                        switch (result) {
                            case JXWechatPaySuccess:
                            {
                                NSLog(@"支付成功");
                            } break;
                                
                            case JXWechatPayNoAppInstalled:
                            {
                                NSLog(@"未安装微信");
                            } break;
                                
                            case JXWechatPayUserCancel:
                            {
                                NSLog(@"取消支付");
                            } break;
                                
                            case JXWechatPayFailure:
                            default:
                            {
                                NSLog(@"支付失败");
                            } break;
                        }
                    }];
                    
                    //调试日志
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",
                          [dicPay objectForKey:@"appid"],
                          req.partnerId,
                          req.prepayId,
                          req.nonceStr,
                          (long)req.timeStamp,
                          req.package,
                          req.sign );
                }
                else {
                    
                }
            }
            else {
                
            }
        }
    }] resume];
}


@end
