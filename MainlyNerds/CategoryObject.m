//
//  CategoryObject.m
//  MainlyNerds
//
//  Created by Lorenzo on 4/30/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import "CategoryObject.h"

@implementation CategoryObject

+(id)initWithCategory:(id)cat
{
    return [[CategoryObject alloc] initWithCategory:cat];
}

-(id)initWithCategory:(id)cat
{
    if(self = [super init])
    {
        _catID = [[cat objectForKey:@"id"] intValue];
        _catSlug = [cat objectForKey:@"slug"];
        _catTitle = [cat objectForKey:@"title"];
        _catPostCount = [[cat objectForKey:@"post_count"] intValue];
        _catParentID = [[cat objectForKey:@"parent"] intValue];
        
        _catChildren = [NSMutableArray array];
    }
    
    return self;
}

@end
