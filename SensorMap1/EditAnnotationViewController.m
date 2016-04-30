//
//  EditAnnotationViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "EditAnnotationViewController.h"
#import "HistoryViewController.h"
#import "DetailViewController.h"
#import "DBManager.h"

@interface EditAnnotationViewController()

@property (strong,nonatomic)DBManager *dbManager;

@end

@implementation EditAnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"myDB.sqlite"];
    [self.dbManager createTable];
    
    HistoryViewController *historyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    
    NSString *title = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0]objectAtIndex:1]];
    NSString *subtitle = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0]objectAtIndex:8]];
    
    self.roadNameLable.text = title;
    self.sensorLable.text = subtitle;
    
}

- (IBAction)saveButton:(id)sender {
    
    NSString *tmp1 = self.roadNameLable.text;
    NSString *tmp2 = self.sensorLable.text;
    
    HistoryViewController *historyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    NSString *tmp3 = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0]objectAtIndex:0]];
    
    NSString *query;
    query = [NSString stringWithFormat:@"update roadData set roadname = '%@',sensorData = '%@' where roadInfoID=%@",tmp1,tmp2,tmp3];
    [self.dbManager executeQuery:query];
    
     DetailViewController *detailVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    detailVC.aTitle = tmp1;
    detailVC.aSubTitle = tmp2;
    
    [detailVC resetAnnotation];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
