//
//  ArticleView.h
//  MainlyNerds
//
//  Created by Lorenzo on 4/23/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <WebKit/WebKit.h>
#import "AAShareBubbles.h"
#import "HTMLLabel.h"
#import "AFNetworking.h"
#import <MWFeedParser/NSString+HTML.h>
#import <DateTools.h>

@protocol ArticleViewDelegate <NSObject>

- (void)goBack;
-(void)nextArticle;
-(void)prevArticle;
@end

@interface ArticleView : UIView <UIWebViewDelegate, AAShareBubblesDelegate, UITextViewDelegate>


@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic, strong) NSArray *contentViews;



@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UILabel *headerText;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) UIImage *headerImage;
@property (strong, nonatomic) ArticleObject *article;


@property (nonatomic, strong) IBOutlet UIButton *prevButton;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;

@property (nonatomic, weak) id<ArticleViewDelegate> delegate;

@property (nonatomic, strong) AAShareBubbles *shareBubbles;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

-(IBAction)closeArticle:(id)sender;
-(void)loadNavigation:(NSString*)prevTitle nextTitle:(NSString*)nextTitle;

+(id)initWithFrame:(CGRect)frame;
+(id)initWithFrame:(CGRect)frame andArticle:(ArticleObject*)article andImage:(UIImage*)image;

@end
