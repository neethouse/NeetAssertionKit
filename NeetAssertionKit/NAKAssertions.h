//
//  NAKAssertions.h
//  NeetAssertionKit
//
//  Created by mtmta on 2013/12/10.
//  Copyright (c) 2013 neethouse.org. All rights reserved.
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
 - (void)doHogeHoge:(id)homuhomu {
    NAKAssert(homuhomu != nil, @"homuhomu must not nil (%@)", hoge);
 }
 
 // C の関数内で使う時は NAKWrap で囲む.
 void doHogeHoge(id homuhomu) {
    NAKWrap(NAKAssert(homuhomu != nil, @"homuhomu must not nil (%@)", hoge));
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
 
 NAKFail(@"Force fail.");

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
 void doHomuHomu(id homuhomu) {
 
    NAKWrap(NAKAssert(homuhomu != nil, @"ほむほむは nil 以外"));

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
 
 // obj が NSArray か, そのサブクラスのインスタンスであることを表明
 id obj = ...;
 
 NAKAssertKindOfClass(obj, NSArray, @"obj must be NSArray");
 
 ```
 
 @param obj アサーションの対象オブジェクト.
 
 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.
 
 */
#ifdef DEBUG

#define NAKAssertKindOfClass(obj, clazz, fmt, ...) \
    NAKAssert([obj isKindOfClass:[clazz class]], (fmt), ##__VA_ARGS__)

#else

#define NAKAssertKindOfClass(...)

#endif


/**
 
 オブジェクトが指定したクラスのインスタンスであることを表明する.
 
 サブクラスのインスタンスであってもエラーになる.
 
 リリースビルドでは取り除かれる.
  
 @param obj アサーションの対象オブジェクト.
 
 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.

 */
#ifdef DEBUG

#define NAKAssertMemberOfClass(obj, clazz, fmt, ...) \
    NAKAssert([obj isMemberOfClass:[clazz class]], (fmt), ##__VA_ARGS__)

#else

#define NAKAssertMemberOfClass(...)

#endif


/**
 
 expression の結果を clazz にキャストした値を取得する.
 
 expression が nil 以外で, clazz のサブクラスでない場合, エラーが発生する.
 expression が nil の場合はエラーにならない.
 
 リリースビルドでは expression の結果をそのまま返す.
 
 ```objc
 
 // obj が NSArray か, そのサブクラスでない時はエラー
 // nil の場合はエラーにならない
 id obj = ...;

 NSArray *array = NAKAssertCast(obj, NSArray);
   
 @param expression キャストする式.

 @param clazz 期待するクラスの名前.
    [ClassName class] のような形式ではなく, クラス名 (この例では ClassName) を直接記述する.
 
 ```
 
 */
#ifdef DEBUG

#define NAKAssertCast(expression, clazz) \
    _NAKAssertCast((expression), [clazz class], self, _cmd, __FILE__, __LINE__, __PRETTY_FUNCTION__)

#else

#define NAKAssertCast(expression, ...) (expression)

#endif


/**
 
 NSArray 内のすべての要素が指定したクラスのサブクラスのインスタンスであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 ```objc
 
 // array の各要素はすべて NSString
 NSArray *array = ...;

 NAKAssertArrayType(array, NSString, @"array of NSString");

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
            NAKAssert([element isKindOfClass:[clazz class]], (fmt), ##__VA_ARGS__); \
        } \
    } while (0)

#else

#define NAKAssertArrayType(...)

#endif


/**
 
 実行されているスレッドがメインスレッドであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertMainThread(fmt, ...) \
    NAKAssert([NSThread isMainThread], (fmt), ##__VA_ARGS__)

#else

#define NAKAssertMainThread

#endif


/**
 
 実行されているディスパッチキューが指定したキューであることを表明する.
 
 リリースビルドでは取り除かれる.
 
 @param queue dispatch_queue_t. 期待するディスパッチキューオブジェクト.
 
 @param fmt NSString. エラー発生時に表示するメッセージ.
    NSLog などと同じ形式でフォーマットを指定でき, この後の引数で埋め込む変数を指定する.
 
 */
#ifdef DEBUG

#define NAKAssertDispatchQueue(queue, fmt, ...) \
    NAKAssert(_NAK_dispatch_get_current_queue() == (queue), (fmt), #__VA_ARGS__)

#else

#define NAKAssertDispatchQueue

#endif


#pragma mark - Private Functions

// 内部用関数.
// 外部からは使わないこと.
#ifdef DEBUG

id _NAKAssertCast(id obj, Class expectedClass, id self, SEL _cmd, const char *file, int line, const char *function);

dispatch_queue_t _NAK_dispatch_get_current_queue();

#endif
