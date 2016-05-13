//
//  CommunityService.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "CommunityService.h"
#import "CallWebServiceUtil.h"

@implementation CommunityService

+(BOOL)showByUserName:(NSString *)username
                error:(NSError *__autoreleasing *)error{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:username forKey:@"username"];
    NSData *resultData = [CallWebServiceUtil remoteCallByUrl:@"/community" MethodParams:params error:error];
    NSString *tmp = [[NSString alloc]initWithData:resultData encoding:(NSUTF8StringEncoding)];
    NSLog(@"tmp1:%@",tmp );
    
    //tmp = @"\"{\"result\":\"success\"}\"";
    
    if (*error) {
        NSLog(@"调用服务器错误：%@",[*error localizedDescription]);
        return NO;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:error];
    if(*error){
        NSLog(@"解析错误!%@",*error);
        return NO;
    }
    NSString *result = [dictionary objectForKey:@"result"];
    if([@"success" isEqualToString:result]){
//        NSString *roadname = [dictionary objectForKey:@"roadname"];
//        NSString *sensordata = [dictionary objectForKey:@"sensordata"];
//        NSString *measuredate = [dictionary objectForKey:@"measuredate"];
//        NSString *shareuser = [dictionary objectForKey:@"shareuser"];
//        NSString *sharedate = [dictionary objectForKey:@"sharedate"];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:roadname forKey:@"roadname"];
//        [defaults setObject:sensordata forKey:@"sensordata"];
//        [defaults setObject:measuredate forKey:@"measuredate"];
//        [defaults setObject:shareuser forKey:@"shareuser"];
//        [defaults setObject:sharedate forKey:@"sharedate"];
        return YES;
    }else{
        return NO;
    }

    
}

+ (NSArray *)getShareListWithUserName:(NSString *)username
                             error:(NSError *__autoreleasing *)error{
    NSArray *shareList;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:username forKey:@"username"];
    NSData *resultData = [CallWebServiceUtil remoteCallByUrl:@"/getShareList" MethodParams:params error:error];
    
    NSString *tmp = [[NSString alloc]initWithData:resultData encoding:(NSUTF8StringEncoding)];
    //NSString *tmp = [[NSString alloc]initWithUTF8String:resultData];
    NSLog(@"tmp2:%@",tmp );
    
    if(*error){
        NSLog(@"调用服务器错误:%@",[*error localizedDescription]);
        return shareList;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:error];
    if(*error){
        NSLog(@"解析错误!");
        return shareList;
    }
    /*
     *服务端未返回result
     *服务端list存储数据有误
     */
    NSString *result = [dictionary objectForKey:@"result"];
    NSLog(@"result:%@",result);
    if([@"success" isEqualToString:result]){
        shareList = [dictionary objectForKey:@"share_pengyouquan"];
        NSLog(@"sharelist:%@",shareList);
    }
    
    return shareList;
    
}




@end
