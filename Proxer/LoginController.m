//
//  LoginController.m
//  Proxer
//
//  Created by Jens Koenning on 29.03.18.
//  Copyright © 2018 Jens Koenning. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    AFHTTPSessionManager *loginManager = [[AFHTTPSessionManager alloc]init];
    loginManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    loginManager.responseSerializer.acceptableContentTypes=[loginManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *loginURL = @"https://proxer.me/login";
    NSDictionary *loginParams=@{
                                @"username":self.userNameTextField.text,
                                @"password":self.passwordTextField.text,
                                @"submit":@"Login"
                                };
    
    [loginManager POST:loginURL parameters:loginParams progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"Login successfull. Data: %@",responseObject);
                    NSString *userData = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
                    NSLog(@"");
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error while Login.Error: %@",error);
                }];
    
    
    
}


@end
