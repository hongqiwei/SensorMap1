//
//  ShouldLoginViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, JxbLoginShowType) {
    JxbLoginShowType_NONE,
    JxbLoginShowType_USER,
    JxbLoginShowType_PASS
};

@interface ShouldLoginViewController : UIViewController

- (IBAction)touchView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)clickLogin:(id)sender;
- (IBAction)clickRegister:(id)sender;

@property (nonatomic)NSString  *access_token;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@end
