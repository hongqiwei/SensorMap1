//
//  CallWebServiceUtil.h
//  FindCarClient
//
//  Created by 兰天 on 16/3/8.
//  Copyright © 2016年 兰天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallWebServiceUtil : NSObject

+ (NSData *)remoteCallByUrl:(NSString *)methodURL
                 MethodParams:(NSDictionary *)methodParams
                        error:(NSError **) error;

@end
