//
//  AddAnnotationViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "AddAnnotationViewController.h"
#import "DBManager.h"

@interface AddAnnotationViewController()

@property (strong,nonatomic)DBManager *dbManager;

@end

@implementation AddAnnotationViewController

- (void)viewDidLoad{
    
    //初始化dbManager
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"myDB.sqlite"];
    
    self.annotionTitleTextField.text = [[NSString alloc] initWithFormat:@"%@",self.roadName];
    NSLog(@"返回值：%@",self.roadName);
    self.annotionSubTitleTextView.text = [[NSString alloc] initWithFormat:@"%@",self.roadData];
    
//    //设置输入框代理，点完成来隐藏键盘
//    _annotionTitleTextField.delegate = self;
//    _annotionSubTitleTextView.delegate = self;
}

- (IBAction)saveButton1:(id)sender{
    
//    NSString *query = [NSString stringWithFormat:@"insert into basicData values('%@',null,'%@')",self.annotionTitleTextField.text,self.annotionSubTitleTextView.text];
//    [self.dbManager insterRecord:query];
    
    //获取系统时间(和北京时间有八个小时的时差);
    NSDate *date = [NSDate date];
    //设置转换后的目标日期时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSLog(@"interval = %lu", (long)interval);
    //在当前时间基础上追加时区差值
    date = [date dateByAddingTimeInterval:interval];
    NSLog(@"%@", date);
    
    NSString *query;
    query = [NSString stringWithFormat:@"insert into roadData values(null, '%@', '%@', %@)", self.annotionTitleTextField.text, date, self.annotionSubTitleTextView.text];
    //执行sql语句
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    MeasureViewController *measureVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    measureVC.aTitle1 = [[NSString alloc]initWithFormat:@"%@",self.annotionTitleTextField.text];
    measureVC.aSubTitle1 = [[NSString alloc]initWithFormat:@"%@",self.annotionSubTitleTextView.text];
    NSLog(@"测试标题：%@",measureVC.aTitle1);
    NSLog(@"测试副标题：%@",measureVC.aSubTitle1);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [measureVC setAnnotation];
    [measureVC drawLine];

}

////多页面传属性
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if([segue.identifier isEqualToString:@"saveBiaoZhu"]){
//        
//        MeasureViewController *measureVC = (MeasureViewController *)[segue destinationViewController];
//        measureVC.aTitle1 = [[NSString alloc] initWithFormat:@"%@",self.annotionTitleTextField.text];
//        measureVC.aSubTitle1 = [[NSString alloc] initWithFormat:@"%@",self.annotionSubTitleTextView.text];
//        
//    }else if([segue.identifier isEqualToString:@""]){
//        
//    }
//}


@end

