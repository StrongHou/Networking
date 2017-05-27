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

@interface ViewController () <MIAPIManagerCallBackDelegate, MIAPIManagerParamDataSource>
@property (nonatomic, strong) MITestManager *testManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    [self.testManager callApi];

}



#pragma mark - 

- (void)managerCallAPIDidSuccess:(MIAPIBaseManager *)manager
{
    
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

@end
