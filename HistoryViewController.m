//
//  HistoryViewController.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "HistoryViewController.h"
#import "AddAnnotationViewController.h"
#import "MozTopAlertView.h"

#define DBNAME    @"myDB.sqlite"

@interface HistoryViewController ()

@property (nonatomic,strong) DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UITableView *tableMain;

@end


@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化DBManager
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:DBNAME];
    [self.dbManager createTable];
    
    //去除TableView多余横线
    [self setTableFooterView:_tableMain];
    
    self.searchResults = [[NSMutableArray alloc]init];
    
    self.searchBar.searchBarStyle =UISearchBarStyleMinimal;
    self.searchBar.placeholder=@"搜索";
    
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
    NSString *query1 = [NSString stringWithFormat:@"select * from roadData where roadInfoID = %@",a];
    if (self.arryDetailData != nil) {
        self.arryDetailData = nil;
    }
    if (self.arryBasicData != nil) {
        self.arryBasicData = nil;
    }
    self.arryDetailData= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.arryBasicData= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
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

//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
//    
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
//    
//    self.searchResults = [self.arrRoadData filteredArrayUsingPredicate:resultPredicate];
//    NSLog(@"筛选内容：%@",self.searchResults);
//}

-(void)handleSearchForTerm:(NSString *)searchTerm{

//    //初始化存储结果的array
//    if (self.searchResults != nil) {
//        [self.searchResults removeAllObjects];
//        self.searchResults = nil;
//    }
    self.searchResults = [[NSMutableArray alloc] init];
    
    for (int n=0; n<self.arrRoadData.count; n++) {
        NSString *str = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n] objectAtIndex:1]];
        if ([str rangeOfString:searchTerm].location != NSNotFound) {
            
            //NSLog(@"找到啦！n=%d",n);
            
            //roadInfoID integer, roadname text, datetime text, info text,duration integer,sumDistance text,aAlt folat,aSpeed float,sensorData text
            NSString *roadInfoID = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:0]];
            //NSLog(@"roadinfoid=%@",roadInfoID);
            NSString *roadname = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:1]];
            NSString *datatime = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:2]];
            NSString *info = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:3]];
            NSString *duration = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:4]];
            NSString *sumDistance = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:5]];
            NSString *aAlt = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:6]];
            NSString *aSpeed = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:7]];
            NSString *sensorData = [[NSString alloc]initWithFormat:@"%@",[[self.arrRoadData objectAtIndex:n]objectAtIndex:8]];
            
            NSArray *dataTmp = [[NSArray alloc]initWithObjects:roadInfoID,roadname,datatime,info,duration,sumDistance,aAlt,aSpeed,sensorData, nil];
            //NSLog(@"插入的数据：%@",dataTmp);
            [self.searchResults addObject:dataTmp];

        }else{
            //NSLog(@"没找到！");
            //[MozTopAlertView showWithType:MozAlertTypeInfo text:@"未找到相应数据" parentView:self.view];
        }
        
    }
    
    if (self.searchResults.count != 0) {
        //NSLog(@"找到的数据：%@",self.searchResults);
        self.arrRoadData = self.searchResults;
        
        [self.tableMain reloadData];
    }else{
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"未找到相应数据" parentView:self.view];
    }
    
    
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES];
    //将“cancel”改为“取消”
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     [_searchBar setShowsCancelButton:YES];
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }

    
    //搜索条输入文字修改时触发
    if([searchText length]==0)
    {
        //[_searchBar setShowsCancelButton:NO];
        //如果无文字输入
        [self loadData];
        return;
    }else{
        //有文字输入就把关键字传给handleSearchForTerm处理
        [self handleSearchForTerm:searchText];
    }
    
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    
//    NSString *searchText = searchBar.text;
//    NSLog(@"点击了！");
//    
//    [self handleSearchForTerm:searchText];
//}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{//取消按钮被按下时触发
    [self loadData];
    [_searchBar setShowsCancelButton:NO];
    //输入框清空
    searchBar.text=@"";
    //重新载入数据，隐藏软键盘
    [self.searchBar resignFirstResponder];
    
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    for(id cc in [searchBar.subviews[0] subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//    }
//}

@end
