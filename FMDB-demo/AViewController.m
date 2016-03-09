//
//  AViewController.m
//  FMDB-demo
//
//  Created by Crazy on 15/11/23.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "AViewController.h"
#import <sqlite3.h>
@interface AViewController ()
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(UIBarButtonItem *)sender {
    
    sqlite3 *db;
    NSString *path = @"/Users/apple/Desktop/data.db";
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
    
    if (sqlite3_exec(db, "BEGIN", NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"事务启动成功");
        NSString *sql = @"SELECT * FROM PERSON WHERE NAME = '2'";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                int i = 0;
                while (i < 4) {
                    char *data = (char *)sqlite3_column_text(stmt, i);
                    UITextField *tf = [self.view viewWithTag:i+1];
                    
                    NSLog(@"%s",data);
                    tf.text = [NSString stringWithUTF8String:data];
                    
                    i++;
                }
                
                
            }
        }
    }
    
    if (sqlite3_exec(db, "COMMIT", NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"发送成功");
    }
    
    
    sqlite3_close(db);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
