//
//  KeychainWrapper.m
//  KeyChain
//
//  Created by 刘松洪 on 2016/11/16.
//  Copyright © 2016年 刘松洪. All rights reserved.
//

#import "KeychainWrapper.h"
#import <Security/Security.h>


static NSString *const kIdentifier = @"com.lsh726..KeyChain";//唯一标识

/*
 // 查询
 OSStatus SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result);
 
 // 添加
 OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result);
 
 // 更新
 KeyChain中的ItemOSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);
 
 // 删除
 KeyChain中的ItemOSStatus SecItemDelete(CFDictionaryRef query)
 
 */

@implementation KeychainWrapper


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword  , (id)kSecClass ,
                                                              kIdentifier, (id)kSecAttrGeneric ,
                                                              service , (id)kSecAttrAccount,
                                                              (id)kSecAttrAccessibleWhenUnlocked , (id)kSecAttrAccessible ,
                                                              nil];
}


#pragma mark - 字符串
+ (void)save:(NSString *)service withString:(NSString *)data withDataUsingEncoding:(NSStringEncoding)encoding {
    [self save:service data:[data dataUsingEncoding:encoding]];
}

//字典
+ (void)save:(NSString *)service withDictionary:(NSDictionary *)data {
    [self save:service data:[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil]];
}


+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychinQuery = [self getKeychainQuery:service];
    //删除旧的item
    OSStatus result = 0;
    result          = SecItemDelete((CFDictionaryRef)keychinQuery);
    //设置新的值
    [keychinQuery setObject:data forKey:(id)kSecValueData];
    
     CFDataRef keyData = NULL;
     result            =  SecItemAdd((CFDictionaryRef)keychinQuery, (CFTypeRef *)&keyData);
    
    if (result == 0) {
        NSLog(@"操作成功");
    }else {
        NSLog(@"操作失败");
    }
}


+ (id)load:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    NSLog(@"%@",[keychainQuery objectForKey:(id)kSecAttrGeneric]);
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@",service, exception);
        } @finally {
            
        }
    }
    NSData *resultData = [[NSData alloc]initWithData:(__bridge NSData *)keyData];
    CFRelease(keyData);//要手动释放CF相关数据
    return resultData;
}


+ (BOOL)delete:(NSString *)service {
    BOOL result = NO;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    if(SecItemDelete((CFDictionaryRef)keychainQuery) == noErr) {
        result  = YES;
    } else {
        result  = NO;
    }
    return result;
}



@end
