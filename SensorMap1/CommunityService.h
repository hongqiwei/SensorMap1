//
//  CommunityService.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityService : NSObject

+(BOOL)showByUserName:(NSString *)username
                error:(NSError **)error;

+ (NSArray *)getShareListWithUserName:(NSString *)username
                             error:(NSError *__autoreleasing *)error;


@end
