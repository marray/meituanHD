//
//  MTDetailViewController.m
//  美团HD
//
//  Created by apple on 14/11/27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDetailViewController.h"
#import "MTDeal.h"
#import "DPAPI.h"
#import "MTConst.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "MTRestrictions.h"
#import "MTDealTool.h"
#import "AlixLibService.h"
#import "AlixPayOrder.h"
#import "DataSigner.h"
#import "PartnerConfig.h"

@interface MTDetailViewController () <UIWebViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
- (IBAction)back;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
- (IBAction)buy;
- (IBAction)collect;
- (IBAction)share;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@end

// ShareSDK
// 友盟分享
// 百度分享

@implementation MTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 打开了一个团购 --> 访问了这个团购 ---> 增加到最近访问记录
//    [MTDealTool addRec];
    
    // 基本设置
    self.view.backgroundColor = MTGlobalBg;
    
    // 加载网页
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    
    // 设置基本信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    
    // 设置剩余时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];
    // 追加1天
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];
    NSDate *now = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:dead options:0];
    if (cmps.day > 365) {
        [self.leftTimeButton setTitle:@"一年内不过期" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"%d天%d小时%d分钟", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    
    // 发送请求获得更详细的团购数据
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 页码
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    // 设置收藏状态
    self.collectButton.selected = [MTDealTool isCollected:self.deal];
}

/**
 *  返回控制器支持的方向
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.deal = [MTDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    // 设置退款信息
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.deal.restrictions.is_refundable;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络繁忙,请稍后再试" toView:self.view];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        // 旧的HTML5页面加载完毕
        NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
        NSString *urlStr = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    } else { // 详情页面加载完毕
        // 用来拼接所有的JS
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 利用webView执行JS
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        // 获得页面
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
        // 显示webView
        webView.hidden = NO;
        // 隐藏正在加载
        [self.loadingView stopAnimating];
    }
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.deal.deal_url]];
    // 1.生成订单信息
    // 订单信息 == order == [order description]
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.productName = self.deal.title;
    order.productDescription = self.deal.desc;
    order.partner = PartnerID;
    order.seller = SellerID;
    order.amount = [self.deal.current_price description];
    
    // 2.签名加密
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    // 签名信息 == signedString
    NSString *signedString = [signer signString:[order description]];
    
    // 3.利用订单信息、签名信息、签名类型生成一个订单字符串
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             [order description], signedString, @"RSA"];
    
    // 4.打开客户端,进行支付(商品名称,商品价格,商户信息)
    [AlixLibService payOrder:orderString AndScheme:@"tuangou" seletor:@selector(getResult:) target:self];
}

- (void)getResult:(NSString *)result
{
    
}

- (IBAction)collect {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MTCollectDealKey] = self.deal;
    
    if (self.collectButton.isSelected) { // 取消收藏
        [MTDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        
        info[MTIsCollectKey] = @NO;
    } else { // 收藏
        [MTDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        
        info[MTIsCollectKey] = @YES;
    }
    
    // 按钮的选中取反
    self.collectButton.selected = !self.collectButton.isSelected;
    
    // 发出通知
    [MTNotificationCenter postNotificationName:MTCollectStateDidChangeNotification object:nil userInfo:info];
}

- (IBAction)share {
    
}
@end
