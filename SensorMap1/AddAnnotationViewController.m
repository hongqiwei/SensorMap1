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

@property(nonatomic)float aAlt;

@end

@implementation AddAnnotationViewController

- (void)viewDidLoad{
    
    //初始化dbManager
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"myDB.sqlite"];
    [self.dbManager createTable];
    
    self.annotionTitleTextField.text = [[NSString alloc] initWithFormat:@"%@",self.roadName];
    NSLog(@"返回值：%@",self.roadName);
    self.annotionSubTitleTextView.text = [[NSString alloc] initWithFormat:@"%@",self.roadData];
    
//    //设置输入框代理，点完成来隐藏键盘
//    _annotionTitleTextField.delegate = self;
//    _annotionSubTitleTextView.delegate = self;
}

- (IBAction)saveButton1:(id)sender{
    
    MeasureViewController *measureVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
//    //设置转换后的目标日期时区
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSLog(@"interval = %lu", (long)interval);
//    //在当前时间基础上追加时区差值
//    date = [date dateByAddingTimeInterval:interval];
//    NSLog(@"%@", date);
    
    NSDate *ymd = [NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date=[formatter stringFromDate:ymd];
    NSLog(@"修改的时间格式是：%@", date);
    
    NSTimeInterval sjc = [[NSDate date] timeIntervalSince1970] ;
    
    //roadInfoID integer, roadname text, datetime text, info text,duration integer,sumDistance text,aAlt folat,aSpeed float,sensorData text
    for (int x=0; x<measureVC.dataDetailArray.count; x++) {
        NSNumber *tmp= [[measureVC.dataDetailArray objectAtIndex:x]objectAtIndex:4];
        self.aAlt= [tmp floatValue] + self.aAlt;
    }
    
    int a = 666;
    NSString *query;
    query = [NSString stringWithFormat:@"insert into roadData values(%.3f, '%@', '%@', %@, %d, %.2f, %.2f,%.2f,%d)",sjc, self.annotionTitleTextField.text, date, self.annotionSubTitleTextView.text,measureVC.timeInterval,measureVC.sumDistance,self.aAlt/measureVC.timeInterval,measureVC.avgSpeed,a];
    //执行sql语句
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    
    
    measureVC.aTitle1 = [[NSString alloc]initWithFormat:@"%@",self.annotionTitleTextField.text];
    measureVC.aSubTitle1 = [[NSString alloc]initWithFormat:@"%@",self.annotionSubTitleTextView.text];
    NSLog(@"测试标题：%@",measureVC.aTitle1);
    NSLog(@"测试副标题：%@",measureVC.aSubTitle1);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [measureVC setAnnotation];
    [measureVC drawLine];
    
    //roadInfoID integer,secID integer primary key,lat text,lng text,speed text,altitude text,sensordata text
    //secID,lat1,log1,speed,alt,nil
    NSString *query1;
    for (int a=0; a<measureVC.dataDetailArray.count-1; a++) {
        NSString *secIdTMP = [[NSString alloc]initWithFormat:@"%@",[[measureVC.dataDetailArray objectAtIndex:a]objectAtIndex:0]];
        NSString *latTMP = [[NSString alloc]initWithFormat:@"%@",[[measureVC.dataDetailArray objectAtIndex:a]objectAtIndex:1]];
        NSString *lngTMP = [[NSString alloc]initWithFormat:@"%@",[[measureVC.dataDetailArray objectAtIndex:a]objectAtIndex:2]];
        NSString *speedTMP = [[NSString alloc]initWithFormat:@"%@",[[measureVC.dataDetailArray objectAtIndex:a]objectAtIndex:3]];
        NSString *altTMP = [[NSString alloc]initWithFormat:@"%@",[[measureVC.dataDetailArray objectAtIndex:a]objectAtIndex:4]];
        
        query1 = [NSString stringWithFormat:@"insert into dataDetail values(%.3f,'%@','%@','%@','%@','%@',null)",sjc,secIdTMP,latTMP,lngTMP,speedTMP,altTMP];
        //执行sql语句
        [self.dbManager executeQuery:query1];
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query1 was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query1.");
        }
    }
    

}




@end

