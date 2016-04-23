//
//  AddAnnotationViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import "MeasureViewController.h"
#import "DBManager.h"

@interface AddAnnotationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *saveButton1;
@property (weak, nonatomic) IBOutlet UITextField *annotionTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *annotionSubTitleTextView;
@property (strong,nonatomic) NSString *roadName;
@property (strong,nonatomic) NSNumber *roadData;
- (IBAction)saveButton1:(id)sender;

@end
