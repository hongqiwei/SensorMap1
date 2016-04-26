//
//  DBManager.m
//  SensorMap1
//
//  Created by hongqiwei on 16/4/21.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h> //导入sqlite3的头文件

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;

@end

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        //获得存储路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //数据库名
        self.databaseFilename = dbFilename;
    }
    return self;
}

//#pragma mark 建表
//-(BOOL)createTableWithSql:(const char *)sql_stmt{
//    BOOL isSuccess = YES;
//    //检查数据库文件是否已经存在
//    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
//    NSLog(@"path:%@",destinationPath);
//    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
//        sqlite3 *database = nil;
//        const char *dbpath = [destinationPath UTF8String];
//        if (sqlite3_open(dbpath, &database) == SQLITE_OK){
//            char *errMsg;
//            //
//            //const char *csql =[sql_stmt UTF8String];
//            
//            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
//                != SQLITE_OK)
//            {
//                isSuccess = NO;
//                NSLog(@"Failed to create table");
//            }
//            sqlite3_close(database);
//        }else{
//            isSuccess = NO;
//            NSLog(@"Failed to open/create table");
//        }
//    }
//    return isSuccess;
//}

#pragma mark 建表
-(void)createTable{
  
    //检查数据库文件是否已经存在
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    NSLog(@"path:%@",destinationPath);
//    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        sqlite3 *database = nil;
        const char *dbpath = [destinationPath UTF8String];
        if (sqlite3_open(dbpath, &database) != SQLITE_OK){
            sqlite3_close(database);
            NSAssert(NO,@"数据库打开失败");
        }else{
            char *errMsg;
            NSString *sql1 = [NSString stringWithFormat:@"CREATE TABLE roadData(roadInfoID integer, roadname text, datetime text, info text);"];
            NSString *sql2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS dataDetail(roadInfoID integer,secID integer,lat text,lng text,speed text,altitude text,sensordata text);"];
            
            //删除表
            //NSString *sql1 = [NSString stringWithFormat:@"DROP TABLE roadData"];
            //NSString *sql2 = [NSString stringWithFormat:@"DROP TABLE dataDetail"];
            
            const char *cSql1 = [sql1 UTF8String];
            const char *cSql2 = [sql2 UTF8String];
            if (sqlite3_exec(database, cSql1, NULL, NULL, &errMsg)!= SQLITE_OK && sqlite3_exec(database, cSql2, NULL, NULL, &errMsg)!= SQLITE_OK){
                sqlite3_close(database);
                NSAssert(NO,@"建表失败");
            }else{
                NSLog(@"建表成功");
            }
            sqlite3_close(database);

            }
        
    }
   
//}

#pragma mark 执行sql语句
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    //创建一个sqlite3对象
    sqlite3 *sqlite3Database;
    
    //设置数据库路径
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    //初始化存储结果的array
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    //初始化存储列名的array
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    //打开数据库
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        //声明一个sqlite3_stmt对象，存储查询结果
        sqlite3_stmt *compiledStatement;
        
        //将所有数据加载到内存
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            //是否是查询语句
            if (!queryExecutable){
                //用来保存每一行数据
                NSMutableArray *arrDataRow;
                
                //将结果一行行地加入到arrDataRow中
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    //初始化arrDataRow
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    //获得列数
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //读取和保存每一列数据
                    for (int i=0; i<totalColumns; i++){
                        //将数据转化为char
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        //数据不为空则加到arrDataRow中
                        if (dbDataAsChars != NULL) {
                            //将char转化为string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        //保存列名（只保存一次）
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    //如果不为空，将每行的数据保存到
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                //插入、更新、删除等操作
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    // 被改变了多少行
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // 最后插入的行id
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // 插入、更新、删除等错误
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            //打开错误
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // 释放内存
        sqlite3_finalize(compiledStatement);
        
    }
    
    // 关闭数据库
    sqlite3_close(sqlite3Database);
}

-(NSArray *)loadDataFromDB:(NSString *)query{
    // 执行查询
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // 返回查询结果
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // 执行插入、更新、删除等
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
