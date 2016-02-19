//
//  ViewController.m
//  Apple pay
//
//  Created by chedao on 16/2/19.
//  Copyright © 2016年 chedao. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];


    

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //apple pay 支持iphone6以上的设备
    [self ApplePay];

}



-(void)ApplePay{

    //判断手机是否支持Apple Pay
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        PKPaymentSummaryItem *widget = [PKPaymentSummaryItem summaryItemWithLabel:@"鸡蛋" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        PKPaymentSummaryItem *allMoney = [PKPaymentSummaryItem summaryItemWithLabel:@"总金额" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"] type:PKPaymentSummaryItemTypeFinal];
        request.paymentSummaryItems = @[widget,allMoney];
        
        request.countryCode = @"CN";
        request.currencyCode = @"CHW";
        //限制支付卡变类型 PKPaymentNetworkChinaUnionPay:中国银联卡
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa,PKPaymentNetworkMasterCard];
        request.merchantIdentifier = @"merchant.com.chedao.Applepay";
        /*
         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   // 支持信用卡
         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    // 支持借记卡
         */
        //支持的卡片类型
        request.merchantCapabilities = PKMerchantCapabilityDebit;
        //增加邮箱地址信息 可不填
//        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        PKPaymentAuthorizationViewController *paymentPant = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPant.delegate = self;
        
        
        if (!paymentPant) {
            NSLog(@"支付出了问题");
            //如果没有绑定银行卡就会出现崩溃的 paymentpant为nil 会崩
            return;
        }
        [self presentViewController:paymentPant animated:YES completion:nil];
        
    }else{
    
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持Apple pay支付" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持Apple pay支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
//        [alert show];

    }


}
#pragma  mark ==== 支付状态
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{

    NSLog(@"payment was authorized:%@",payment);
    BOOL asycSuccessful = FALSE;
    if (asycSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        NSLog(@"支付成功");
        
    }else{
        completion(PKPaymentAuthorizationStatusFailure);
        NSLog(@"支付失败");
        
    }
    
    
    
}
-(void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller
{}
#pragma mark ==== 支付完成
-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
