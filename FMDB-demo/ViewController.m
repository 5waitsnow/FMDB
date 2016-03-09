//
//  ViewController.m
//  FMDB-demo
//
//  Created by Crazy on 15/11/20.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "ViewController.h"
//#import "FMDatabase.h"
//#import "FMDatabaseQueue.h"
#import "FMDB.h"
@interface ViewController ()
@property (nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.db= [FMDatabase databaseWithPath:@"/Users/apple/Desktop/data.db"];
//    
//    if ([self.db open]) {
//        NSLog(@"数据库打开成功");
//        NSString *creatDB = @"CREATE TABLE IF NOT EXISTS PERSON (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,AGE INT,SEX TEXT)";
//        BOOL c = [self.db executeUpdate:creatDB];
//        if (c) {
//            NSLog(@"创建表成功");
//        }else{
//            NSLog(@"创建表失败");
//        }
//        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM PERSON WHERE ID = 2"];
//        [rs next];
//        for (int i = 1; i <= 4; i++) {
//            UITextField *tf = [self.view viewWithTag:i];
//            
//            switch (tf.tag) {
//                case 1:
//                    tf.text = [rs stringForColumn:@"ID"];
//                    break;
//                case 2:
//                    tf.text = [rs stringForColumn:@"NAME"];
//                    break;
//                case 3:
//                    tf.text = [rs stringForColumn:@"AGE"];
//                    break;
//                break;
//                    default:
//                    tf.text = [rs stringForColumn:@"SEX"];
//                    break;
//            }
//        }
//        
//    }
//    
//    [self.db close];
}
- (IBAction)save:(UIBarButtonItem *)sender {
    //多线程操作
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:@"/Users/apple/Desktop/data.db"];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    FMDatabase *db = [FMDatabase databaseWithPath:@"/Users/apple/Desktop/data.db"];
    
    dispatch_async(q1, ^{
        for (int i = 0; i<=10; i++) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"INSERT INTO PERSON (NAME,AGE,SEX) VALUES (1,1,1)";
                [db executeUpdate:sql];
            }];
        }
    });

    
    dispatch_async(q2, ^{
        for (int i = 0; i<=10; i++) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"INSERT INTO PERSON (NAME,AGE,SEX) VALUES (2,2,2)";
                [db executeUpdate:sql];
            }];
        }
    });
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        *rollback = YES;
        for (int i = 0; i<=20; i++) {
            NSString *sql = @"INSERT INTO PERSON (NAME,AGE,SEX) VALUES (3,3,3)";
            [db executeUpdate:sql];
        }
        
    }];
    [self.db close];
    
//    if ([self.db open]) {
//        NSMutableArray *personInfo = [NSMutableArray array];
//        for (int i = 2; i <= 4; i++) {
//            UITextField *tf = [self.view viewWithTag:i];
//            [personInfo addObject:tf.text];
//        }
//        NSString *str = [NSString stringWithFormat:@"INSERT INTO PERSON (NAME,AGE,SEX) VALUES (%@,%@,%@)",personInfo[0],personInfo[1],personInfo[2]];
//        [self.db executeUpdate:str];
//    }
//    [self.db close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
