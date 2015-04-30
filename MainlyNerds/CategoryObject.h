//
//  CategoryObject.h
//  MainlyNerds
//
//  Created by Lorenzo on 4/30/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWFeedParser/NSString+HTML.h>

@interface CategoryObject : NSObject
{
    
}

@property (nonatomic) int catID;
@property (nonatomic, strong) NSString *catSlug;
@property (nonatomic, strong) NSString *catTitle;
@property (nonatomic) int catPostCount;
@property (nonatomic) int catParentID;
@property (nonatomic, strong) NSMutableArray *catChildren;


+(id)initWithCategory:(id)cat;

@end
