//
//  ShareService.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/4.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareService : NSObject


+ (bool)shareByUserName:(NSString *)username
               AndShareDate:(NSString *)sharedate
                    AndRoadName:(NSString *)roadname
                        AndSensorData:(NSString *)sensordata
                            AndMeasureDate:(NSString *)measuredate
                                error:(NSError **)error;

@end
