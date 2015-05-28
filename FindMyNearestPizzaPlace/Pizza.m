//
//  pizza.m
//  FindMyNearestPizzaPlace
//
//  Created by Alex Santorineos on 5/28/15.
//  Copyright (c) 2015 madApperz. All rights reserved.
//

#import "Pizza.h"

@implementation Pizza

-(instancetype)initWithPizzaPlace:(NSString *)name andMilesDifference:(float)milesDifference{
    self = [super init];
    if (self) {
        self.name = name;
        self.milesDifference = milesDifference;
    }

    return self;
}


@end
