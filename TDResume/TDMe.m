//
//  TDMe.m
//  TDResume
//
//  Created by Thomas Delgado on 4/13/14.
//  Copyright (c) 2014 Thomas Delgado. All rights reserved.
//

#import "TDMe.h"

@implementation TDMe


-(id) init
{
    self = [super init];
    if (self)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MyInfo" ofType:@"plist"];
        _info = [[ NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return self;
}

@end
