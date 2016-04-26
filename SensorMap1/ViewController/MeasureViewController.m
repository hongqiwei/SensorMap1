//
//  MeasureViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/11.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "MeasureViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "AddAnnotationViewController.h"
#import "WGS84TOGCJ02.h"
#import <CoreMotion/CoreMotion.h>

#define DBNAME    @"myDB.sqlite"

@interface MeasureViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIButton *myLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLable;
@property (weak, nonatomic) IBOutlet UILabel *mSpeedLable;
@property (weak, nonatomic) IBOutlet UILabel *aSpeedLable;
//定时器属性
@property (strong,nonatomic) NSTimer *timer;
@property(strong,nonatomic)NSTimer *sensorTimer;
// 上一次的位置
@property (nonatomic, strong) CLLocation *previousLocation;
// 总路程
@property (nonatomic, assign) CLLocationDistance  sumDistance;
// 总时间
@property (nonatomic, assign) NSTimeInterval  sumTime;

@property (weak, nonatomic) IBOutlet UILabel *mileageLable;

@property(nonatomic,strong)CLGeocoder *geocoder;

@property(nonatomic,strong)NSString *AnnotionTitle;

@property (strong,nonatomic) NSMutableArray *locationArray;
@property (strong,nonatomic) NSMutableArray *distanceArray;

@property (nonatomic) double distance;
@property (nonatomic) int t;
@property (nonatomic) int timeInterval;
@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat avgSpeed;

@property (nonatomic,strong) DBManager *dbManager;

@end

@implementation MeasureViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//为定位按钮添加响应
- (void)initControls
{
    
    [_myLocationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    [_myLocationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    
    
}

//实现locateAction 主要作用是修改用户定位模式 不是follow就改成follow
-(void)locateAction
{
    if (_mapView.userTrackingMode != MKUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
    }
    
}

//改变用户定位模式通知 判断定位模式被修改成什么样了 由此来设置按钮图片
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    //修改定位按钮状态
    if (mode == MKUserTrackingModeNone)
    {
        [_myLocationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    }
    else
    {
        [_myLocationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    //初始化DBManager
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:DBNAME];
    [self.dbManager createTable];
    
    //隐藏navigationbar
    self.navigationController.navigationBarHidden = YES;
    
    //加速计陀螺仪
    self.motionManager = [[CMMotionManager alloc]init];
    
    //判断是否开启定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        //标准地图类型
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.delegate = self;
        //显示比例尺
        self.mapView.showsScale = YES;
        // 是否显示交通
        self.mapView.showsTraffic = YES;
        // 是否显示建筑物
        self.mapView.showsBuildings = YES;
        //定位为中心
        self.mapView.centerCoordinate = _locationManager.location.coordinate;
        
        //授权
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //位置信息更新最小距离，只有移动大于这个距离才更新位置信息
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        MKCoordinateSpan span=MKCoordinateSpanMake(0.008, 0.008);
        MKCoordinateRegion region=MKCoordinateRegionMake(self.locationManager.location.coordinate, span);
        [_mapView setRegion:region animated:true];
        
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        
        [self initControls];
        
        self.mapView.showsUserLocation = YES;
        
        NSLog(@"定位经纬度：%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
        
        /***经纬度反编码***/
        //道路显示
        CLLocation *c =[[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
        
        CLGeocoder *revGeo = [[CLGeocoder alloc] init];
        //反地理编码
        [revGeo  reverseGeocodeLocation:c completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error && [placemarks count] > 0)
            {
                // 显示最前面的地标信息
                CLPlacemark *firstPlacemark=[placemarks firstObject];
                
                if (firstPlacemark.thoroughfare != NULL) {
                    
                    self.roadNameLable.text=[[NSString alloc]initWithFormat:@"%@",firstPlacemark.thoroughfare];
                    NSLog(@"道路名是:%@",firstPlacemark.thoroughfare);
                }else{
                    self.roadNameLable.text=[[NSString alloc]initWithFormat:@"%@",firstPlacemark.name];
                    NSLog(@"建筑物名是：%@",firstPlacemark.name);
                }
                
                _AnnotionTitle = [[NSString alloc]initWithFormat:@"%@",firstPlacemark.thoroughfare];
                NSLog(@"annotiontitle:%@",self.AnnotionTitle);
                
                NSLog(@"roadName:%@",self.roadNameLable.text);
            }else{
                self.roadNameLable.text=@"没找到";
                NSLog(@"ERROR: %@", error);
            }
        }];

        //秒表
        measureTime = [[MZTimerLabel alloc] initWithLabel:_timerLable1 andTimerType:MZTimerLabelTypeStopWatch];
        measureTime.timeFormat = @"HH:mm:ss SS";

        //实例化经纬度数组、里程数组、测量数据数组
        self.locationArray = [[NSMutableArray alloc]init];
        self.distanceArray = [[NSMutableArray alloc]init];
        self.dataDetailArray = [[NSMutableArray alloc]init];
        
        //设置显示数据的view样式
        //self.sensorUIView.layer.cornerRadius = 8;//圆角
        //self.sensorUIView.layer.masksToBounds = YES;//阴影
        
        self.mileageUIView.layer.borderWidth = 1;
        self.mileageUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
        
        self.speedUIView.layer.borderWidth = 1;
        self.speedUIView.layer.borderColor = [[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
        
        self.aSpeedUIView.layer.borderWidth = 1;
        self.aSpeedUIView.layer.borderColor =[[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];

        self.sensorUIView.layer.borderWidth = 1;
        self.sensorUIView.layer.borderColor =[[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];

        self.altUIView.layer.borderWidth = 1;
        self.altUIView.layer.borderColor =[[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];
        
        self.spareUIView.layer.borderWidth = 1;
        self.spareUIView.layer.borderColor =[[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1] CGColor];

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

//秒表按钮方法
-(IBAction)startOrResumeStopwatch:(id)sender{
    if ([measureTime counting]) {
        [measureTime pause];
        [_StartOrRusumeButton setTitle:@"继续" forState:UIControlStateNormal];
        
        [self pauseTimer];
    }else{
        [measureTime start];
        [_StartOrRusumeButton setTitle:@"暂停" forState:UIControlStateNormal];
        
        [self startTimer];
    }
}

-(IBAction)resetStopWatch:(id)sender{
    [measureTime reset];
    
    if (![measureTime counting]) {
        [_StartOrRusumeButton setTitle:@"开始" forState:UIControlStateNormal];
        [self resetTimer];
    }else{
        [self resetTimer];
    }
}


/*
    1.点击开始，获取经纬度，存储定位点
    2.每隔一秒存储一个坐标点，计算与之前点的距离，和瞬时速度
    3.累加每次计算出来的距离获得总里程，除以总时间获得均速
    4.每隔一秒存储一个海拔，并展示
    5.点击暂停，则暂停操作；电子复位，则清除当前数据
 
 */

//开始定时器
- (void)startTimer{
    self.t = 1.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.t) target:self selector:@selector(dataMeasure) userInfo:nil repeats:YES];
    //self.sensorTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 10.0 target:self  selector:@selector(useAccelermeterAndGyro) userInfo:nil repeats:YES];
}

//暂停定时器
- (void)pauseTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.sensorTimer setFireDate:[NSDate distantFuture]];
    self.mSpeedLable.text = @"0.00";
}

//继续定时器
- (void)continueTimer{
    [self.timer setFireDate:[NSDate date]];
    [self.sensorTimer setFireDate:[NSDate date]];
}

//复位定时器
- (void)resetTimer{
    
    [self.locationArray removeAllObjects];
    [self.distanceArray removeAllObjects];
    self.sumDistance = 0;
     self.mileageLable.text = [[NSString alloc] initWithFormat:@"%.2f",self.sumDistance/1000];
    //self.timeInterval = 0;
    self.speed = 0;
    self.mSpeedLable.text = @"0.00";
    self.avgSpeed = 0;
    self.aSpeedLable.text = [[NSString alloc]initWithFormat:@"%.2f",self.avgSpeed*60*60/1000];
    self.altitudeLable.text = @"0.00";
    NSLog(@"里程：%@",self.mileageLable.text);
    NSLog(@"均速：%@",self.aSpeedLable.text);
    
}

////定时器方法
//- (void)timerMethod{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dataMeasure) userInfo:nil repeats:YES];
//}


//数据测量方法
- (void)dataMeasure{
    NSNumber *lat = [[NSNumber alloc]initWithDouble:self.locationManager.location.coordinate.latitude];
    NSNumber *lng = [[NSNumber alloc]initWithDouble:self.locationManager.location.coordinate.longitude];
    NSArray *locationCoordinate = [[NSArray alloc]initWithObjects:lat,lng, nil];
    [self.locationArray addObject:locationCoordinate];
    
    NSLog(@"%@",self.locationArray);
    
/**数组实例**/
//    NSArray *array = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"iOS",@"android",@"C",@"C++",@"OC",@"JAVA", nil],[NSArray arrayWithObjects:@"php",@"c#",@"FMDB",@"sqlite",@"odbc",@"photoshop", nil],
//                      [NSArray arrayWithObjects:@"javascript",@"xml",@"html",@"cocos2D",@"u3d",@"sjjg", nil],nil];
//    NSLog(@"数组实例：%@",[[array objectAtIndex:1] objectAtIndex:2]);

    if (self.locationArray.count>1) {
        
        NSString *lat1 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray lastObject] firstObject]];
        NSLog(@"最后一个坐标的纬度：%@",lat1);
        NSString *log1 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray lastObject] objectAtIndex:1]];
        NSString *lat2 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:self.locationArray.count-2]objectAtIndex:0]];
        NSString *log2 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:self.locationArray.count-2]objectAtIndex:1]];
        
        //    //数组最后一项
        //    [self.locationArray lastObject];
        //    //数组倒数第二项
        //    [self.locationArray objectAtIndex:self.locationArray.count-2];
        
        MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([lat1 doubleValue],[log1 doubleValue]));
        MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([lat2 doubleValue],[log2 doubleValue]));
        //计算距离
        CLLocationDistance distance = MKMetersBetweenMapPoints(point1,point2);
         NSLog(@"距离：%f",distance);
        
        NSNumber *distancetmp = [[NSNumber alloc]initWithDouble:distance];
        NSArray *coordinateDistance = [[NSArray alloc]initWithObjects:distancetmp, nil];
        [self.distanceArray addObject:coordinateDistance];
        
        NSLog(@"%@",self.locationArray);
        
        //里程
        self.sumDistance += distance;
        self.mileageLable.text = [[NSString alloc] initWithFormat:@"%.2f",self.sumDistance/1000];
        
        //测量总时间
        self.timeInterval = self.timeInterval + self.t;
        
        //测量时速
        self.speed = distance/self.t ;
        //时速显示
        self.mSpeedLable.text = [[NSString alloc]initWithFormat:@"%.2f",self.speed*60*60/1000];
        
        //测量均速
        self.avgSpeed = self.sumDistance / self.timeInterval ;
        self.aSpeedLable.text = [[NSString alloc]initWithFormat:@"%.2f",self.avgSpeed*60*60/1000];
        
        //海拔显示
        self.altitudeLable.text = [[NSString alloc]initWithFormat:@"%.2f",self.locationManager.location.altitude];
        
        NSLog(@"距离%f  速度%f 平均速度%f 总路程 %f 总时间 %d", distance , self.speed, self.avgSpeed, self.sumDistance, self.timeInterval);
        
        //每次得到的数据都保存到数组当中
        NSNumber *secID = [[NSNumber alloc]initWithDouble:self.timeInterval];
        NSNumber *speed = [[NSNumber alloc]initWithDouble:self.speed*60*60/1000];
        NSNumber *alt = [[NSNumber alloc]initWithDouble:self.locationManager.location.altitude];

        
        NSArray *dataTmp = [[NSArray alloc]initWithObjects:secID,lat1,log1,speed,alt,nil];
        [self.dataDetailArray addObject:dataTmp];
        NSLog(@"保存在数组当中的数据：%@",self.dataDetailArray);
        
    }else{
        NSLog(@"仅有一个点，无法测距");
        //海拔显示
        self.altitudeLable.text = [[NSString alloc]initWithFormat:@"%.2f",self.locationManager.location.altitude];
    }
    
}

- (void)useAccelermeterAndGyro{
    if (self.motionManager.accelerometerAvailable) {
        [_motionManager setAccelerometerUpdateInterval:1 / 40.0];
        [_motionManager startAccelerometerUpdates];
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        NSLog(@"Accelerometer\n---\nx: %+.2f\ny: %+.2f\nz: %+.2f",
              accelerometerData.acceleration.x,
              accelerometerData.acceleration.y,
              accelerometerData.acceleration.z);
        /**陀螺仪数据**/
        //旋转角速度
        [_motionManager setDeviceMotionUpdateInterval:1/40.0];
        [_motionManager startDeviceMotionUpdates];
        CMRotationRate rotationRate = self.motionManager.deviceMotion.rotationRate;
        double rotationX = rotationRate.x;
        double rotationY = rotationRate.y;
        double rotationZ = rotationRate.z;
        NSLog(@"角速度数据\n x:%f,y:%f,z:%f",rotationX,rotationY,rotationZ);
        //空间位置的欧拉角
        double roll = self.motionManager.deviceMotion.attitude.roll;
        double pitch = self.motionManager.deviceMotion.attitude.pitch;
        double yaw = self.motionManager.deviceMotion.attitude.yaw;
        NSLog(@"欧拉角数据\n roll:%f,pitch:%f,yaw:%f",roll,pitch,yaw);
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
        
    }
    
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //得到newLocation
    CLLocation *loc = [locations objectAtIndex:0];
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        
        NSLog(@"得到的火星坐标：%f，%f",coord.latitude,coord.longitude);
    }
}



//插入大头针
- (void)setAnnotation{
    
   
    //取出坐标数组的中间值
    NSString *lat3 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:self.locationArray.count/2]objectAtIndex:0]];
    NSString *lng3 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:self.locationArray.count/2]objectAtIndex:1]];
    
    NSLog(@"插点坐标:%@ ，%@",lat3,lng3);

    
//    /**NSString 转 NSNumber**/
//    
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSNumber *lat3Tmp = [numberFormatter numberFromString:lat3];
//    NSNumber *lng3Tmp = [numberFormatter numberFromString:lng3];
//    
//    NSLog(@"lat3Tmp：%@",lat3Tmp);
//    NSLog(@"lng3Tmp：%@",lng3Tmp);
    

//  /** NSString 转换成 CGFloat**/
    
//    CGFloat lat4 = [lat3 floatValue];
//    CGFloat lng4 = [lng3 floatValue];
//    NSLog(@"lat4：%f",lat4);
//    NSLog(@"lng4：%f",lng4);
    
//    CLLocationCoordinate2D earth;
//    earth.latitude = [lat3 doubleValue];
//    earth.longitude = [lng3 doubleValue];
    CLLocation *earth = [[CLLocation alloc] initWithLatitude:[lat3 doubleValue] longitude:[lng3 doubleValue]];
    
    CLLocationCoordinate2D mars = [WGS84TOGCJ02 transformFromWGSToGCJ:[earth coordinate]];
    NSLog(@"实例1:%f，%f",mars.latitude,mars.longitude);
    
    //添加大头针位置
    MKPointAnnotation *addAnnotation1 = [[MKPointAnnotation alloc]init];
    //addAnnotation1.coordinate = CLLocationCoordinate2DMake([lat3 doubleValue], [lng3 doubleValue]);
    //addAnnotation1.coordinate = CLLocationCoordinate2DMake(28.179531, 112.941434);
    //addAnnotation1.coordinate = CLLocationCoordinate2DMake(lat4, lng4);
    
    addAnnotation1.coordinate = CLLocationCoordinate2DMake(mars.latitude, mars.longitude);
    
    addAnnotation1.title = [[NSString alloc]initWithFormat:@"%@",self.aTitle1];
    addAnnotation1.subtitle = [[NSString alloc]initWithFormat:@"%@",self.aSubTitle1];
    NSLog(@"标注点标题：%@",addAnnotation1.title);
    NSLog(@"标注点副标题：%@",addAnnotation1.subtitle);
    
    [_mapView addAnnotation:addAnnotation1];
    
    
}

//绘制行驶路线
-(void)drawLine{
    
    if (self.locationArray.count>2) {
        for (int p=0; p<self.locationArray.count-2; p++) {
            //取第一个点
            NSString *lattmp1 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:p]objectAtIndex:0]];
            NSString *lngtmp1 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:p]objectAtIndex:1]];
            //坐标转换
            CLLocation *earthtmp1 = [[CLLocation alloc] initWithLatitude:[lattmp1 doubleValue] longitude:[lngtmp1 doubleValue]];
            CLLocationCoordinate2D marstmp1 = [WGS84TOGCJ02 transformFromWGSToGCJ:[earthtmp1 coordinate]];
            NSLog(@"连线点1:%f，%f",marstmp1.latitude,marstmp1.longitude);
            //取第二个点
            NSString *lattmp2 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:p+1]objectAtIndex:0]];
            NSString *lngtmp2 = [[NSString alloc]initWithFormat:@"%@",[[self.locationArray objectAtIndex:p+1]objectAtIndex:1]];
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
    
    }else{
        NSLog(@"标记点不够");
    }
    
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

//能否标注判断
- (IBAction)markButtom:(id)sender{
    
    if (self.locationArray.count>10) {
        [self performSegueWithIdentifier:@"second" sender:self];
    }else{
        NSLog(@"测量时间太短，无法完成标注");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"测量时间太短，不能少于12s" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}


//多页面传属性
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
        if([segue.identifier isEqualToString:@"second"]){
        
            AddAnnotationViewController *addAnnotionVC = (AddAnnotationViewController *)[segue destinationViewController];
            addAnnotionVC.roadName = self.roadNameLable.text;
            double tmp = self.locationManager.location.coordinate.latitude;
            addAnnotionVC.roadData = [[NSNumber alloc]initWithDouble:tmp];
            
        }else if([segue.identifier isEqualToString:@"showBiaoZhu"]){
            
        }
        
    
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    NSLog(@"error:%@",[error description]);
}


@end
