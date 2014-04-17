//
//  TDSections.h
//  TDResume
//
//  Created by Thomas Delgado on 4/12/14.
//  Copyright (c) 2014 Thomas Delgado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSection : NSObject
@property (nonatomic) NSString* name;
@property (nonatomic) UIColor* color;
@property (nonatomic) NSInteger height;

-(id)initWithName:(NSString*) name
  withColorString:(NSString*) colorString
       withHeight:(NSInteger) height;

+(NSMutableArray*) loadSections;


@end
