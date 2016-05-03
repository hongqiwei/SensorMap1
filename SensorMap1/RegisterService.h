//
//  RegisterService.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/3.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterService : NSObject

+ (bool)registerByUserName:(NSString *)username
            AndPassword:(NSString *)password
                  error:(NSError **)error;

@end
