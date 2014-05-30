/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "KalDate.h"

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

CGFloat kHeaderHeight = 78.3f;
CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
  if ((self = [super initWithFrame:frame])) {
    delegate = theDelegate;
    logic = [theLogic retain];
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
      float headerheight = kHeaderHeight;
      if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
          headerheight *= kPad;
      
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, headerheight)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
    
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, headerheight, frame.size.width, frame.size.height - headerheight)] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
      
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)showCurrentMonth
{
    [delegate showCurrentMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
    CGFloat kChangeMonthButtonWidth = 15.8f;
    CGFloat kChangeMonthButtonHeight = 15.8f;
    CGFloat kMonthLabelWidth = 200.0f;
    CGFloat kHeaderVerticalAdjust = 12.0f;
  
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        kHeaderHeight *= kPad;
        kMonthLabelHeight *= kPad;
        
        kChangeMonthButtonWidth *= kPad;
        kChangeMonthButtonHeight *= kPad;
        kMonthLabelWidth *= kPad;
        kHeaderVerticalAdjust *= kPad;
    }
  // Header background gradient
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monthheader.png"]];
  CGRect imageFrame = headerView.frame;
    imageFrame.size.height = 48.3f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        imageFrame.size.height *= kPad;
    }
    ///////////////////////////////////////////////
  imageFrame.origin = CGPointZero;
  backgroundView.frame = imageFrame;
  [headerView addSubview:backgroundView];
  [backgroundView release];
  
    UIImageView *monthLabelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dayline.png"]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        imageFrame.origin.y = imageFrame.size.height - 8 * kPad;
        imageFrame.size.height = 38 * kPad;
    }
    else
    {
        imageFrame.origin.y = imageFrame.size.height - 8;
        imageFrame.size.height = 38;
    }
    monthLabelImageView.frame = imageFrame;
    [headerView addSubview:monthLabelImageView];
    [monthLabelImageView release];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // Create the previous month button on the left side of the view
        CGRect previousMonthButtonFrame = CGRectMake(10 * kPad,
                                                     kHeaderVerticalAdjust,
                                                     kChangeMonthButtonWidth,
                                                     kChangeMonthButtonHeight);
        UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
        [previousMonthButton setAccessibilityLabel:NSLocalizedString(@"Previous month", nil)];
        [previousMonthButton setBackgroundImage:[UIImage imageNamed:@"arrowleft.png"] forState:UIControlStateNormal];
        previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:previousMonthButton];
        [previousMonthButton release];
        
        // Draw the selected month name centered and at the top of the view
        CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
                                            3 * kPad,
                                            kMonthLabelWidth,
                                            kMonthLabelHeight);
        headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
        headerTitleLabel.backgroundColor = [UIColor clearColor];
        headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f * kPad];
        headerTitleLabel.textAlignment = UITextAlignmentCenter;
        headerTitleLabel.textColor = [UIColor whiteColor];
        [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
        [headerView addSubview:headerTitleLabel];
        
        // Create the next month button on the right side of the view
        CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth - 10 * kPad,
                                                 kHeaderVerticalAdjust,
                                                 kChangeMonthButtonWidth,
                                                 kChangeMonthButtonHeight);
        UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
        [nextMonthButton setAccessibilityLabel:NSLocalizedString(@"Next month", nil)];
        [nextMonthButton setBackgroundImage:[UIImage imageNamed:@"arrowright.png"] forState:UIControlStateNormal];
        nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:nextMonthButton];
        [nextMonthButton release];
        
        // Create the current month button on the left side of the view
        CGRect leftCurrentMonthButtonFrame = CGRectZero;
        currentMonthButton = [[UIButton alloc] initWithFrame:leftCurrentMonthButtonFrame]; 
        [currentMonthButton setBackgroundImage:[UIImage imageNamed:@"settocurrent.png"] forState:UIControlStateNormal];
        
        [currentMonthButton addTarget:self action:@selector(showCurrentMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:currentMonthButton];
        [currentMonthButton release];
        
        // Add column labels for each weekday (adjusting based on the current locale's first weekday)
        NSArray *weekdayNames = [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
        NSArray *fullWeekdayNames = [[[[NSDateFormatter alloc] init] autorelease] standaloneWeekdaySymbols];
        NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
        NSUInteger i = firstWeekday - 1;
        for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f * kPad, i = (i+1)%7) {
            CGRect weekdayFrame = CGRectMake(xOffset, 30.f * kPad, 46.f * kPad, kHeaderHeight - 29.f * kPad);
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor clearColor];
            weekdayLabel.font = [UIFont boldSystemFontOfSize:15.0f * kPad];
            weekdayLabel.textAlignment = UITextAlignmentCenter;
            weekdayLabel.textColor = [UIColor whiteColor];
            weekdayLabel.text = [weekdayNames objectAtIndex:i];
            [weekdayLabel setAccessibilityLabel:[fullWeekdayNames objectAtIndex:i]];
            [headerView addSubview:weekdayLabel];
            [weekdayLabel release];
        }
    }
    else
    {
        // Create the previous month button on the left side of the view
        CGRect previousMonthButtonFrame = CGRectMake(10,
                                                     kHeaderVerticalAdjust,
                                                     kChangeMonthButtonWidth,
                                                     kChangeMonthButtonHeight);
        UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
        [previousMonthButton setAccessibilityLabel:NSLocalizedString(@"Previous month", nil)];
        [previousMonthButton setBackgroundImage:[UIImage imageNamed:@"arrowleft.png"] forState:UIControlStateNormal];
        previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:previousMonthButton];
        [previousMonthButton release];
        
        // Draw the selected month name centered and at the top of the view
        CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
                                            3,
                                            kMonthLabelWidth,
                                            kMonthLabelHeight);
        headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
        headerTitleLabel.backgroundColor = [UIColor clearColor];
        headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
        headerTitleLabel.textAlignment = UITextAlignmentCenter;
        headerTitleLabel.textColor = [UIColor whiteColor];
        [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
        [headerView addSubview:headerTitleLabel];
        
        // Create the next month button on the right side of the view
        CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth - 10,
                                                 kHeaderVerticalAdjust,
                                                 kChangeMonthButtonWidth,
                                                 kChangeMonthButtonHeight);
        UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
        [nextMonthButton setAccessibilityLabel:NSLocalizedString(@"Next month", nil)];
        [nextMonthButton setBackgroundImage:[UIImage imageNamed:@"arrowright.png"] forState:UIControlStateNormal];
        nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:nextMonthButton];
        [nextMonthButton release];
        
        // Create the current month button on the left side of the view
        CGRect leftCurrentMonthButtonFrame = CGRectZero;
        currentMonthButton = [[UIButton alloc] initWithFrame:leftCurrentMonthButtonFrame]; 
        [currentMonthButton setBackgroundImage:[UIImage imageNamed:@"settocurrent.png"] forState:UIControlStateNormal];
        
        [currentMonthButton addTarget:self action:@selector(showCurrentMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:currentMonthButton];
        [currentMonthButton release];
        
        // Add column labels for each weekday (adjusting based on the current locale's first weekday)
        NSArray *weekdayNames = [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
        NSArray *fullWeekdayNames = [[[[NSDateFormatter alloc] init] autorelease] standaloneWeekdaySymbols];
        NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
        NSUInteger i = firstWeekday - 1;
        for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i+1)%7) {
            CGRect weekdayFrame = CGRectMake(xOffset, 30.f, 46.f, kHeaderHeight - 29.f);
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor clearColor];
            weekdayLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            weekdayLabel.textAlignment = UITextAlignmentCenter;
            weekdayLabel.textColor = [UIColor whiteColor];
            weekdayLabel.text = [weekdayNames objectAtIndex:i];
            [weekdayLabel setAccessibilityLabel:[fullWeekdayNames objectAtIndex:i]];
            [headerView addSubview:weekdayLabel];
            [weekdayLabel release];
        }
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
  gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
  [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:gridView];
  
  // Trigger the initial KVO update to finish the contentView layout
  [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth {
    
    NSDate *oldDate = (NSDate*)[[self selectedDate] NSDate];
    
    [gridView jumpToSelectedMonth]; 
    
    
    CGFloat kChangeMonthButtonWidth = 15.8f;
    CGFloat kHeaderVerticalAdjust = 16.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        kChangeMonthButtonWidth *= kPad;
        kHeaderVerticalAdjust *= kPad;
    }
    
    NSDate *selDate = (NSDate*)[[gridView selectedDate] NSDate];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *selComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:selDate];
    
    if ([components month] == [selComponents month] && [components year] == [selComponents year])
    {
        currentMonthButton.hidden = YES;
    }
    else
    {
        float k = 1;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            k = kPad;
        }
        
        if ([selDate timeIntervalSinceNow] < 0)
        {
            CGRect leftCurrentMonthButtonFrame = CGRectMake(10 * k + kChangeMonthButtonWidth + 10 * k,
                                                            kHeaderVerticalAdjust - 4 * k,
                                                            14 * k,
                                                            14 * k);
            [currentMonthButton setFrame:leftCurrentMonthButtonFrame];
            
        }else if ([selDate timeIntervalSinceNow] > 0)
        {
            CGRect rightCurrentMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth - 34 * k,
                                                             kHeaderVerticalAdjust - 4 * k,
                                                             14 * k,
                                                             14 * k);
            [currentMonthButton setFrame:rightCurrentMonthButtonFrame];
         
        }
        currentMonthButton.hidden = NO;
    }
    
    if ([oldDate timeIntervalSinceDate:selDate] < 0)
    {   
        KalDate *date = [[KalDate alloc] initForDay:1 month:[selComponents month] year:[selComponents year]];
        [self selectDate:date];
        [date release];
        
    }
    else
    {
        int lastDay = [selDate cc_numberOfDaysInMonth];
        KalDate *date = [[KalDate alloc] initForDay:lastDay month:[selComponents month] year:[selComponents year]];
        
        [self selectDate:date];
        [date release];
    }
    
    [delegate didMonthChanged];
}

- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  [logic release];
  
  [headerTitleLabel release];
  [gridView removeObserver:self forKeyPath:@"frame"];
  [gridView release];
  [super dealloc];
}

@end
