//
//  ViewController.m
//  MINetWorking
//
//  Created by houxq on 2017/5/25.
//  Copyright © 2017年 MI. All rights reserved.
//

#import "ViewController.h"
#import "MIApiProxy.h"
#import "MITestManager.h"

@interface ViewController () <MIAPIManagerCallBackDelegate, MIAPIManagerParamDataSource,UIWebViewDelegate>
@property (nonatomic, strong) MITestManager *testManager;
@property (nonatomic, strong) UIWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSArray *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    [self.view addSubview:self.webView];
    
//    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
//     NSLog(@"%@",cookies);
    
    [self.testManager callApi];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  

}



#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
//    NSArray *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    
//  
//    
//    
//    for(NSHTTPCookie *cookie in cookies){
//    
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
//    
//    NSArray *cookies1=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    
//    NSLog(@"%@",cookies1);
    
    return YES;

}


#pragma mark - 

- (void)managerCallAPIDidSuccess:(MIAPIBaseManager *)manager
{
    NSArray *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    NSLog(@"%@",cookies);
    




}


- (void)managerCallAPIDidFailure:(MIAPIBaseManager *)manager
{
    
}

- (NSDictionary *)paramsForManger:(MIAPIBaseManager *)manager
{
     return  @{@"function":@"10099"};

}

#pragma mark -

- (MITestManager *)testManager
{
    if(_testManager == nil){
        _testManager = [[MITestManager alloc] init];
        _testManager.paramDataSource = self;
        _testManager.delegate = self;
    }
    return _testManager;
}

- (UIWebView *)webView
{
    if(_webView == nil){
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.frame = self.view.bounds;
        _webView.backgroundColor = [UIColor whiteColor];
        
    }
    return _webView;
}

@end
