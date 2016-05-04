//
//  NavigationViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController()  <UINavigationControllerDelegate>

@end

@implementation NavigationViewController

-(void)viewDidLoad{
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tmp = [defaults stringForKey:@"access_token"];
        NSLog(@"accesstoken:%@",tmp);
        if (tmp != NULL) {
    
            [self performSegueWithIdentifier:@"isLogin" sender:self];
    
          
        }
    
}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *tmp = [defaults stringForKey:@"access_token"];
//    NSLog(@"accesstoken:%@",tmp);
//    if (tmp != NULL) {
// 
//        [self performSegueWithIdentifier:@"isLogin" sender:self];
//        
//      
//    }
//
//}

@end
