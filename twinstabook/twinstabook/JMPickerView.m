
#import "JMPickerView.h"

@interface JMPickerView ()
@property (nonatomic) UIView *pickerDismisserView;
@property (nonatomic, weak) UIViewController *topController;
@end

@implementation JMPickerView

static CGFloat kPickerViewStandardHeight = 216.f;
//static CGFloat kMenuHeight = 20.0f;
static CGFloat kDismissViewAlpha = 0.8f;
static CGFloat kAnimationDuration = 0.3f;
static CGFloat kTwoFifths = 0.4f;
static CGFloat kThreeFifths = 0.6;

// This is just a convenient init method.
// All we need are a delegate and to be added to a viewController's view.
- (JMPickerView *)initWithDelegate:(id<JMPickerViewDelegate>)delegate addingToViewController:(UIViewController *)viewController withDistanceToTop:(CGFloat)distance
{
    if (self = [super init])
    {
        self.distance = distance;
        self.showsSelectionIndicator = YES;
        self.delegate = delegate;
        self.topController = viewController.navigationController ?: viewController;
        [viewController.view addSubview:self];
        [self setBackgroundColor:[UIColor whiteColor]];
        //[self setAlpha:0.5];
    }
    return self;
}

// This method gets called after we have been added to a view.
// We're pretty much useless until we've been added to a view.
- (void)didMoveToSuperview
{

    self.frame = CGRectMake(self.superview.bounds.origin.x, kPickerViewStandardHeight, self.superview.bounds.size.width, kPickerViewStandardHeight);
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionIndicatorTap:)]];

    self.pickerDismisserView = UIView.new;
    self.pickerDismisserView.frame = self.topController.view.bounds;
    self.pickerDismisserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerDismisserView.backgroundColor = UIColor.blackColor;
    self.pickerDismisserView.alpha = 0.0;
    [self.pickerDismisserView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)]];
    [self.topController.view addSubview:self.pickerDismisserView];
}

- (void)selectionIndicatorTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer locationInView:self].y > (self.bounds.size.height * kTwoFifths) &&
        [gestureRecognizer locationInView:self].y < (self.bounds.size.height * kThreeFifths))
    {
        if ([self.delegate respondsToSelector:@selector(pickerViewSelectionIndicatorWasTapped:)])
        {
            [self.delegate pickerViewSelectionIndicatorWasTapped:self];
        }
    }
}

- (void)show:(float)time
{
    [UIView animateWithDuration:time animations:^{

        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.origin.y+self.distance, self.superview.bounds.size.width, kPickerViewStandardHeight);
        
        self.pickerDismisserView.frame = CGRectMake(self.topController.view.bounds.origin.x, self.topController.view.bounds.origin.y+kPickerViewStandardHeight+self.distance, self.topController.view.bounds.size.width, self.topController.view.bounds.size.height - kPickerViewStandardHeight);
        
        self.pickerDismisserView.alpha = kDismissViewAlpha;
        [self.pickerDismisserView setBackgroundColor:[UIColor lightGrayColor]];

    }];
    if ([self.delegate respondsToSelector:@selector(pickerViewWasShown:)])
    {
        [self.delegate pickerViewWasShown:self];
    }
}

- (void)hide:(float)time
{
    float dt = time;

    if (dt < 0)
    {
        dt = 0.0;
    }
    else
    {
        dt = fmaxf(dt, kAnimationDuration);
    }
    
    [UIView animateWithDuration:dt animations:^{
        // move the frame up above the top
        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.origin.y-kPickerViewStandardHeight, self.superview.bounds.size.width, kPickerViewStandardHeight);
        self.pickerDismisserView.frame = self.topController.view.bounds;
        self.pickerDismisserView.alpha = 0.0f;
        
    }];
    if ([self.delegate respondsToSelector:@selector(pickerViewWasHidden:)])
    {
        [self.delegate pickerViewWasHidden:self];
    }
}

// If we weren't initialized with a View Controller/Navigation Controller,
// we should try to find an approrpiate one. This might be ripe for improvements.
- (UIViewController *)topController
{
    if (!_topController)
    {
        if ([self.superview.nextResponder isKindOfClass:[UIViewController class]])
        {
            _topController = (UIViewController *)self.superview.nextResponder;
        }
        if (_topController.navigationController != nil)
        {
            _topController = _topController.navigationController;
        }
    }
    return _topController;
}

@end
