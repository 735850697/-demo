#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BaseViewModel : NSObject

@property (nonatomic) RACSubject *errors;

/**
 *  取消请求Command
 */
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;

@end
