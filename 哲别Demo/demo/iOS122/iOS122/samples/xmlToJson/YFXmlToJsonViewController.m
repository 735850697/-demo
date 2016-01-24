//
//  YFXmlToJsonViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/27.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import "YFXmlToJsonViewController.h"
#import <Ono.h>

@interface YFXmlToJsonViewController ()<NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation YFXmlToJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /* 要实现的逻辑很简单: 
     1.读取XML文件;
     2.解析为JSON,并显示;
     3.将JSON输出为json文件.*/
    
    /* 1.读取并解析XML. */
    NSMutableArray * jsonArray = [NSMutableArray arrayWithCapacity: 42];
    
    NSString *XMLFilePath = [[NSBundle mainBundle] pathForResource:@"Post" ofType:@"xml"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[NSData dataWithContentsOfFile:XMLFilePath] error: NULL];
    
    NSString *XPath = @"//channel/item";
    
    [document enumerateElementsWithXPath:XPath usingBlock:^(ONOXMLElement *element, __unused NSUInteger idx, __unused BOOL *stop) {
        ONOXMLElement * titleElement = [element firstChildWithTag:@"title"];
        ONOXMLElement * descElement = [element firstChildWithTag: @"encoded" inNamespace: @"excerpt"];
        ONOXMLElement * contentElement = [element firstChildWithTag: @"encoded" inNamespace:@"content"];
        
        NSDictionary * jsonDict = @{
                                    @"title": [titleElement stringValue],
                                    @"desc": [descElement stringValue],
                                    @"body": [contentElement stringValue]};
        
        [jsonArray addObject: jsonDict];
    }];
    
    /* 2.显示JSON字符串. */
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:NULL];

    NSString * jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    self.textView.text = jsonString;
    
    /*3.存储到文件中.
     真机下,暂无法找到Documents目录下的东西,可以通过模拟器运行此段代码,并通过finder-->前往文件夹,输入此处jsonPath对应的文件路径来获取 Post.json 文件.
     */
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=[paths objectAtIndex:0];
    NSString * jsonPath=[path stringByAppendingPathComponent:@"Post.json"];

    [jsonData writeToFile: jsonPath atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
