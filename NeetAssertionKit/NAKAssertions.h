//
//  NAKAssertions.h
//  NeetAssertionKit
//
//  Created by mtmta on 2013/12/10.
//  Copyright (c) 2013 covelline, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


/************************************************************************************************
 
 マクロごとに ifdef-else-endif で囲うこと
 
 #ifdef DEBUG
 // デバッグビルド
 #else
 // リリースビルド
 #endif

 ************************************************************************************************/


/**
 
 条件式が true であることを表明する.
 
 リリースビルドでは取り除かれ, 指定した条件式も実行されない.

 ```objc
 
 // 条件式が false の時にエラーを出す.
 - (void)getObjectAtIndex:(NSUInteger)index inArray:(NSArray *)array {
 
    // index が NSNotFound の時エラー
    NSAssertTrue(index != NSNotFound, @"index は NSNotFound 以外 (index=%u)", index);
 
    ...
 }
 
 // C の関数内で使う時は NAKWrap で囲む.
 // 他のマクロを使う場合も同様に NAKWrap で囲む.
 id getObjectInArray(NSUInteger index, NSArray *array) {
 
    // index が NSNotFound の時エラー
    NSAssertTrue(index != NSNotFound, @"index は NSNotFound 以外 (index=%u)", index);
 
    ...
 }
 
 ```
 
 @param condition アサーション対象の条件式.
    この式の結果が true でない場合, アサーションエラーが発生する.
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertTrue(condition, fmt, ...) NSAssert((condition), (fmt), ##__VA_ARGS__)

#else

#define NAKAssertTrue(...)

#endif



/**
 
 無条件でアサーションエラーを発生させる.
 
 リリースビルドでは取り除かれる.

 ```objc
 
 switch (type) {
    case ValidType:
        ...
        break;
 
    default:
        NAKFail(@"ここを通るのはおかしい！");
 }
 
 ```
  
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.

 */
#ifdef DEBUG

#define NAKFail(fmt, ...) NSAssert((NO), (fmt), ##__VA_ARGS__)

#else

#define NAKFail(...)

#endif


/**
 
 アサーションマクロ (NAKAssertTrue など) をラップするマクロ.
 
 C の関数内では NAKAssertTrue などはそのまま使用できないので, このマクロでラップして使う.
 
 リリースビルドでは expression そのものに置き換えられる.
 
 ```objc
 
 // NAKWrap で囲うと C の関数でも使用できる
 void setHomuhomu(NSString *homuhomu) {
 
    NAKWrap(NAKAssertTrue(0 < homuhomu.length, @"ほむほむは空じゃだめ");

    ...
 }
 
 ```
 
 */
#ifdef DEBUG

#define NAKWrap(expression) do { \
        id self = nil; \
        SEL _cmd = (SEL)__func__; \
        expression; \
    } while (0)

#else

#define NAKWrap(expression) expression

#endif


/**
 
 expression が nil でないことを表明する.
 
 リリースビルドでは取り除かれ, 指定した式も実行されない.
 
 ```objc
 
 - (void)setHomuhomu:(NSString *)homuhomu {
 
    // homuhomu が nil の時エラー
    NAKAssertNotNil(homuhomu, @"ほむほむは nil 以外");
 
    ...
 }
 
 ```
 
 @param expression nil でないことを表明する式.
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertNotNil(expression, fmt, ...) \
    NAKAssertTrue((expression) != nil, (fmt), ##__VA_ARGS__)

#else

#define NAKAssertNotNil(...)

#endif


/**
 
 オブジェクトが指定したクラス, またはそのサブクラスのインスタンスであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 ```objc
 
 id obj = ...;
 
 // obj が NSArray か, そのサブクラスのインスタンスであることを表明
 NAKAssertKindOfClass(obj, NSArray, @"obj は NSArray かサブクラス");
 
 ```
 
 @param obj アサーションの対象オブジェクト.
 
 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.
 
 */
#ifdef DEBUG

#define NAKAssertKindOfClass(obj, clazz, fmt, ...) \
    NAKAssertTrue([obj isKindOfClass:[clazz class]], (fmt), ##__VA_ARGS__)

#else

#define NAKAssertKindOfClass(...)

#endif


/**
 
 オブジェクトが指定したクラスのインスタンスであることを表明する.
 
 サブクラスのインスタンスであってもエラーになる.
 
 リリースビルドでは取り除かれる.
 
 ```objc
 
 NSOperation *ope = ...;
 
 // ope が NSOperation 以外の時エラー (サブクラスでもエラー)
 NAKAssertMemberOfClass(ope, NSOperation, @"ope は NSOperation そのもの (サブクラスもだめ)");
 
 ```
 
 ```objc
 NSOperation *ope = [NSBlockOperation blockOperationWithBlock:^{ ... }];
 
 // NSOperation のサブクラスだからエラーが起きる
 NAKAssertMemberOfClass(ope, NSOperation, @"ope は NSOperation そのもの (サブクラスもだめ)");
 ```
  
 @param obj アサーションの対象オブジェクト.
 
 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.

 */
#ifdef DEBUG

#define NAKAssertMemberOfClass(obj, clazz, fmt, ...) \
    NAKAssertTrue([obj isMemberOfClass:[clazz class]], (fmt), ##__VA_ARGS__)

#else

#define NAKAssertMemberOfClass(...)

#endif


/**
 
 expression の結果を clazz にキャストした値を取得する.
 
 expression が nil 以外で, clazz のサブクラスでない場合, エラーが発生する.
 expression が nil の場合はエラーにならない.
 
 リリースビルドでは expression の結果を単純にキャストして返す.
 
 ```objc
 
 - (void)receivedNotify:(NSNotification *)note {
 
    // note.userInfo[@"stringValueKey"] が NSString (またはそのサブクラス) でない時エラー
    // NSString　または nil の場合は string に代入される.
    NSString *string = NAKAssertCast(note.userInfo[@"stringValueKey"], NSString);
 
    ...
 }
 ```
 
 @param expression キャストする式.

 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.
 
 ```
 
 */
#ifdef DEBUG

#define NAKAssertCast(expression, clazz) \
    _NAKAssertCast((expression), [clazz class], self, _cmd, __FILE__, __LINE__, __PRETTY_FUNCTION__)

#else

#define NAKAssertCast(expression, clazz) ((clazz *)(expression))

#endif


/**
 
 NSArray 内のすべての要素が指定したクラスのサブクラスのインスタンスであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 ```objc
 
 - (void)setStringArray:(NSArray *)array {
 
    // array に NSString (またはそのサブクラス) 以外のオブジェクトが入っているとエラー
    NAKAssertArrayType(array, NSString, @"文字列の配列を指定する");

    ...
 }
 ```
 
 @param array NSArray. アサーション対象の配列.
 
 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertArrayType(array, clazz, fmt, ...) \
    do { \
        for (id element in (array)) { \
            NAKAssertTrue([element isKindOfClass:[clazz class]], (fmt), ##__VA_ARGS__); \
        } \
    } while (0)

#else

#define NAKAssertArrayType(...)

#endif


/**
 
 実行されているスレッドがメインスレッドであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 ```objc
 
 - (void)beginHomuhomuAnimation {
 
    // メインスレッド以外から呼ばれるとエラー
    NAKAssertMainThread(@"UI をいじるのでメインスレッドから呼ぶこと！");
 
    ...
 }
 
 ```
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertMainThread(fmt, ...) \
    NAKAssertTrue([NSThread isMainThread], (fmt), ##__VA_ARGS__)

#else

#define NAKAssertMainThread(...)

#endif


/**
 
 実行されているディスパッチキューが指定したキューであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 ```objc
 
 dispatch_queue_t _queue;
 
 - (void)nonThreadSafeMethod {
 
    // 現在のキューが _queue 以外だとエラー
    NAKAssertDispatchQueue(_queue, @"変なキューで実行されてる！");
 
    ...
 }
 
 ```
 
 @param queue dispatch_queue_t. 期待するディスパッチキューオブジェクト.
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertDispatchQueue(queue, fmt, ...) \
    NAKAssertTrue(_NAK_dispatch_get_current_queue() == (queue), (fmt), ##__VA_ARGS__)

#else

#define NAKAssertDispatchQueue(...)

#endif


#pragma mark - Private Functions

// 内部用関数.
// 外部からは使わないこと.
#ifdef DEBUG

id _NAKAssertCast(id obj, Class expectedClass, id self, SEL _cmd, const char *file, int line, const char *function);

dispatch_queue_t _NAK_dispatch_get_current_queue();

#endif
