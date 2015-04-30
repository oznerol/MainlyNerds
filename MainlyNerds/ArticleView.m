//
//  ArticleView.m
//  MainlyNerds
//
//  Created by Lorenzo on 4/23/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import "ArticleView.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>


@implementation ArticleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(id)initWithFrame:(CGRect)frame
{
    return [[ArticleView alloc] initWithFrame:frame];
}

+(id)initWithFrame:(CGRect)frame andArticle:(ArticleObject*)article andImage:(UIImage*)image
{
    //ArticleView *myArticle = [[ArticleView alloc] initWithFrame:frame];
    ArticleView *myArticle = [[ArticleView alloc] init];
    myArticle.article = article;
    myArticle.headerImage = image;
    
    [myArticle baseInit];
    return myArticle;
}

-(IBAction)prevArticle:(id)sender
{
    id<ArticleViewDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(prevArticle)])
    {
        [strongDelegate prevArticle];
    }
}

-(IBAction)nextArticle:(id)sender
{
    id<ArticleViewDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(nextArticle)])
    {
        [strongDelegate nextArticle];
    }
}

-(void)baseInit
{
    //self.layer.cornerRadius = 12.5f;
    self.layer.borderWidth = 1.0f;
    
    
    
    if(_article)
    {
        NSLog(@"loading article info!");
        UIFont *font = [UIFont fontWithName:@"Avenir Book" size:20.0f];
        
        NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:%@; font-size: %i\">%@</span>",
                                font.familyName,
                                (int) font.pointSize,
                                [_article.postContent stringByDecodingHTMLEntities]];
        
        _webView.delegate = self;
        [_webView loadHTMLString:htmlString baseURL:nil];
        
        if(_headerImage)
            [_headerImageView setImage:_headerImage];
        else
        {
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_article.postImage]
                                placeholderImage:nil];
        }
        
        _headerText.text = _article.postTitle;
        _authorLabel.text = _article.postAuthor;
        _dateLabel.text = [_article.postDate timeAgoSinceDate:[NSDate date] numericDates:YES numericTimes:YES];
        
        NSString *cats = @"";
        int count = 0;
        for(NSDictionary *dict in _article.postCategories)
        {
            count++;
            if(count >= _article.postCategories.count)
            {
                cats = [cats stringByAppendingFormat:@"%@", [dict objectForKey:@"title"]];
            }
            else
            {
                cats = [cats stringByAppendingFormat:@"%@, ", [dict objectForKey:@"title"]];
            }
        }
        _categoriesLabel.text = cats;
    }
}

-(void)loadNavigation:(NSString*)prevTitle nextTitle:(NSString*)nextTitle
{
    if(prevTitle)
    {
        _prevButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        _prevButton.titleLabel.numberOfLines = 3;
        _prevButton.titleLabel.minimumScaleFactor = 0.75f;
        _prevButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        NSString *title = [NSString stringWithFormat:@"Previous Post:\n%@", prevTitle];
        [_prevButton setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        _prevButton.hidden = YES;
    }
    
    if(nextTitle)
    {
        _nextButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        _nextButton.titleLabel.numberOfLines = 3;
        _nextButton.titleLabel.minimumScaleFactor = 0.5f;
        _nextButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        NSString *title = [NSString stringWithFormat:@"Next Post:\n%@", nextTitle];
        [_nextButton setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        _nextButton.hidden = YES;
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    /*
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
     */

}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

-(IBAction)shareArticle:(id)sender
{
    _shareBubbles = [[AAShareBubbles alloc] initCenteredInWindowWithRadius:160];
    _shareBubbles.delegate = self;
    _shareBubbles.bubbleRadius = 45; // Default is 40
    _shareBubbles.showFacebookBubble = YES;
    _shareBubbles.showTwitterBubble = YES;
    _shareBubbles.showMailBubble = YES;
    _shareBubbles.showGooglePlusBubble = YES;
    _shareBubbles.showTumblrBubble = NO;
    _shareBubbles.showVkBubble = NO;
    
    [_shareBubbles show];
}


-(IBAction)closeArticle:(id)sender
{
    id<ArticleViewDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(goBack)])
    {
        [strongDelegate goBack];
    }
}

-(id)init
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ArticleView" owner:self options:nil];
    self = [subviewArray objectAtIndex:0];
    //[self baseInit];
    return self;
    
    /*
    self = [super init];
    if (self) {
        [self baseInit];
    }
    
    return self;*/
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

#pragma mark Sharebutton Delegate
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType
{
    NSString *text;
    
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            text = @"MainlyNerds wants to friend you.";
            break;
        case AAShareBubbleTypeTwitter:
            text = @"#fuckyou";
            break;
        case AAShareBubbleTypeMail:
            text = @"You want to email this!?";
            break;
        case AAShareBubbleTypeGooglePlus:
            text = @"Who still uses Google+?!";
            break;
        case AAShareBubbleTypeTumblr:
            text = @"Tumblr!? WTF is that?";
            break;
        case AAShareBubbleTypeVk:
            text = @"I don't even know what Vk is...";
            break;
        //case 100:
            // custom buttons have type >= 100
            //NSLog(@"Custom Button With Type 100");
            //break;
        default:
            text = @"Default!? You broke something.";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OH SHIT!"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"Go away"
                                          otherButtonTitles:nil];
    [alert show];

}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)bubbles {
    //NSLog(@"All Bubbles hidden");
}



@end
