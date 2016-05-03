//
//  LoginService.h
//  FindCarDriver
//
//  Created by 兰天 on 16/4/11.
//  Copyright © 2016年 兰天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

+ (bool)loginByUserName:(NSString *)username
         AndPassword:(NSString *)password
                  error:(NSError **)error;


@end
