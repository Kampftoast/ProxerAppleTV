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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
  
    [self loadPasswordFromKeystore];
    
}

- (void) loadPasswordFromKeystore
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userNameTextField.text = [defaults objectForKey:@"username"];
    self.passwordTextField.text = [defaults objectForKey:@"password"];
    self.secretKeyTextField.text = [defaults objectForKey:@"secretKey"];
}

-(void) storePasswordToKeychain:(NSString *)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.passwordInStore = [defaults objectForKey:@"passsword"];
    if ([self.passwordInStore isEqualToString:password])
        return;
    [defaults setObject:self.userNameTextField.text forKey:@"username"];
    [defaults setObject:self.passwordTextField.text forKey:@"password"];
    [defaults setObject:self.secretKeyTextField.text forKey:@"secretKey"];
    [defaults setObject:@"yes" forKey:@"dataSet"];
    [defaults synchronize];
    
}

-(void)askStorePassword{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login"
                                                                   message:@"Soll das Passwort gespeichert werden?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Ja" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                            [self storePasswordToKeychain:self.passwordTextField.text];
                                                               [self loadStartPage];
                                                          }];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Nein" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {  [self loadStartPage];}];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton_pressed:(id)sender {
    
    AFHTTPSessionManager *loginManager = [[AFHTTPSessionManager alloc]init];
    loginManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    loginManager.responseSerializer.acceptableContentTypes=[loginManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *loginURL = @"https://proxer.me/login";
    NSDictionary *loginParams=@{
                                @"username":self.userNameTextField.text,
                                @"password":self.passwordTextField.text,
                                @"secretkey":self.secretKeyTextField.text,
                                @"submit":@"Login"
                                };
    
    [loginManager POST:loginURL parameters:loginParams progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"Login successfull. Data: %@",responseObject);
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *dataSet = [defaults objectForKey:@"dataSet"];
                    if(!dataSet){
                    [self askStorePassword];
                    }
                    //TODO: failure block doesnt exec on wrong login. Fix with api
                    
                    NSString *userData = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
                    NSLog(@"");
                    [self loadStartPage];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error while Login.Error: %@",error);
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults removeObjectForKey:@"username"];
                    [defaults removeObjectForKey:@"password"];
                    [defaults removeObjectForKey:@"secretKey"];
                    [defaults removeObjectForKey:@"dataSet"];
                    
                    
                }];
}
- (IBAction)skipButton_pressed:(id)sender {
    [self loadStartPage];
}

-(void)loadStartPage{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [self.navigationController pushViewController:tabBar animated:true];
}


@end
