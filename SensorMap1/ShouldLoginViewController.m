//
//  ShouldLoginViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "ShouldLoginViewController.h"
#import "LoginService.h"
#import "RegisterService.h"
#import "MozTopAlertView.h"

#define mainSize    [UIScreen mainScreen].bounds.size

#define offsetLeftHand      60

#define rectLeftHand        CGRectMake(61-offsetLeftHand, 90, 40, 65)
#define rectLeftHandGone    CGRectMake(mainSize.width / 2 - 100, vLogin.frame.origin.y - 22, 40, 40)

#define rectRightHand       CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)
#define rectRightHandGone   CGRectMake(mainSize.width / 2 + 62, vLogin.frame.origin.y - 22, 40, 40)

@interface ShouldLoginViewController ()<UITextFieldDelegate>
{
    UITextField* txtUser;
    UITextField* txtPwd;
    
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    UIImageView* imgLeftHandGone;
    UIImageView* imgRightHandGone;
    
    JxbLoginShowType showType;
}

@end

@implementation ShouldLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 211 / 2, 100, 211, 109)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    imgLeftHand = [[UIImageView alloc] initWithFrame:rectLeftHand];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:rectRightHand];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(15, 200, mainSize.width - 30, 160)];
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vLogin.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vLogin];
    
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:rectLeftHandGone];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgLeftHandGone];
    
    imgRightHandGone = [[UIImageView alloc] initWithFrame:rectRightHandGone];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgRightHandGone];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, vLogin.frame.size.width - 60, 44)];
    txtUser.delegate = self;
    txtUser.layer.cornerRadius = 5;
    txtUser.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtUser.layer.borderWidth = 0.5;
    txtUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    txtUser.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [txtUser.leftView addSubview:imgUser];
    [vLogin addSubview:txtUser];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(30, 90, vLogin.frame.size.width - 60, 44)];
    txtPwd.delegate = self;
    txtPwd.layer.cornerRadius = 5;
    txtPwd.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtPwd.layer.borderWidth = 0.5;
    txtPwd.secureTextEntry = YES;
    txtPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [txtPwd.leftView addSubview:imgPwd];
    [vLogin addSubview:txtPwd];
    
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.borderColor =[[UIColor colorWithRed:0.51 green:0.24 blue:0.16 alpha:1]CGColor];
    
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.borderColor =[[UIColor colorWithRed:0.51 green:0.24 blue:0.16 alpha:1]CGColor];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txtUser]) {
        if (showType != JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_USER;
            return;
        }
        showType = JxbLoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
            
            
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:txtPwd]) {
        if (showType == JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_PASS;
            return;
        }
        showType = JxbLoginShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
            
        } completion:^(BOOL b) {
        }];
    }
}



- (IBAction)clickLogin:(id)sender {
    
    [self.loading startAnimating];
    
    NSString *username = txtUser.text;
    NSString *password = txtPwd.text;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue,^{
        NSError *error = nil;
        bool isLoginSucessed = [LoginService loginByUserName:username
                                                 AndPassword:password
                                                       error:&error];
        if(error){
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络或服务器错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.loading stopAnimating];
                
                if(isLoginSucessed){
                    //[self performSegueWithIdentifier:@"shouldLogin" sender:self];
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"login sucessed");
                }else{
                    
                    NSLog(@"login failed");
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alter show];
                }
            });
        }
    });
    
    
}

- (IBAction)clickRegister:(id)sender {
    
    [self.loading startAnimating];
    
    NSString *username = txtUser.text;
    NSString *password = txtPwd.text;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue,^{
        NSError *error = nil;
        bool isRegisterSucessed = [RegisterService registerByUserName:username
                                                          AndPassword:password
                                                                error:&error];
        if(error){
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络或服务器错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(isRegisterSucessed){
                    
                    if (YES) {
                        MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"注册成功，请点击登录" parentView:self.view];
                        alertView.dismissBlock = ^(){
                            NSLog(@"dismissBlock");
                        };
                    }
                    
                    [self.loading stopAnimating];
                    NSLog(@"register sucessed");
                }else{
                    NSLog(@"register failed");
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alter show];
                }
            });
        }
    });
    
}


//点击屏幕其他地方隐藏键盘
- (IBAction)touchView:(id)sender {
    [self.view endEditing:YES];
}
@end
