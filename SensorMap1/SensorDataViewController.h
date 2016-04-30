//
//  SensorDataViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/27.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SensorDataViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *chart1;
@property (weak, nonatomic) IBOutlet UIView *chart2;
@property (weak, nonatomic) IBOutlet UIView *chart3;
@property (weak, nonatomic) IBOutlet UIView *chart4;
@property (weak, nonatomic) IBOutlet UIView *chart5;

@end
