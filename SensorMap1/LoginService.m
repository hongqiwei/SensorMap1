//
//  LoginService.m
//  FindCarDriver
//
//  Created by 兰天 on 16/4/11.
//  Copyright © 2016年 兰天. All rights reserved.
//

#import "LoginService.h"
#import "CallWebServiceUtil.h"

@implementation LoginService

+ (bool)loginByUserName:(NSString *)username
            AndPassword:(NSString *)password
                  error:(NSError *__autoreleasing *)error{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    NSData *resultData = [CallWebServiceUtil remoteCallByUrl:@"/login" MethodParams:params error:error];
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
        NSString *access_token = [dictionary objectForKey:@"access_token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:access_token forKey:@"access_token"];
        [defaults setObject:username forKey:@"username"];
        return YES;
    }else{
        return NO;
    }
}


@end
