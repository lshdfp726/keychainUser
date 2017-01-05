//
//  KeychainWrapper.h
//  KeyChain
//
//  Created by 刘松洪 on 2016/11/16.
//  Copyright © 2016年 刘松洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject

@property (strong, nonatomic) NSMutableDictionary *keychainData;
@property (strong, nonatomic) NSMutableDictionary *genericPasswordQuery;


+ (id)load:(NSString *)service;
+ (BOOL)delete:(NSString *)service;


+ (void)save:(NSString *)service withString:(NSString *)data withDataUsingEncoding:(NSStringEncoding)encoding;
+ (void)save:(NSString *)service withDictionary:(NSDictionary *)data;
+ (void)save:(NSString *)service data:(id)data;
@end
