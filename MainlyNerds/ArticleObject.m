//
//  ArticleObject.m
//  MainlyNerds
//
//  Created by Lorenzo on 4/15/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import "ArticleObject.h"

@implementation ArticleObject

+(id)initWithArticle:(id)post
{
    return [[ArticleObject alloc] initWithArticle:post];
}

-(id)initWithArticle:(id)post
{
    if(self = [super init])
    {
        _postID = [[post objectForKey:@"id"] intValue];
        _postTitle = [[post objectForKey:@"title_plain"] stringByDecodingHTMLEntities];
        _postContent = [post objectForKey:@"content"];
        _postThumbnail = [[[post objectForKey:@"thumbnail_images"] objectForKey:@"blog-large-thumb"] objectForKey:@"url"];
        _postURL = [post objectForKey:@"url"];
        _postAuthor = [[[post objectForKey:@"author"] objectForKey:@"name"] stringByDecodingHTMLEntities];
        _postCommentCount = [[post objectForKey:@"comment_count"] intValue];
        
        NSString *date = [post objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _postDate = [formatter dateFromString:date];
        
        _postImage = [[[post objectForKey:@"thumbnail_images"] objectForKey:@"full"] objectForKey:@"url"];
        _postExcerpt = [[post objectForKey:@"excerpt"] stringByConvertingHTMLToPlainText];
        _postCategories = [post objectForKey:@"categories"];
        
        NSArray *videoArray = [[post objectForKey:@"custom_fields"] objectForKey:@"ct_mb_post_video_file"];
        NSArray *videoTypeArray = [[post objectForKey:@"custom_fields"] objectForKey:@"ct_mb_post_video_type"];

        // if a video post from youtube, this will be populated, otherwise it's left blank
        if(videoArray && [[videoTypeArray firstObject] isEqualToString:@"youtube"])
            _postVideoCode = [videoArray firstObject];
        else
            _postVideoCode = nil;
        
        NSArray *viewCount = [[post objectForKey:@"custom_fields"] objectForKey:@"post_views_count"];
        if(viewCount)
        {
            _postViewCount = [[videoArray firstObject] intValue];
        }
        //tags = array of dicts
        //comment_status - string open/closed
        //type - string post/?
        //categories - array of dicts (slug/title)
    }
    
    return self;
}

@end
