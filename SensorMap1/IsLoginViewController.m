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
                    
                    for (int n=0; n<self.dataSource.count; n++) {
                        NSString *tmp0 = [[NSString alloc]initWithFormat:@"%@",[self.dataSource objectAtIndex:n]];
                        NSLog(@"tmp0:%@",tmp0);
                        
//                        NSString *tmp1 = [[NSString alloc]initWithFormat:@"%@",[[self.dataSource objectAtIndex:n]objectAtIndex:1]];
//                        NSString *tmp2 = [[NSString alloc]initWithFormat:@"%@",[[self.dataSource objectAtIndex:n]objectAtIndex:2]];
//                        NSString *tmp3 = [[NSString alloc]initWithFormat:@"%@",[[self.dataSource objectAtIndex:n]objectAtIndex:3]];
//                        NSString *tmp4 = [[NSString alloc]initWithFormat:@"%@",[[self.dataSource objectAtIndex:n]objectAtIndex:4]];
//                        
//                        NSLog(@"分享数据：%@,%@,%@,%@,%@",tmp0,tmp1,tmp2,tmp3,tmp4);
                    }
                    
                    
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
            
            
            NSDictionary *share_str = [array objectAtIndex:i];
            NSLog(@"share_str:%@",share_str);
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[share_str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            [self.dataSource addObject:share_str];
        }
    }
    NSLog(@"朋友圈数据：%@",self.dataSource);
    
}

- (IBAction)quit:(id)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_token"];
    [defaults removeObjectForKey:@"username"];
    NSString *tmp = [defaults stringForKey:@"access_token"];
    NSLog(@"accesstoken:%@",tmp);
    
    [self performSegueWithIdentifier:@"quit" sender:self];
}
@end
