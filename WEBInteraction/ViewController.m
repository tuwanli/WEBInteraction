//
//  ViewController.m
//  WEBInteraction
//
//  Created by 涂婉丽 on 16/7/13.
//  Copyright © 2016年 涂婉丽. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_bridge) {
        return;
    }
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _webView.scrollView.scrollEnabled = YES;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        [self handleResult:data];
        responseCallback(@"success");
    }];
    
//        [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//            NSLog(@"testObjcCallback called: %@", data);
//            responseCallback(@"Response from testObjcCallback");
//        }];
//    
//        [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
//            NSLog(@"objc got response! %@", responseData);
//        }];
//    
//        [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
        [self renderButtons:_webView];
        [self loadExamplePage:_webView];
    
}
- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [messageButton setTitle:@"Send message" forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:messageButton aboveSubview:webView];
    messageButton.frame = CGRectMake(10, 414, 100, 35);
    messageButton.titleLabel.font = font;
    messageButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];

    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(110, 414, 100, 35);
    callbackButton.titleLabel.font = font;

    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(210, 414, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)sendMessage:(id)sender {
    [_bridge send:@"1111111" responseCallback:^(id response) {
        NSLog(@"222222: %@", response);
    }];
}

- (void)callHandler:(id)sender {
    id data = @{ @"33333": @"4554554554" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler 33333 responded: %@", response);
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}
- (void)handleResult:(id)data
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
