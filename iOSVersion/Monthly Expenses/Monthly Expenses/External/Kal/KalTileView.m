/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "DBManager.h"

extern const CGSize kTileSize;

@implementation KalTileView

@synthesize date, isSunday;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        fontSize = 40;
    
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
  UIColor *shadowColor = nil;
  UIColor *textColor = nil;
  UIImage *markerImage = nil;
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
  CGContextTranslateCTM(ctx, 0, kTileSize.height);
  CGContextScaleCTM(ctx, 1, -1);
    
    markerImage = [UIImage imageNamed:@"notificationDark.png"];
  if (self.selected) {
    [[UIImage imageNamed:@"selectedDate.png"] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
    textColor = [UIColor whiteColor];
  } else if ([self isToday]) {
      [[UIImage imageNamed:@"Date.png"] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
      textColor = [UIColor whiteColor];
  } else if (self.belongsToAdjacentMonth) {
    textColor = nil;
    shadowColor = nil;
  } else if (isSunday) {
      [[UIImage imageNamed:@"sunDate.png"] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
      textColor = [UIColor whiteColor];
  } else {
      [[UIImage imageNamed:@"normalDate.png"] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
      textColor = [UIColor grayColor];
  }
  
    if (!self.belongsToAdjacentMonth)
    {
        if (flags.marked)
            [markerImage drawInRect:CGRectMake(21.f, 5.f, 4.f, 5.f)];
        
        NSUInteger n = [self.date day];
        NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
        const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
        CGSize textSize = [dayText sizeWithFont:font];
        CGFloat textX, textY;
        textX = roundf(0.5f * (kTileSize.width - textSize.width));
        textY = 6.f + roundf(0.5f * (kTileSize.height - textSize.height));
        if (shadowColor) {
            [shadowColor setFill];
            CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
            textY += 1.f;
        }
        [textColor setFill];
        CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
        
        if (self.highlighted) {
            [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
            CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
        }
        
        NSDate *mydate = [[self date] NSDate];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDay = [dateformatter stringFromDate:mydate];
        [dateformatter release];
        
        int expensecount = [[DBManager sharedManager] expenseCountWithDate:strDay];
        
        if (expensecount != 0)
        {
            float k = 1;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                k = kPad;
            }
            UIImage *image = [UIImage imageNamed:@"notificationDark.png"];
            CGSize size = [image size];
            size.width = size.width * 0.8 * k;
            size.height = size.height * 0.8 * k;
            
            CGRect rtDraw = CGRectMake(kTileSize.width - size.width, kTileSize.height - size.height, size.width, size.height);
            
            CGContextDrawImage(ctx, rtDraw, [image CGImage]);
            
            UIFont *font = [UIFont boldSystemFontOfSize:11 * k];
            CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], 11 * k, kCGEncodingMacRoman);
            
            NSString *str = [NSString stringWithFormat:@"%d", expensecount];            [[UIColor colorWithRed:0 green:0.8f blue:0.8f alpha:1.0f] setFill];
            const char *day = [str cStringUsingEncoding:NSUTF8StringEncoding];
            CGContextShowTextAtPoint(ctx, kTileSize.width - size.width + size.width / 2 - 3 * k, kTileSize.height - size.height + 5 * k, day, expensecount >= 10 ? 2 : 1);
        }
    }   
}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}

@end
