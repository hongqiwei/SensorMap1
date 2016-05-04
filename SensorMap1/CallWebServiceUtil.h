//
//  CallWebServiceUtil.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/2.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallWebServiceUtil : NSObject

+ (NSData *)remoteCallByUrl:(NSString *)methodURL
                 MethodParams:(NSDictionary *)methodParams
                        error:(NSError **) error;

@end
