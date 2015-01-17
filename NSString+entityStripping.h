//
//  NSString+entityStripping.h
//  Stylist
//
//  Created by Rob Stearn on 15/01/2015.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (entityStripping)

+ (NSString *)stringByStrippingMarkupEntitiesFromString:(NSString *)string;

@end
