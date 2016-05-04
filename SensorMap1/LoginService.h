//
//  LoginService.h
//  SensorMap1
//
//  Created by hongqiwei on 16/5/2.
//  Copyright © 2016年 hongqiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

+ (bool)loginByUserName:(NSString *)username
         AndPassword:(NSString *)password
                  error:(NSError **)error;


@end
