

#if NS_BLOCKS_AVAILABLE

#import "FTUtils+UIGestureRecognizer.h"
#import <objc/runtime.h>

@interface UIGestureRecognizer()

- (void)handleAction:(UIGestureRecognizer *)recognizer;

@end

static char * kFTGestureActionKey = "ft_gestureAction";

@implementation UIGestureRecognizer(FTBlockAdditions)

+ (id)recognizer {
  return [self recognizerWithActionBlock:nil];
}

+ (id)recognizerWithActionBlock:(FTGestureActionBlock)action {
  id me = [[self class] alloc];
  me = [me initWithTarget:me action:@selector(handleAction:)];
  [me setActionBlock:action];
  return [me autorelease];
}

- (void)handleAction:(UIGestureRecognizer *)recognizer {
  if(self.actionBlock) {
    self.actionBlock(recognizer);
  }
}

- (FTGestureActionBlock)actionBlock {
  return objc_getAssociatedObject(self, kFTGestureActionKey);
}

- (void)setActionBlock:(FTGestureActionBlock)actionBlock {
  objc_setAssociatedObject(self, kFTGestureActionKey, actionBlock, OBJC_ASSOCIATION_COPY);
}

@end

#endif