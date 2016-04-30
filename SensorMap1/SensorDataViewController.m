//
//  SensorDataViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/27.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "SensorDataViewController.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "DetailViewController.h"
#import "UIColor+Hex.h"

@interface SensorDataViewController () <DVLineChartViewDelegate>

@property (nonatomic,strong) NSMutableArray  *arrayData;
@property (nonatomic,strong) NSMutableArray *arraySec;
@property (nonatomic) CGFloat maxY;

@end

@implementation SensorDataViewController


- (void)viewDidLoad {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = [[SensorDataViewController alloc] init];
    
    [super viewDidLoad];
    //self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#D72C37"];//#FFFFFF
    
    
#pragma 加速计数据图表
    DVLineChartView *sensor = [[DVLineChartView alloc] init];
    //NegativeLineChart *sensor = [[NegativeLineChart alloc]init];
    [self.chart1 addSubview:sensor];
    
    //
    self.scrollView.contentSize =CGSizeMake(0, 4000);
    //self.view.frame.size;
    //sensor.bounds.size;
    
    sensor.width = self.view.width;
    
    sensor.yAxisViewWidth = 52;
    
    sensor.numberOfYAxisElements = 5;
    
    sensor.delegate = self;
    sensor.pointUserInteractionEnabled = YES;
    
    DetailViewController *detailVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    self.maxY=0;
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSNumber *tmp = [[detailVC.detailArray objectAtIndex:n]objectAtIndex:6];
        if (self.maxY<[tmp floatValue]) {
            self.maxY = [tmp floatValue];
        }
    }
    
    if (self.maxY<=0) {
        sensor.yAxisMaxValue = 5;
    }else{
        //sensor.yAxisMaxValue = ceilf(self.maxY*1.2);//pow(2, 3)
        sensor.yAxisMaxValue = ceil(pow((self.maxY+1), 2)*1.2);
    }
    
    NSLog(@"yAxisMaxValue:%f",sensor.yAxisMaxValue);
    
    sensor.pointGap = 50;
    
    sensor.showSeparate = YES;
    sensor.separateColor = [UIColor colorWithHexString:@"#303239"];//colorWithHexString:@"67707c"
    
    sensor.textColor = [UIColor colorWithHexString:@"#303239"];//colorWithHexString:@"9aafc1"
    sensor.backColor = [UIColor colorWithHexString:@"#FFFFFF"];//colorWithHexString:@"3e4a59"
    sensor.axisColor = [UIColor colorWithHexString:@"#303239"];//colorWithHexString:@"67707c"
    
    NSLog(@"detailVC.detailArray:%@",detailVC.detailArray);
    
    self.arraySec = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *xtmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:1]];
        
        [self.arraySec addObject:xtmp];
    }
    
    NSLog(@"self.arraySec:%@",self.arraySec);
    
    sensor.xAxisTitleArray=self.arraySec;
    
    NSLog(@"xAxisTitleArray:%@",sensor.xAxisTitleArray);
    
    sensor.x = 0;
    sensor.y = 100;
    sensor.width = self.view.width;
    sensor.height = 300;
    
    DVPlot *plot = [[DVPlot alloc] init];
    
    self.arrayData = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *ptmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:6]];
        NSString  *ptmp1  = [[NSString alloc]initWithFormat:@"%f",pow([ptmp doubleValue]+1, 2)] ;
        
        [self.arrayData addObject:ptmp1];
    }
    
    NSLog(@"self.arrayData:%@",self.arrayData);
    
    plot.pointArray  = self.arrayData;
    NSLog(@"pointArray:%@",plot.pointArray);
    
    plot.lineColor = [UIColor colorWithHexString:@"#5DCDD7"];//colorWithHexString:@"2f7184"
    plot.pointColor = [UIColor colorWithHexString:@"#41A1C0"];//colorWithHexString:@"14b9d6"
    plot.chartViewFill = YES;
    plot.withPoint = YES;
    
    [sensor addPlot:plot];
    //    [ccc addPlot:plot1];
    [sensor draw];
    
    
    
#pragma 海拔数据图表
    DVLineChartView *altitude = [[DVLineChartView alloc] init];
    
    [self.chart2 addSubview:altitude];
    
    NSLog(@"with:%f height:%f",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
    
    altitude.width = self.view.width;
    
    altitude.yAxisViewWidth = 52;
    
    altitude.numberOfYAxisElements = 5;
    
    altitude.delegate = self;
    altitude.pointUserInteractionEnabled = YES;
    
    self.maxY=0;
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSNumber *tmp = [[detailVC.detailArray objectAtIndex:n]objectAtIndex:5];
        if (self.maxY<[tmp floatValue]) {
            self.maxY = [tmp floatValue];
        }
    }
    
    altitude.yAxisMaxValue = ceilf(self.maxY*1.2);
    NSLog(@"yAxisMaxValue:%f",altitude.yAxisMaxValue);
    
    altitude.pointGap = 50;
    
    altitude.showSeparate = YES;
    altitude.separateColor = [UIColor colorWithHexString:@"#303239"];
    
    altitude.textColor = [UIColor colorWithHexString:@"#303239"];
    altitude.backColor = [UIColor colorWithHexString:@"#FFFFFF"];
    altitude.axisColor = [UIColor colorWithHexString:@"#303239"];
    
    self.arraySec = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *xtmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:1]];
        
        [self.arraySec addObject:xtmp];
    }
    
    altitude.xAxisTitleArray=self.arraySec;
    
    altitude.x = 0;
    altitude.y = 100;
    altitude.width = self.view.width;
    altitude.height = 300;
    
    DVPlot *plot1 = [[DVPlot alloc] init];
    
    self.arrayData = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *ptmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:5]];
        [self.arrayData addObject:ptmp];
    }
    
    plot1.pointArray  = self.arrayData;
    
    plot1.lineColor = [UIColor colorWithHexString:@"#5DCDD7"];//colorWithHexString:@"2f7184"
    plot1.pointColor = [UIColor colorWithHexString:@"#41A1C0"];//colorWithHexString:@"14b9d6"
    plot1.chartViewFill = NO;
    plot1.withPoint = YES;
    
    [altitude addPlot:plot1];
    [altitude draw];

    
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:sensor attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:altitude attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
#pragma 经度图表
    DVLineChartView *lat = [[DVLineChartView alloc] init];
    
    [self.chart3 addSubview:lat];
    
    lat.width = self.view.width;
    
    lat.yAxisViewWidth = 52;
    
    lat.numberOfYAxisElements = 5;
    
    lat.delegate = self;
    lat.pointUserInteractionEnabled = YES;
    
    self.maxY=0;
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSNumber *tmp = [[detailVC.detailArray objectAtIndex:n]objectAtIndex:2];
        if (self.maxY<[tmp floatValue]) {
            self.maxY = [tmp floatValue];
        }
    }
    
    lat.yAxisMaxValue = ceilf(self.maxY*1.2);
    NSLog(@"yAxisMaxValue:%f",lat.yAxisMaxValue);
    
    lat.pointGap = 50;
    
    lat.showSeparate = YES;
    lat.separateColor = [UIColor colorWithHexString:@"#303239"];
    
    lat.textColor = [UIColor colorWithHexString:@"#303239"];
    lat.backColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lat.axisColor = [UIColor colorWithHexString:@"#303239"];
    
    self.arraySec = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *xtmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:1]];
        
        [self.arraySec addObject:xtmp];
    }
    
    lat.xAxisTitleArray=self.arraySec;
    
    lat.x = 0;
    lat.y = 100;
    lat.width = self.view.width;
    lat.height = 300;
    
    DVPlot *plot2 = [[DVPlot alloc] init];
    
    self.arrayData = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *ptmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:2]];
        [self.arrayData addObject:ptmp];
    }
    
    plot2.pointArray  = self.arrayData;
    
    plot2.lineColor = [UIColor colorWithHexString:@"#5DCDD7"];//colorWithHexString:@"2f7184"
    plot2.pointColor = [UIColor colorWithHexString:@"#41A1C0"];//colorWithHexString:@"14b9d6"
    plot2.chartViewFill = NO;
    plot2.withPoint = YES;
    
    [lat addPlot:plot2];
    [lat draw];

#pragma 纬度数据图表
    DVLineChartView *lng = [[DVLineChartView alloc] init];
    
    [self.chart4 addSubview:lng];
    
    lng.width = self.view.width;
    
    lng.yAxisViewWidth = 52;
    
    lng.numberOfYAxisElements = 5;
    
    lng.delegate = self;
    lng.pointUserInteractionEnabled = YES;
    
    self.maxY=0;
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSNumber *tmp = [[detailVC.detailArray objectAtIndex:n]objectAtIndex:3];
        if (self.maxY<[tmp floatValue]) {
            self.maxY = [tmp floatValue];
        }
    }
    
    lng.yAxisMaxValue = ceilf(self.maxY*1.2);
    NSLog(@"yAxisMaxValue:%f",lng.yAxisMaxValue);
    
    lng.pointGap = 50;
    
    lng.showSeparate = YES;
    lng.separateColor = [UIColor colorWithHexString:@"#303239"];
    
    lng.textColor = [UIColor colorWithHexString:@"#303239"];
    lng.backColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lng.axisColor = [UIColor colorWithHexString:@"#303239"];
    
    self.arraySec = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *xtmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:1]];
        
        [self.arraySec addObject:xtmp];
    }
    
    lng.xAxisTitleArray=self.arraySec;
    
    lng.x = 0;
    lng.y = 100;
    lng.width = self.view.width;
    lng.height = 300;
    
    DVPlot *plot3 = [[DVPlot alloc] init];
    
    self.arrayData = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *ptmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:3]];
        [self.arrayData addObject:ptmp];
    }
    
    plot3.pointArray  = self.arrayData;
    
    plot3.lineColor = [UIColor colorWithHexString:@"#5DCDD7"];//colorWithHexString:@"2f7184"
    plot3.pointColor = [UIColor colorWithHexString:@"#41A1C0"];//colorWithHexString:@"14b9d6"
    plot3.chartViewFill = NO;
    plot3.withPoint = YES;
    
    [lng addPlot:plot3];
    [lng draw];

    
#pragma 速度数据图表
    DVLineChartView *speed = [[DVLineChartView alloc] init];
    
    [self.chart5 addSubview:speed];
    
    speed.width = self.view.width;
    
    speed.yAxisViewWidth = 52;
    
    speed.numberOfYAxisElements = 5;
    
    speed.delegate = self;
    speed.pointUserInteractionEnabled = YES;
    
    self.maxY=0;
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSNumber *tmp = [[detailVC.detailArray objectAtIndex:n]objectAtIndex:4];
        if (self.maxY<[tmp floatValue]) {
            self.maxY = [tmp floatValue];
        }
    }
    
    speed.yAxisMaxValue = ceilf(self.maxY*1.2);
    NSLog(@"yAxisMaxValue:%f",speed.yAxisMaxValue);
    
    speed.pointGap = 50;
    
    speed.showSeparate = YES;
    speed.separateColor = [UIColor colorWithHexString:@"#303239"];
    
    speed.textColor = [UIColor colorWithHexString:@"#303239"];
    speed.backColor = [UIColor colorWithHexString:@"#FFFFFF"];
    speed.axisColor = [UIColor colorWithHexString:@"#303239"];
    
    self.arraySec = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *xtmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:1]];
        
        [self.arraySec addObject:xtmp];
    }
    
    speed.xAxisTitleArray=self.arraySec;
    
    speed.x = 0;
    speed.y = 100;
    speed.width = self.view.width;
    speed.height = 300;
    
    DVPlot *plot4 = [[DVPlot alloc] init];
    
    self.arrayData = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *ptmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:4]];
        [self.arrayData addObject:ptmp];
    }
    
    plot4.pointArray  = self.arrayData;
    
    plot4.lineColor = [UIColor colorWithHexString:@"#5DCDD7"];//colorWithHexString:@"2f7184"
    plot4.pointColor = [UIColor colorWithHexString:@"#41A1C0"];//colorWithHexString:@"14b9d6"
    plot4.chartViewFill = NO;
    plot4.withPoint = YES;
    
    [speed addPlot:plot4];
    [speed draw];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lineChartView:(DVLineChartView *)lineChartView DidClickPointAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    
}

@end



