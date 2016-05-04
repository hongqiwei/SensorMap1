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

+ (NSArray *)getShareListWitherror:(NSError **)error;

+ (bool)showByRoadName:(NSString *)roadname
               AndSensorData:(NSString *)sensordata
                    AndMeasureDate:(NSString *)measuredate
                        AndShareUser:(NSString *)username
                            AndShareDate:(NSString *)sharedate
                                error:(NSError **)error;

@end
