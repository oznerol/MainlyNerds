//
//  ArticleObject.h
//  MainlyNerds
//
//  Created by Lorenzo on 4/15/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWFeedParser/NSString+HTML.h>

@interface ArticleObject : NSObject
{
    
}

@property (nonatomic) int postID;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *postContent;
@property (nonatomic, strong) NSString *postThumbnail;
@property (nonatomic, strong) NSString *postURL;
@property (nonatomic, strong) NSString *postAuthor;
@property (nonatomic) int postCommentCount;
@property (nonatomic) int postViewCount;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postImage;
@property (nonatomic, strong) NSString *postExcerpt;
@property (nonatomic, strong) NSString *postVideoCode;
@property (nonatomic, strong) NSArray *postCategories;

+(id)initWithArticle:(id)post;
@end
