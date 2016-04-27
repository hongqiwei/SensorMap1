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
    self.view.backgroundColor = [UIColor redColor];//colorWithHexString:@"3e4a59"
    
    
    DVLineChartView *ccc = [[DVLineChartView alloc] init];
    [self.view addSubview:ccc];
    
    ccc.width = self.view.width;
    
    ccc.yAxisViewWidth = 52;
    
    ccc.numberOfYAxisElements = 5;
    
    ccc.delegate = self;
    ccc.pointUserInteractionEnabled = YES;
    
//    ccc.yAxisMaxValue = 1000;
    
    DetailViewController *detailVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSNumber *tmp = [[detailVC.detailArray objectAtIndex:n]objectAtIndex:5];
        if (self.maxY<[tmp floatValue]) {
            self.maxY = [tmp floatValue];
        }
    }
    
    ccc.yAxisMaxValue = ceilf(self.maxY*1.2);
    NSLog(@"yAxisMaxValue:%f",ccc.yAxisMaxValue);
    
    ccc.pointGap = 50;
    
    ccc.showSeparate = YES;
    ccc.separateColor = [UIColor whiteColor];//colorWithHexString:@"67707c"
    
    ccc.textColor = [UIColor whiteColor];//colorWithHexString:@"9aafc1"
    ccc.backColor = [UIColor blueColor];//colorWithHexString:@"3e4a59"
    ccc.axisColor = [UIColor whiteColor];//colorWithHexString:@"67707c"
    
    NSLog(@"detailVC.detailArray:%@",detailVC.detailArray);
    
    self.arraySec = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *xtmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:1]];
        
        [self.arraySec addObject:xtmp];
    }
    
    NSLog(@"self.arraySec:%@",self.arraySec);
    
    ccc.xAxisTitleArray=self.arraySec;
    
    NSLog(@"xAxisTitleArray:%@",ccc.xAxisTitleArray);
    
//    ccc.xAxisTitleArray = @[@"4.1", @"4.2", @"4.3", @"4.4", @"4.5", @"4.6", @"4.7", @"4.8", @"4.9", @"4.10", @"4.11", @"4.12", @"4.13", @"4.14", @"4.15", @"4.16", @"4.17", @"4.18", @"4.19", @"4.20", @"4.21", @"4.22", @"4.23", @"4.24", @"4.25", @"4.26", @"4.27", @"4.28", @"4.29", @"4.30"];
    
    
    ccc.x = 0;
    ccc.y = 100;
    ccc.width = self.view.width;
    ccc.height = 300;
    
    
    
    DVPlot *plot = [[DVPlot alloc] init];
    
    self.arrayData = [[NSMutableArray alloc]init];
    for (int n=0; n<detailVC.detailArray.count; n++) {
        NSString *ptmp = [[NSString alloc]initWithFormat:@"%@",[[detailVC.detailArray objectAtIndex:n]objectAtIndex:5]];
        
        [self.arrayData addObject:ptmp];
    }
    
    NSLog(@"self.arrayData:%@",self.arrayData);
    
    plot.pointArray  = self.arrayData;
    NSLog(@"pointArray:%@",plot.pointArray);
    
//    plot.pointArray = @[@300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30];
    
    
    
    
    plot.lineColor = [UIColor greenColor];//colorWithHexString:@"2f7184"
    plot.pointColor = [UIColor grayColor];//colorWithHexString:@"14b9d6"
    plot.chartViewFill = NO;
    plot.withPoint = YES;
    
    
    //    DVPlot *plot1 = [[DVPlot alloc] init];
    //    plot1.pointArray = @[@100, @300, @200, @120, @650, @770, @240, @530, @10, @90, @100, @300, @200, @120, @650, @770, @240, @530, @10, @90, @100, @300, @200, @120, @650, @770, @240, @530, @10, @90];
    //
    //
    //    plot1.lineColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    //    plot1.pointColor = [UIColor whiteColor];
    //    plot1.chartViewFill = YES;
    //    plot1.withPoint = YES;
    
    [ccc addPlot:plot];
    //    [ccc addPlot:plot1];
    [ccc draw];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lineChartView:(DVLineChartView *)lineChartView DidClickPointAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    
}

@end



