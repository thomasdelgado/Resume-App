//
//  TDSections.m
//  TDResume
//
//  Created by Thomas Delgado on 4/12/14.
//  Copyright (c) 2014 Thomas Delgado. All rights reserved.
//

#import "TDSection.h"
#import "UIColor+HexString.h"

@implementation TDSection


-(id)initWithName:(NSString*) name
  withColorString:(NSString*) colorString
       withHeight:(NSInteger) height
{
    self = [super init];
    if (self) {
        self.name = name;
        self.color = [UIColor colorWithHexString:colorString];
        self.height = height;
    }
    return self;
}

+(NSMutableArray*) loadSections
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    TDSection *section = [[TDSection alloc] initWithName:@"About"
                                         withColorString:@"#00b6d8"
                                              withHeight:425];
    [result addObject:section];
    section = [[TDSection alloc] initWithName:@"Experience"
                              withColorString:@"#148ffd"
                                   withHeight:820];
    [result addObject:section];
    section = [[TDSection alloc] initWithName:@"Education"
                              withColorString:@"#5964f4"
                                   withHeight:400];
    [result addObject:section];
    section = [[TDSection alloc] initWithName:@"Technical Skills"
                              withColorString:@"#9b42dd"
                                   withHeight:350];
    [result addObject:section];
    
    section = [[TDSection alloc] initWithName:@"Projects & Publications"
                              withColorString:@"#de338e"
                                   withHeight:350];
    [result addObject:section];

    section = [[TDSection alloc] initWithName:@"Volunteer Experience"
                              withColorString:@"#ff4b5a"
                                   withHeight:200];
    [result addObject:section];
    section = [[TDSection alloc] initWithName:@"Contact Info"
                              withColorString:@"#ff8841"
                                   withHeight:250];
    [result addObject:section];
    
    
    
    return result;
}

@end
