//
//  DetailViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *sensorUIView;
@property (weak, nonatomic) IBOutlet UIView *mileageUIView;
@property (weak, nonatomic) IBOutlet UIView *aSpeedUIView;
@property (weak, nonatomic) IBOutlet UIView *timeUIView;
@property (weak, nonatomic) IBOutlet UIView *altUIView;
@property (weak, nonatomic) IBOutlet UILabel *sensorLable;
@property (weak, nonatomic) IBOutlet UILabel *mileageLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *aSpeedLable;
@property (weak, nonatomic) IBOutlet UILabel *aAltLable;

@end
