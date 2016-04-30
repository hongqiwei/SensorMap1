//
//  EditAnnotationViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAnnotationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *roadNameLable;
@property (weak, nonatomic) IBOutlet UITextView *sensorLable;

- (IBAction)saveButton:(id)sender;

@end
