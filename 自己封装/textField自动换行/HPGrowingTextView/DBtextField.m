//
//  DBtextField.m
//  GrowingTextViewExample
//
//  Created by dbjyz on 15/8/21.
//
//

#import "DBtextField.h"
#import "UIView+SetLayer.h"
#define DBColor(r, g, b) DBRGBA(r,g,b,1.0f)
#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@implementation DBtextField


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self MyloadView];
        
        //点击输入框
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil];
    }
    
    return self;
}


- (void)MyloadView {
    
    //生成初始化输入框
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, deviceWidth, 50)];
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth-70, 50)];
    _textView.isScrollable = NO;
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _textView.minNumberOfLines = 1;
    _textView.maxNumberOfLines = 6;
    
    _textView.returnKeyType = UIReturnKeyGo; //just as an example
    _textView.font = [UIFont systemFontOfSize:15.0f];
    _textView.delegate = self;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
     _textView.backgroundColor = DBColor(226, 226, 226);
     _containerView.backgroundColor = DBColor(226, 226, 226);
    [self addSubview:_containerView];
    [_containerView addSubview:_textView];
   
    
    
    //生成初始化提交按钮
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setBorderWidth:1 color:DBTextThemeColor];
    [_doneBtn setTitleColor:DBTextThemeColor forState:UIControlStateNormal];
    [_doneBtn setBackgroundColor:[UIColor whiteColor]];
    [_doneBtn setCornerRadius:5];
    [_doneBtn setTitleColor:DBColor(204, 204, 204) forState:UIControlStateDisabled];
    _doneBtn.frame = CGRectMake(_containerView.frame.size.width - 69, 6, 63, 27);
    _doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    _doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    _doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [_doneBtn addTarget:self action:@selector(resignTextViewjia) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_doneBtn];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}



//按钮事件
-(void)resignTextViewjia
{
    [_textView resignFirstResponder];
    [self.delegate ClickBtn:self];
}

//给按钮赋值
-(void)setTitleStr:(NSString *)TitleStr{
    
    [_doneBtn setTitle:TitleStr forState:UIControlStateNormal];
}

//提示文字
-(void)setPlaceholder:(NSString *)placeholder{
    
    _textView.placeholder = placeholder;
}

//显示键盘(当点击输入框时触发)
-(void) keyboardWillShow:(NSNotification *)note{
    
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [self.delegate ChangeFrame:self :keyboardSize];
}

//隐藏键盘
-(void) keyboardWillHide:(NSNotification *)note{
   [self.delegate ChangeFrame2:self];
}


#pragma Mark-Delegate(随着文字的增多自动换行)
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = _containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    _containerView.frame = r;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}



@end
