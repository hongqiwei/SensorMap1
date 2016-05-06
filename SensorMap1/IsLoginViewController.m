//
//  IsLoginViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/2.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "IsLoginViewController.h"
#import "LoginViewController.h"
#import "CommunityService.h"

@implementation IsLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.time = self.time + 1;
    
    [self.loading startAnimating];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidLoad{
    self.head_Icon.layer.cornerRadius = 5;
    self.head_Icon.layer.borderWidth = 1;
    //UIColor(red:0.25, green:0.63, blue:0.75, alpha:1.00)
    self.head_Icon.layer.borderColor = [[UIColor colorWithRed:0.25 green:0.63 blue:0.75 alpha:0.8]CGColor];
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults stringForKey:@"username"];
    self.userNameLable.text = name;
    
    if (self.time<1) {
        [self getsharelist];
    }else{
        [self loadData];
        [self.loading stopAnimating];
    }
    
    
    //去除TableView多余横线
    [self setTableFooterView:self.shareTable];
}

-(void)getsharelist{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults stringForKey:@"username"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue,^{
        NSError *error = nil;
        bool isShowSucessed = [CommunityService showByUserName:name error:&error];
        
        if(error){
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络或服务器错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(isShowSucessed){
                    
                    //                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"朋友圈获取成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    //                    [alter show];
                    //
                    //                  NSLog(@"show sucessed");
                    
                    NSLog(@"可以展示朋友圈");
                    [self pengyouquan];
                    
                    [self loadData];
                    
                    [self.loading stopAnimating];
                    
                }else{
                    NSLog(@"share failed");
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"朋友圈获取失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alter show];
                }
            });
        }
    });

    
}

-(void)pengyouquan{
    
    NSString *name = self.userNameLable.text ;
    NSError *error;
    NSLog(@"error:%@",error);
    NSArray *array = [CommunityService getShareListWithUserName:name error:&error];
    NSLog(@"array:%@",array);
    if (!error&&array) {
        self.dataSource = [[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++) {
            
//            NSString *test = [[NSString alloc]initWithFormat:@"%@",[[self.dataSource objectAtIndex:i]objectAtIndex:0]];
//            NSLog(@"test:%@",test);
            
            NSString *username = array[i][@"user_name"];
            NSString *sharedate = array[i][@"share_date"];
            
            NSString *roadname = array[i][@"road_name"];
            NSString *mdate = array[i][@"measure_date"];
            NSString *sensordata = array[i][@"sensor_data"];
            NSLog(@"分享数据是：%@,%@,%@,%@,%@",username,sharedate,roadname,mdate,sensordata);
            
            NSArray *dataTmp = [[NSArray alloc]initWithObjects:username,sharedate,roadname,mdate,sensordata, nil];
            [self.dataSource addObject:dataTmp];
            
//            NSDictionary *share_str = [array objectAtIndex:i];
//            NSLog(@"share_str:%@",share_str);
//            [self.dataSource addObject:share_str];
        }
    }
//    NSLog(@"朋友圈数据：%@",self.dataSource);
    
}

- (IBAction)quit:(id)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_token"];
    [defaults removeObjectForKey:@"username"];
    NSString *tmp = [defaults stringForKey:@"access_token"];
    NSLog(@"accesstoken:%@",tmp);
    
    [self performSegueWithIdentifier:@"quit" sender:self];
}


#pragma mark 加载所有数据
-(void)loadData{
    
    [self.shareTable reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
#pragma mark Sections的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark cell的总个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;;
}

#pragma mark cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

#pragma mark 设置每个cell的视图
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@分享于%@",[[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:0], [[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:1]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 在 %@ 测量得到的平坦数据是 %@",[[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:3],[[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:4]];
    [cell.textLabel setNumberOfLines:3];//可以显示3行
    
    //设置cell不能点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉右边">"
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

#pragma mark 去除 tableView 多余的横线
- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

@end
