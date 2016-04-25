//
//  MeasureViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/11.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface MeasureViewController : UIViewController<MZTimerLabelDelegate>{
    MZTimerLabel *measureTime;
}
@property (weak, nonatomic) IBOutlet UILabel *roadNameLable;

@property (weak, nonatomic) IBOutlet UILabel *timerLable1;

@property (weak, nonatomic) IBOutlet UIButton *StartOrRusumeButton;

@property (weak, nonatomic) IBOutlet UIButton *ResetButton;


- (IBAction)startOrResumeStopwatch:(id)sender;
- (IBAction)resetStopWatch:(id)sender;
- (IBAction)markButtom:(id)sender;

@property (strong,nonatomic) NSString *aTitle1;
@property (strong,nonatomic) NSString *aSubTitle1;
//测量数据数组
@property (strong,nonatomic) NSMutableArray *dataDetailArray;
-(void)setAnnotation;
-(void)drawLine;
@property (weak, nonatomic) IBOutlet UIView *sensorUIView;
@property (weak, nonatomic) IBOutlet UIView *mileageUIView;
@property (weak, nonatomic) IBOutlet UIView *speedUIView;
@property (weak, nonatomic) IBOutlet UIView *aSpeedUIView;
@property (weak, nonatomic) IBOutlet UIView *altUIView;
@property (weak, nonatomic) IBOutlet UIView *spareUIView;

@end
