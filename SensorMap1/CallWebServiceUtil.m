//
//  CallWebServiceUtil.m
//  FindCarClient
//
//  Created by 兰天 on 16/3/8.
//  Copyright © 2016年 兰天. All rights reserved.
//

#import "CallWebServiceUtil.h"
#import "AppDelegate.h"

@interface CallWebServiceUtil()
@end

@implementation CallWebServiceUtil

/**
 *  网络请求,同步方法
 */
+ (NSData *)remoteCallByUrl:(NSString *)methodURL
                  MethodParams:(NSMutableDictionary *)methodParams
                              error:(NSError *__autoreleasing*)error{
    NSString *plistPath =[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *host_dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString * remote_host_ip = [host_dict objectForKey:@"remote_host_ip"];
    NSString * remote_host_port = [host_dict objectForKey:@"remote_host_port"];
    
    NSString *host = [NSString stringWithFormat:@"http://%@:%@%@",remote_host_ip,remote_host_port,methodURL];
    host= [host stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:host];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//    //默认添加字段
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if(![methodParams objectForKey:@"phonenum"]){
//        NSString *phonenum = [defaults objectForKey:@"userName"];
//        if(!phonenum) phonenum =[[NSString alloc] init];
//        [methodParams setObject:phonenum forKey:@"phonenum"];
//    }
//    if(![methodParams objectForKey:@"access_token"]){
//        NSString *access_token = [defaults objectForKey:@"access_token"];
//        if(!access_token) access_token = [[NSString alloc] init];
//        [methodParams setObject:access_token forKey:@"access_token"];
//    }

    
    NSString *postStr = [self createPostURL:methodParams];
    NSLog(@"%@?%@",host,postStr);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5" forHTTPHeaderField:@"User-Agent"];
    request.timeoutInterval = 4.0;
    
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:error];
    return data;
}

+(NSString *)createPostURL:(NSDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

@end
