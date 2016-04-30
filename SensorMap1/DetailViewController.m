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
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    //显示比例尺
    self.mapView.showsScale = YES;
    
    [self setAnnotation];
    [self showLine];
    [self showData];
    
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
    
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MKPolyline *commonPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    
}

//显示数据
-(void)showData{
    HistoryViewController *historyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    self.sensorLable.text = [NSString stringWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0] objectAtIndex:8]];
    NSLog(@"显示信息：%@",self.sensorLable.text);
    self.mileageLable.text = [NSString stringWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0] objectAtIndex:5]];
    self.timeLable.text = [NSString stringWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0] objectAtIndex:4]];
    self.aAltLable.text = [NSString stringWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0] objectAtIndex:6]];
    self.aSpeedLable.text = [NSString stringWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0] objectAtIndex:7]];
}

//设置地图显示中心点 以及历史轨迹展示
-(void)showLine{
    HistoryViewController *historyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    self.detailArray = historyVC.arryDetailData;
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

//地图Overlay代理
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineView =[[MKPolylineRenderer alloc] initWithOverlay:overlay];
        //MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 2.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.lineJoin = kCGLineJoinRound;//连接类型
        polylineView.lineCap = kCGLineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}

-(void)setAnnotation{
    HistoryViewController *historyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    self.detailArray = historyVC.arryDetailData;
    //得到中点坐标
    NSString *centerLat = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:historyVC.arryDetailData.count/2]objectAtIndex:2]];
    NSString *centerLng = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryDetailData objectAtIndex:historyVC.arryDetailData.count/2]objectAtIndex:3]];
    //把得到的坐标变成coordinate格式
    //CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake([centerLat doubleValue], [centerLng doubleValue]);
    CLLocation *centerEarth = [[CLLocation alloc] initWithLatitude:[centerLat doubleValue] longitude:[centerLng doubleValue]];
    CLLocationCoordinate2D centerMars = [WGS84TOGCJ02 transformFromWGSToGCJ:[centerEarth coordinate]];
    
    //添加大头针位置
    self.addAnnotation1 = [[MKPointAnnotation alloc]init];
    self.addAnnotation1.coordinate = CLLocationCoordinate2DMake(centerMars.latitude, centerMars.longitude);
    
    self.aTitle = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0]objectAtIndex:1]];
    self.addAnnotation1.title = self.aTitle;
    
    self.aSubTitle = [[NSString alloc]initWithFormat:@"%@",[[historyVC.arryBasicData objectAtIndex:0]objectAtIndex:8]];
    self.addAnnotation1.subtitle = self.aSubTitle;
    
    [_mapView addAnnotation:self.addAnnotation1];
}

-(void)resetAnnotation{
    self.addAnnotation1.title = self.aTitle;
    self.addAnnotation1.subtitle = self.aSubTitle;

}

//大头针属性设置
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MKPinAnnotationView*annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.opaque = NO;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}





@end

