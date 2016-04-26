//
//  DetailViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "DetailViewController.h"
#import "HistoryViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"

@interface DetailViewController()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation DetailViewController

-(void)viewDidLoad{
    
    [self showLine];
    
    self.mileageUIView.layer.cornerRadius = 8;//圆角
    self.mileageUIView.layer.masksToBounds = YES;//阴影
    self.mileageUIView.layer.borderWidth = 1;
    self.mileageUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
    
    self.sensorUIView.layer.cornerRadius = 8;//圆角
    self.sensorUIView.layer.masksToBounds = YES;//阴影
    self.sensorUIView.layer.borderWidth = 1;
    self.sensorUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];

    self.aSpeedUIView.layer.cornerRadius = 8;//圆角
    self.aSpeedUIView.layer.masksToBounds = YES;//阴影
    self.aSpeedUIView.layer.borderWidth = 1;
    self.aSpeedUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
    
    self.timeUIView.layer.cornerRadius = 8;//圆角
    self.timeUIView.layer.masksToBounds = YES;//阴影
    self.timeUIView.layer.borderWidth = 1;
    self.timeUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
    
    self.altUIView.layer.cornerRadius = 8;//圆角
    self.altUIView.layer.masksToBounds = YES;//阴影
    self.altUIView.layer.borderWidth = 1;
    self.altUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
    
}

//设置地图显示中心点 以及历史轨迹展示
-(void)showLine{
    HistoryViewController *historyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //得到中点坐标
    NSString *centerLat = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:historyVC.arryDetailData.count/2]objectAtIndex:2]];
    NSString *centerLng = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:historyVC.arryDetailData.count/2]objectAtIndex:3]];
    //把得到的坐标变成coordinate格式
    //CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake([centerLat doubleValue], [centerLng doubleValue]);
    CLLocation *centerEarth = [[CLLocation alloc] initWithLatitude:[centerLat doubleValue] longitude:[centerLng doubleValue]];
    CLLocationCoordinate2D centerMars = [WGS84TOGCJ02 transformFromWGSToGCJ:[centerEarth coordinate]];

    //地图中心 以及显示比例
    MKCoordinateSpan span=MKCoordinateSpanMake(0.008, 0.008);
    MKCoordinateRegion region=MKCoordinateRegionMake(centerMars, span);
    [_mapView setRegion:region animated:true];
    
    NSLog(@"连接点数：%lu",historyVC.arryDetailData.count);
    
    for (int p=0; p<historyVC.arryDetailData.count-2; p++) {
        //取第一个点
        NSString *lattmp1 = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:p]objectAtIndex:2]];
        NSString *lngtmp1 = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:p]objectAtIndex:3]];
        //坐标转换
        CLLocation *earthtmp1 = [[CLLocation alloc] initWithLatitude:[lattmp1 doubleValue] longitude:[lngtmp1 doubleValue]];
        CLLocationCoordinate2D marstmp1 = [WGS84TOGCJ02 transformFromWGSToGCJ:[earthtmp1 coordinate]];
        NSLog(@"连线点1:%f，%f",marstmp1.latitude,marstmp1.longitude);
        //取第二个点
        NSString *lattmp2 = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:p+1]objectAtIndex:2]];
        NSString *lngtmp2 = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:p+1]objectAtIndex:3]];
        //坐标转换
        CLLocation *earthtmp2 = [[CLLocation alloc] initWithLatitude:[lattmp2 doubleValue] longitude:[lngtmp2 doubleValue]];
        CLLocationCoordinate2D marstmp2 = [WGS84TOGCJ02 transformFromWGSToGCJ:[earthtmp2 coordinate]];
        NSLog(@"连线点2:%f，%f",marstmp2.latitude,marstmp2.longitude);
        
        //构造折线数据对象
        CLLocationCoordinate2D commonPolylineCoords[2];
        commonPolylineCoords[0].latitude = marstmp1.latitude;
        commonPolylineCoords[0].longitude = marstmp1.longitude;
        
        commonPolylineCoords[1].latitude = marstmp2.latitude;
        commonPolylineCoords[1].longitude = marstmp2.longitude;
        //构造折线对象
        MKPolyline *commonPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords count:2];
        
        //在地图上添加折线对象
        [_mapView addOverlay: commonPolyline];
        
    }

}


@end

