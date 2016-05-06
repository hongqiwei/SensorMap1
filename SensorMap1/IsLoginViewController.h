//
//  IsLoginViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/2.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IsLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *head_Icon;

@property (weak, nonatomic) IBOutlet UIButton *quitButton;
- (IBAction)quit:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *shareTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (nonatomic) int time;

@end
