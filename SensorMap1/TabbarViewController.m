//
//  TabbarViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/3.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "TabbarViewController.h"
#import "IsLoginViewController.h"

@interface TabbarViewController()  <UITabBarControllerDelegate>

@end

@implementation TabbarViewController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    NSLog(@"--tabbaritem.title--%@",viewController.tabBarItem.title);
    
    //这里我判断的是当前点击的tabBarItem的标题
    if ([viewController.tabBarItem.title isEqualToString:@"我的账户"]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tmp = [defaults stringForKey:@"access_token"];
        NSLog(@"accesstoken:%@",tmp);
        if (tmp != NULL) {
//            [self performSegueWithIdentifier:@"isLogin" sender:self];
//            
//            IsLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IsLoginVC"];
//            [((UINavigationController *)tabBarController.selectedViewController)
//             pushViewController:vc animated:YES];
            
            return NO;
        }
        
    }
    
    return YES;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}


@end
