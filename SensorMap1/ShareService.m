//
//  ShareService.m
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import "ShareService.h"
#import "CallWebServiceUtil.h"

@implementation ShareService

+ (bool)shareByUserName:(NSString *)username
           AndShareDate:(NSString *)sharedate
                AndRoadName:(NSString *)roadname
                    AndSensorData:(NSString *)sensordata
                        AndMeasureDate:(NSString *)measuredate
                            error:(NSError *__autoreleasing *)error{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:username forKey:@"username"];
    [params setObject:sharedate forKey:@"sharedate"];
    [params setObject:roadname forKey:@"roadname"];
    [params setObject:sensordata forKey:@"sensordata"];
    [params setObject:measuredate forKey:@"measuredate"];
    NSData *resultData = [CallWebServiceUtil remoteCallByUrl:@"/share" MethodParams:params error:error];
    NSString *tmp = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",tmp);
    
    if(*error){
        NSLog(@"调用服务器错误:%@",[*error localizedDescription]);
        return NO;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:error];
    if(*error){
        NSLog(@"解析错误!");
        return NO;
    }
    NSString *result = [dictionary objectForKey:@"result"];
    if([@"success" isEqualToString:result]){
        
        return YES;
    }else{
        return NO;
    }

}

@end
