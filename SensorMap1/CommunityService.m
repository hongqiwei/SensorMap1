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
    
    if (*error) {
        NSLog(@"调用服务器错误：%@",[*error localizedDescription]);
        return NO;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:error];
    if(*error){
        NSLog(@"解析错误!");
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

+ (bool)showByRoadName:(NSString *)roadname
         AndSensorData:(NSString *)sensordata
            AndMeasureDate:(NSString *)measuredate
                AndShareUser:(NSString *)shareuser
                    AndShareDate:(NSString *)sharedate
                        error:(NSError *__autoreleasing *)error{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:roadname forKey:@"roadname"];
    [params setObject:sensordata forKey:@"sensordata"];
    [params setObject:measuredate forKey:@"measuredate"];
    [params setObject:shareuser forKey:@"shareuser"];
    [params setObject:sharedate forKey:@"sharedate"];
    NSData *resultData = [CallWebServiceUtil remoteCallByUrl:@"/community" MethodParams:params error:error];
    
    if (*error) {
        NSLog(@"调用服务器错误：%@",[*error localizedDescription]);
        return NO;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:error];
    if(*error){
        NSLog(@"解析错误!");
        return NO;
    }
    NSString *result = [dictionary objectForKey:@"result"];
    if([@"success" isEqualToString:result]){
        NSString *roadname = [dictionary objectForKey:@"roadname"];
        NSString *sensordata = [dictionary objectForKey:@"sensordata"];
        NSString *measuredate = [dictionary objectForKey:@"measuredate"];
        NSString *shareuser = [dictionary objectForKey:@"shareuser"];
        NSString *sharedate = [dictionary objectForKey:@"sharedate"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:roadname forKey:@"roadname"];
        [defaults setObject:sensordata forKey:@"sensordata"];
        [defaults setObject:measuredate forKey:@"measuredate"];
        [defaults setObject:shareuser forKey:@"shareuser"];
        [defaults setObject:sharedate forKey:@"sharedate"];
        return YES;
    }else{
        return NO;
    }
}

@end
