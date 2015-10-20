//
//  CMDataModel.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMDataModel.h"

@implementation CMDataModel

- (id)initWithEntityName:(NSString *)entityName {
    self = [super init];
    
    if (self) {
        _accessor = [[CMDataAccessor alloc] init];
        
        _dataObject = [_accessor createObjectForEntityName:entityName];
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    // camelCase-ify the string
    if ([key containsString:@"_"]) {
        NSArray *components = [key componentsSeparatedByString:@"_"];
        key = components[0];
        
        for(int i = 1; i < [components count]; ++i) {
            NSString *uppercase = [[components[i] substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            key = [key stringByAppendingString:uppercase];
            key = [key stringByAppendingString:[components[i] substringFromIndex:1]];
        }
        
         NSLog(@"%@", key);
        
        [self setValue:value forKeyPath:key];
    } else {
        if (![key hasPrefix:@"attr"]) {
            [super setValue:value forKey:key];
        } else {
            key = [key substringFromIndex:4];
            [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:0] lowercaseString]];
            [self setValue:value forKey:key];
            [_dataObject setValue:value forKey:key];
        }
    }
}

- (id)valueForKey:(NSString *)key {
    id value;
    if ([key hasPrefix:@"attr"]) {
        NSString *dataKey = [key substringFromIndex:4];
        [dataKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[dataKey substringToIndex:0] lowercaseString]];
        value = [self.dataObject valueForKey:dataKey];
    } else {
        value = [super valueForKey:key];
    }
    
    return value;
}

- (BOOL)saveObject {
    return [_accessor saveObject:self.dataObject];
}

@end
