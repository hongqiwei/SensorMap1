//
//  HistoryViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "HistoryViewController.h"
#import "AddAnnotationViewController.h"

#define DBNAME    @"myDB.sqlite"
//#define TABLENAME @"BASICTABLE"

@interface HistoryViewController ()

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrRoadData;

@property (weak, nonatomic) IBOutlet UITableView *tableMain;

@end


@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化DBManager
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:DBNAME];
    //[_dbManager createTableWithSql:"CREATE TABLE roadData(roadInfoID integer primary key, roadname text, datetime text, info text);"];
    [self.dbManager createTable];
    //去除TableView多余横线
    [self setTableFooterView:_tableMain];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.translucent = NO; 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark 从数据库加载所有数据
-(void)loadData{
    //sql语句
    NSString *query = @"select * from roadData";
    
    if (self.arrRoadData != nil) {
        self.arrRoadData = nil;
    }
    self.arrRoadData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    [self.tableMain reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
#pragma mark Sections的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark cell的总个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrRoadData.count;;
}

#pragma mark cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

#pragma mark 设置每个cell的视图
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[[self.arrRoadData objectAtIndex:indexPath.row] objectAtIndex:1], [[self.arrRoadData objectAtIndex:indexPath.row] objectAtIndex:2]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"平坦程度：%@",[[self.arrRoadData objectAtIndex:indexPath.row] objectAtIndex:3]];
    return cell;
}

//#pragma mark 点击某个cell跳转到修改页面
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NewRecordViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRecordViewController"];
//    nvc.recordIDToEdit = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
//    [self.navigationController pushViewController:nvc animated:self];
//}

#pragma mark 点击cell进行页面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *a = [[self.arrRoadData objectAtIndex:indexPath.row]objectAtIndex:0];
    NSString *b = [[self.arrRoadData objectAtIndex:indexPath.row]objectAtIndex:1];
    NSLog(@"a= %@, b=%@",a,b);
    NSString *query = [NSString stringWithFormat:@"select * from dataDetail where roadInfoID = %@",a];
    if (self.arryDetailData != nil) {
        self.arryDetailData = nil;
    }
    self.arryDetailData= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"详细数据：%@",self.arryDetailData);
}

#pragma mark 滑动删除数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 得到要删除数据的ID
        NSString *recordIDToDelete = [[self.arrRoadData objectAtIndex:indexPath.row] objectAtIndex:0];
        
        
        // SQL语句
        NSString *query = [NSString stringWithFormat:@"delete from roadData where roadInfoID=%@", recordIDToDelete];
        
        NSString *c = [[self.arrRoadData objectAtIndex:indexPath.row]objectAtIndex:0];
        NSString *query2 = [NSString stringWithFormat:@"delete from dataDetail where roadInfoID=%@",c];
        
        // 执行语句
        [self.dbManager executeQuery:query];
        [self.dbManager executeQuery:query2];
        
        // 重新加载数据
        [self loadData];
    }
}

//#pragma mark 跳转添加新纪录页面
//- (IBAction)addNewRecord:(id)sender {
//    NewRecordViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRecordViewController"];
//    nvc.recordIDToEdit = -1;
//    [self.navigationController pushViewController:nvc animated:self];
//}

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
