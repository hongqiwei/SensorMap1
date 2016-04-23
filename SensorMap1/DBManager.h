//
//  DBManager.h
//  SensorMap1
//
//  Created by hongqiwei on 16/4/21.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;//存储列名
@property (nonatomic) int affectedRows;//记录被改变的行数
@property (nonatomic) long long lastInsertedRowID;//记录最后插入行的id

-(NSArray *)loadDataFromDB:(NSString *)query;//查询
-(void)executeQuery:(NSString *)query;//插入、更新、删除
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;//初始化方法
-(BOOL)createTableWithSql:(const char *)sql_stmt;//新建表

@end
