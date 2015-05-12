//
//  ViewController.m
//  MainlyNerds
//
//  Created by Lorenzo on 4/13/15.
//  Copyright (c) 2015 Smugbit Studios. All rights reserved.
//

#import "ViewController.h"


#define CELL_COUNT          7
#define CELL_HEIGHT_MAX     120
#define CELL_HEIGHT_MIN     80
#define COLUMN_COUNT        2

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
    [self.navigationItem setLeftBarButtonItem:_menuButton animated:NO];
    
    _closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    _closeButton.tintColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont fontWithName:@"Avenir Book" size:17.0f];
    [_menuButton setTitleTextAttributes:@{NSFontAttributeName: font}
                               forState:UIControlStateNormal];
    [_closeButton setTitleTextAttributes:@{NSFontAttributeName: font}
                                forState:UIControlStateNormal];
    
    
    _closeButton.enabled = YES;
    _menuButton.enabled = YES;
    _shareButton.enabled = YES;
    
    articleArray = [NSMutableArray array];
    categoryArray = [NSMutableArray array];
    
    loadURL = @"";
    
    _feedItem = [[ArticleObject alloc] init];
    _cellArray = [NSMutableArray array];
    _menuDict = [NSMutableDictionary dictionary];
    
    self.articleCollectionView.delegate = self;
    self.articleCollectionView.dataSource = self;

    UIImage *image = [UIImage imageNamed:@"bg.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.articleCollectionView.backgroundColor = [UIColor clearColor];
    self.articleCollectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"logo_small.png"]];
    logoView.frame = CGRectMake(logoView.frame.origin.x,
                                logoView.frame.origin.y,
                                logoView.frame.size.width,
                                self.navigationController.navigationBar.frame.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = logoView;
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                              forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:.5f green:.5f blue:.5f alpha:.1f]];
    //self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];

    
    currentPage = 0;
    currentArticleIndex = 0;
    maxArticles = 1;
    maxPages = 1;
    
    
    

    [self reset];
    [self downloadMenuItems];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // hide menu
    CGRect f = _menuView.frame;
    f.origin.x = -f.size.width;
    _menuView.frame = f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

#pragma mark Loading Screen
-(void)showLoading
{
    _grayView.hidden = false;
}

-(void)hideLoading
{
    _grayView.hidden = true;
}



#pragma mark Menu UI
-(IBAction)toggleMenu:(id)sender
{
    _menuView.hidden = false;
    if(_menuView.frame.origin.x >=0)
    {
        _articleCollectionView.userInteractionEnabled = true;
        [self hideMenu];
    }
    else
    {
        _articleCollectionView.userInteractionEnabled = false;
        [self showMenu];
    }
}

- (void) showMenu
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = _menuView.frame;
    f.origin.x = 0;
    _menuView.frame = f;
    [UIView commitAnimations];
}

- (void) hideMenu
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = _menuView.frame;
    f.origin.x = -f.size.width;
    _menuView.frame = f;
    [UIView commitAnimations];
}


#pragma mark Actions

-(IBAction)shareArticle:(id)sender
{
    _shareBubbles = [[AAShareBubbles alloc] initCenteredInWindowWithRadius:160];
    _shareBubbles.delegate = _myArticleView;
    _shareBubbles.bubbleRadius = 45; // Default is 40
    _shareBubbles.showFacebookBubble = YES;
    _shareBubbles.showTwitterBubble = YES;
    _shareBubbles.showMailBubble = YES;
    _shareBubbles.showGooglePlusBubble = YES;
    _shareBubbles.showTumblrBubble = NO;
    _shareBubbles.showVkBubble = NO;
    
    [_shareBubbles show];
}

-(void)reset
{
    articleArray = [NSMutableArray array];
    currentArticleIndex = 0;
    currentPage = 0;
    _myArticleView = nil;
    _myArticleCell = nil;
    _cellSizes = nil;
    maxArticles = 1;
    maxPages = 1;
    currentID = 0;
    
    [[self.navigationItem.titleView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    loadURL = [NSString stringWithFormat:@"http://mainlynerds.com/api/get_recent_posts?count=%d", CELL_COUNT];
    
    [self populateMenu];
    [self more];
}

-(void)more
{
    // add extra 2 cells for loading cell
    [self addCellSizes:CELL_COUNT+2];
    currentPage++;
    
    // increase the current page before requesting
    // since currentPage starts at 0, but paging starts at 1
    NSString *url = [loadURL stringByAppendingFormat:@"&page=%d", currentPage];
    
    [self downloadArticlesWithURL:url];
}

-(IBAction)goBack
{
    [_collection setScrollEnabled:true];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
    //_closeButton.enabled = NO;
    //_menuButton.enabled = YES;
    
    [UIView animateWithDuration:0.5
            delay:0
            options:UIViewAnimationOptionAllowAnimatedContent//(UIViewAnimationOptionAllowUserInteraction)
            animations:^
            {
                _myArticleCell.frame = _myArticleCell.origRect;
                _myArticleView.frame = _myArticleCell.origRect;

                [UIView transitionFromView:_myArticleView
                                 toView:_myArticleCell.contentView
                               duration:0.5f
                                options:UIViewAnimationOptionTransitionFlipFromLeft
                             completion:^(BOOL finished) {
                                 if(finished)
                                 {
                                     _grayView.hidden = true;
                                     if(_myArticleView)
                                     {
                                         [_myArticleView removeFromSuperview];
                                         _myArticleView = nil;
                                     }
                                     
                                     [self.navigationItem setLeftBarButtonItem:_menuButton animated:YES];
                                     //[_collection reloadData];
                                 }
                                 //NSLog(@"animation end");
                             }];
            }
            completion:^(BOOL finished)
            {
             
            }
     ];
}

-(void)prevArticle
{
    ArticleView *view = [ArticleView initWithFrame:_myArticleView.frame andArticle:articleArray[currentArticleIndex-1] andImage:nil];
    
    //NSIndexPath *path = [NSIndexPath indexPathForItem:currentArticleIndex-1 inSection:1];
    //_myArticleCell = (ArticleCollectionViewCell*)[_collection cellForItemAtIndexPath:path];
    //_myArticleCell.origRect = _myArticleCell.frame;
    
    view.frame = CGRectMake(-_myArticleView.frame.size.width-20.0f,
                            0,
                            _myArticleView.frame.size.width,
                            _myArticleView.frame.size.height);
    
    
    currentArticleIndex--;
    
    [_myArticleView.superview addSubview:view];
    [_myArticleView.superview bringSubviewToFront:view];
    
    NSString *prevTitle = nil;
    NSString *nextTitle = nil;
    if(currentArticleIndex > 0)
    {
        ArticleObject *obj = articleArray[currentArticleIndex - 1];
        prevTitle = obj.postTitle;
    }
    if(currentArticleIndex < articleArray.count-1)
    {
        ArticleObject *obj = articleArray[currentArticleIndex + 1];
        nextTitle = obj.postTitle;
    }
    
    [view loadNavigation:prevTitle nextTitle:nextTitle];
    
    view.delegate = self;
    
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent//(UIViewAnimationOptionAllowUserInteraction)
                     animations:^
     {
         _myArticleView.frame = CGRectMake(_myArticleView.frame.size.width,
                                 0,
                                 _myArticleView.frame.size.width,
                                 _myArticleView.frame.size.height);
         ;
         view.frame = CGRectMake(0,
                                 0,
                                 _myArticleView.frame.size.width,
                                 _myArticleView.frame.size.height);
         
         
     }
                     completion:^(BOOL finished)
     {
         [_myArticleView removeFromSuperview];
         _myArticleView = view;
     }
     ];
}

-(void)nextArticle
{
    ArticleView *view = [ArticleView initWithFrame:_myArticleView.frame andArticle:articleArray[currentArticleIndex+1] andImage:nil];
    
    //NSIndexPath *path = [NSIndexPath indexPathForItem:currentArticleIndex+1 inSection:1];
    //_myArticleCell = (ArticleCollectionViewCell*)[_collection cellForItemAtIndexPath:path];
    //_myArticleCell.origRect = _myArticleCell.frame;
    
    
    currentArticleIndex++;
    
    [_myArticleView.superview addSubview:view];
    [_myArticleView.superview bringSubviewToFront:view];
    
    NSString *prevTitle = nil;
    NSString *nextTitle = nil;
    if(currentArticleIndex > 0)
    {
        ArticleObject *obj = articleArray[currentArticleIndex - 1];
        prevTitle = obj.postTitle;
    }
    if(currentArticleIndex < articleArray.count-1)
    {
        ArticleObject *obj = articleArray[currentArticleIndex + 1];
        nextTitle = obj.postTitle;
    }
    
    [view loadNavigation:prevTitle nextTitle:nextTitle];
    
    view.delegate = self;
    view.frame = CGRectMake(_myArticleView.frame.size.width+20.0f,
                            0,
                            _myArticleView.frame.size.width,
                            _myArticleView.frame.size.height);
    
    
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent//(UIViewAnimationOptionAllowUserInteraction)
                     animations:^
     {
         _myArticleView.frame = CGRectMake(-_myArticleView.frame.size.width,
                                           0,
                                           _myArticleView.frame.size.width,
                                           _myArticleView.frame.size.height);
         ;
         view.frame = CGRectMake(0,
                                 0,
                                 _myArticleView.frame.size.width,
                                 _myArticleView.frame.size.height);
         
         
     }
                     completion:^(BOOL finished)
     {
         [_myArticleView removeFromSuperview];
         _myArticleView = view;
     }
     ];
}

#pragma mark Downloading

-(void)downloadArticlesWithURL:(NSString*)url
{
    //url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self hideMenu];
    [self showLoading];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        [self populateArticles:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"article dl error: %@",  operation.responseString);
        
    }];
}

-(void)downloadMenuItems
{
    //url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSString *url = @"http://mainlynerds.com/api/get_category_index/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _menuDict = responseObject;
        [self populateMenu];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"menu dl error: %@",  operation.responseString);
        
    }];
}

-(void)downloadCategory:(CategoryButton*)sender
{
    [self hideMenu];
    [self showLoading];
    
    NSLog(@"changing to category: %@", sender.buttonCat.catTitle);
    [[self.navigationItem.titleView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    maxPages = 1;
    maxArticles = 1;
    
    articleArray = [NSMutableArray array];
    currentArticleIndex = 0;
    currentPage = 0;
    _myArticleView = nil;
    _myArticleCell = nil;
    _cellSizes = nil;

    currentID = sender.buttonCat.catID;
    [self populateMenu];
    
    NSString *slug = sender.buttonCat.catSlug;
    loadURL = [NSString stringWithFormat:@"http://mainlynerds.com/api/get_category_posts/?slug=%@&count=%d", slug, CELL_COUNT];
    
    
    UILabel *catLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.frame];
    catLabel.text = sender.buttonCat.catTitle;
    catLabel.font = [UIFont fontWithName:@"Avenir Book" size:20.0f];
    catLabel.textColor = [UIColor whiteColor];
    catLabel.textAlignment = NSTextAlignmentCenter;
    
    catLabel.frame = CGRectMake(0, 0, catLabel.frame.size.width, catLabel.frame.size.height);
    
    [self.navigationItem.titleView addSubview:catLabel];
    
    [self more];
}


#pragma mark Populating Content

-(void)populateMenu
{
    [[_menuScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[_menuDict objectForKey:@"categories"]];
    
    
    float fontSize = 15.0f;
    float subFontSize = 12.0f;
    
    float xOffset = 20;
    float yOffset = 40;
    float buttonHeight = 40.0f;
    float buttonWidth = _menuScrollView.frame.size.width - (xOffset*2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    yOffset += buttonHeight;
    [button setTitle:@" Home " forState:UIControlStateNormal];
    button.frame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:@"Avenir Book" size:fontSize];
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.numberOfLines = 1;
    
    if(!currentID)
    {
        button.backgroundColor = [UIColor darkGrayColor];
    }
    
    [_menuScrollView addSubview:button];
    
    NSMutableArray *catArray = [NSMutableArray array];
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [arr1 sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    for (NSDictionary* element in arr1)
    {
        CategoryObject *cat = [CategoryObject initWithCategory:element];
        [catArray addObject:cat];
    }
    
    NSMutableArray *fixedCatArray = [NSMutableArray array];
    for(CategoryObject *cat in catArray)
    {
        if(cat.catParentID)
        {
            for(CategoryObject *parent in catArray)
            {
                if(parent.catID == cat.catParentID)
                {
                    [parent.catChildren addObject:cat];
                    break;
                }
            }
        }
        else
        {
            [fixedCatArray addObject:cat];
        }
    }
    
    for(CategoryObject *cat in fixedCatArray)
    {
        CategoryButton *button = [CategoryButton buttonWithType:UIButtonTypeSystem];
        button.buttonCat = cat;
        [button setTitle:[NSString stringWithFormat:@" %@ ", cat.catTitle] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        button.titleLabel.font = [UIFont fontWithName:@"Avenir Book" size:fontSize];
        button.titleLabel.lineBreakMode = NSLineBreakByClipping;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.numberOfLines = 1;
        
        [button addTarget:self action:@selector(downloadCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        yOffset += buttonHeight;
        button.frame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        [_menuScrollView addSubview:button];
        
        if(currentID == cat.catID)
        {
            button.backgroundColor = [UIColor darkGrayColor];
        }
        
        for(CategoryObject *child in cat.catChildren)
        {
            CategoryButton *childButton = [CategoryButton buttonWithType:UIButtonTypeSystem];
            childButton.buttonCat = child;
            
            [childButton setTitle:[NSString stringWithFormat:@" - %@ ", child.catTitle] forState:UIControlStateNormal];
            [childButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            childButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            childButton.titleLabel.font = [UIFont fontWithName:@"Avenir Book" size:subFontSize];
            childButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
            childButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            childButton.titleLabel.numberOfLines = 1;
            
            if(currentID == child.catID)
            {
                childButton.backgroundColor = [UIColor darkGrayColor];
            }
            
            [childButton addTarget:self action:@selector(downloadCategory:) forControlEvents:UIControlEventTouchUpInside];
            
            yOffset += buttonHeight;
            childButton.frame = CGRectMake(xOffset*2, yOffset, buttonWidth-xOffset, buttonHeight);
            [_menuScrollView addSubview:childButton];
        }
    }

    
    
    // resize the scrollview to fit the new content
    // add padding on the end
    [_menuScrollView setContentSize:CGSizeMake(_menuScrollView.contentSize.width,
                                               yOffset + buttonHeight + 40.0f)];
    _menuScrollView.canCancelContentTouches = YES;
    
    NSLog(@"menu download finished - populating");
    
}

- (void)populateArticles:(id)data
{
    _articleCollectionView.userInteractionEnabled = true;
    
    NSArray *arr1 = [data objectForKey:@"posts"];
    
    maxArticles = [[data objectForKey:@"count"] intValue];
    maxPages = [[data objectForKey:@"pages"] intValue];
    
    // reset saved array
    
    
    // Process Posts
    for (NSDictionary* element in arr1)
    {
        ArticleObject *obj = [ArticleObject initWithArticle:element];
        [articleArray addObject:obj];
    }
    
    NSLog(@"article download finished - reloading");
    //[self.listTableView reloadData];
    [self.articleCollectionView reloadData];
}


#pragma mark Collection View Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"num!");
    // add one extra cell to load more posts
    return articleArray.count + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"yes!");
    static NSString *identifier = @"BasicCell";
    
    ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.delegate = self;
    if(!articleArray.count)
    {
        // no articles populated yet
        // not sure what to show here yet
        // for now, don't show anything
        cell.loadMoreButton.hidden = true;
        cell.articleAuthor.hidden = true;
        cell.articleText.hidden = true;
        cell.articleThumb.hidden = true;
        cell.shadowBG.hidden = true;
    }
    else if(indexPath.row >= articleArray.count)
    {
        if(currentPage < maxPages)
        {
            cell.loadMoreButton.hidden = false;
            cell.articleAuthor.hidden = true;
            cell.articleText.hidden = true;
            cell.articleThumb.hidden = true;
        }
        else
        {
            // reached the end of availble content
            // dont show the load more button
            // hide everything
            cell.loadMoreButton.hidden = true;
            cell.articleAuthor.hidden = true;
            cell.articleText.hidden = true;
            cell.articleThumb.hidden = true;
            cell.shadowBG.hidden = true;
        }
        
    }
    else
    {
        ArticleObject *item = articleArray[indexPath.row];
        
        // Get references to labels of cell
        //NSLog(@"adding %@", item.content);
        
        //myCell.articleHTML = [NSString stringWithString:item.content];
        cell.loadMoreButton.hidden = true;
        cell.articleAuthor.hidden = false;
        cell.articleText.hidden = false;
        cell.articleThumb.hidden = false;
        cell.shadowBG.hidden = false;
        
        cell.articleAuthor.text = item.postAuthor;
        
        cell.articleAuthor.text = [NSString stringWithFormat:@"Posted %@", item.postDate.timeAgoSinceNow];
        
        cell.articleText.text = item.postTitle;
        
        [cell.articleThumb sd_setImageWithURL:[NSURL URLWithString:item.postThumbnail]
                             placeholderImage:nil];
        
        
        cell.shadowBG.backgroundColor = [UIColor colorWithRed:RANDFLOAT(0.0f, 1.0f) green:RANDFLOAT(0.0f, 1.0f) blue:RANDFLOAT(0.0f, 1.0f) alpha:.7f];
    }
    
    //NSLog(@"%@", cell.articleAuthor.text);
    //[UIImage imageNamed:@"placeholder.png"]
    
    [_cellArray insertObject:cell atIndex:indexPath.row];
    return cell;

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat maxPosition = scrollView.contentInset.top + scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height;
    CGFloat currentPosition = scrollView.contentOffset.y + self.topLayoutGuide.length;
    
    if(currentPosition <= 0)
    {
        //NSLog(@"at the top!");
    }
    if (currentPosition == maxPosition)
    {
        //NSLog(@"at the bottom!");
        //[self more];
    }


}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_myArticleView)
    {
        NSLog(@"article preset - ignoring selection.");
        return;
    }
    NSLog(@"selected cell %ld", (long)indexPath.row);
    // Set selected feeditem to var
    _collection = collectionView;
    
    
    if(indexPath.row < articleArray.count)
    {
        
        //[self performSegueWithIdentifier:@"showArticle" sender:self];
        
        
        _myArticleCell = (ArticleCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        _myArticleCell.origRect = _myArticleCell.frame;
        
        currentArticleIndex = (int)indexPath.row;
        _feedItem = articleArray[indexPath.row];
        _feedItemImageView = _myArticleCell.articleThumb;
        
        [_collection setScrollEnabled:false];
        
        //_myArticleView = [ArticleView initWithFrame:_myArticleCell.origRect];
        
        CGRect rect= collectionView.frame;
        rect.origin = CGPointMake(rect.origin.x,
                                  rect.origin.y +
                                  collectionView.contentOffset.y //+
                                  //self.navigationController.navigationBar.frame.size.height
                                  );
        rect.size = CGSizeMake(rect.size.width,
                               rect.size.height //-
                               //self.navigationController.navigationBar.frame.size.height
                               );
        //float xOffset = 10.0f;
        //float offset = self.navigationController.navigationBar.frame.size.height + 10;
        //NSLog(@"offset: %f", collectionView.contentOffset.y);
        
        // scale the rect to not fill the whole screen
        rect = CGRectInset(rect,
                           0,
                           0);
        
        
        _myArticleView = [ArticleView initWithFrame:rect andArticle:_feedItem andImage:_feedItemImageView.image];
        
        NSString *prevTitle = nil;
        NSString *nextTitle = nil;
        if(indexPath.row > 0)
        {
            ArticleObject *obj = articleArray[indexPath.row - 1];
            prevTitle = obj.postTitle;
        }
        if(indexPath.row < articleArray.count-1)
        {
            ArticleObject *obj = articleArray[indexPath.row + 1];
            nextTitle = obj.postTitle;
        }
        
        [_myArticleView loadNavigation:prevTitle nextTitle:nextTitle];
        
        _myArticleView.delegate = self;
        [_myArticleCell.superview bringSubviewToFront:_myArticleCell];
        
        //[cell.superview addSubview:myView];
        
        //_grayView.hidden = false;
        
        //_closeButton.enabled = YES;
        //_menuButton.enabled = NO;
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        
        
        [UIView animateWithDuration:0.5f
                delay:0
                options:UIViewAnimationOptionAllowAnimatedContent//(UIViewAnimationOptionAllowUserInteraction)
                 animations:^
                 {
                     
                     
                     _myArticleCell.frame = rect;
                     _myArticleView.frame = CGRectMake(0,
                                                       0,
                                                       rect.size.width,
                                                       rect.size.height);
                     
                     [UIView transitionFromView:_myArticleCell.contentView
                                         toView:_myArticleView
                                       duration:0.5f
                                        options:UIViewAnimationOptionTransitionFlipFromRight
                                     completion:^(BOOL finished) {
                                         [self.navigationItem setLeftBarButtonItem:_closeButton animated:YES];
                                         [self.navigationItem setRightBarButtonItem:_shareButton animated:YES];
                                         //NSLog(@"animation end");
                                     }];
                 }
                 completion:^(BOOL finished)
                 {
                     
                 }
         ];
    }

    
    // Manually call segue to detail view controller
    //[self performSegueWithIdentifier:@"showArticle" sender:self];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*
    if(_myArticleView)
    {
        ArticleCollectionViewCell *cell = (ArticleCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        if(cell == _myArticleCell)
        {
            NSLog(@"match!");
            return _myArticleView.frame.size;
        }
    }
    */
    
    return [self.cellSizes[indexPath.item] CGSizeValue];
}



- (void)addCellSizes:(int)count {
    
    if (!_cellSizes) {
        _cellSizes = [NSMutableArray array];
    }
    for (NSInteger i = 0; i < count; i++) {
        CGSize size = CGSizeMake(RANDFLOAT(CELL_HEIGHT_MIN, CELL_HEIGHT_MAX),
                                 RANDFLOAT(CELL_HEIGHT_MIN, CELL_HEIGHT_MAX));
        [_cellSizes addObject: [NSValue valueWithCGSize:size]];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    return COLUMN_COUNT;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showArticle"])
    {
        //ArticleViewController *detailVC = segue.destinationViewController;
        //detailVC.article = _feedItem;
        //detailVC.headerImage = _feedItemImageView.image;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
