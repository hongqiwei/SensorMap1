//
//  IsLoginViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/2.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "IsLoginViewController.h"

@implementation IsLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidLoad{
    self.head_Icon.layer.cornerRadius = 5;
    self.head_Icon.layer.borderWidth = 1;
    //UIColor(red:0.25, green:0.63, blue:0.75, alpha:1.00)
    self.head_Icon.layer.borderColor = [[UIColor colorWithRed:0.25 green:0.63 blue:0.75 alpha:0.8]CGColor];
}

- (IBAction)quit:(id)sender {
    [self performSegueWithIdentifier:@"quit" sender:self];
}
@end
