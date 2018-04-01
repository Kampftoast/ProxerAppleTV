//
//  LoginController.h
//  Proxer
//
//  Created by Jens Koenning on 29.03.18.
//  Copyright © 2018 Jens Koenning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "TabBarController.h"

@interface LoginController : UIViewController

//UI

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *secretKeyTextField;


@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;

//var

@property (nonatomic)NSString *passwordInStore;



@end
