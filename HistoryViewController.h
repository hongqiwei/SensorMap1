//
//  HistoryViewController.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/12.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController

@property (nonatomic, strong) NSArray *arrRoadData;
@property(nonatomic,strong) NSArray *arryDetailData;
@property(nonatomic,strong) NSArray *arryBasicData;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

//-(void)resetSearch;
//重置搜索，即恢复到没有输入关键字的状态
-(void)handleSearchForTerm:(NSString *)searchTerm;
//处理搜索，即把不包含searchTerm的值从可变数组中删除

@end
