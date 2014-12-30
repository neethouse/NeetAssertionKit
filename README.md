NeetAssertionKit
================

ニートのための Objective-C 用アサーションマクロ集.

[![Build Status](https://travis-ci.org/neethouse/NeetAssertionKit.svg)](https://travis-ci.org/neethouse/NeetAssertionKit)

## How To Install

You can use CocoaPods.

Add NeetHouse Specs repository.

```sh
# Run on the your shell
pod repo add neethouse https://github.com/neethouse/Specs
```

Append in the your Podfile.

```
pod 'NeetAssertionKit'
```

And install.

```sh
pod install
```

## Assertion Macros

### NAKAssertTrue(condition, fmt, ...)

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


### NAKFail(fmt, ...)

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


### NAKWrap(expression)

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



### NAKAssertNotNil(expression, fmt, ...)

expression が nil でないことを表明する.

リリースビルドでは取り除かれ, 指定した式も実行されない.

```objc

- (void)setHomuhomu:(NSString *)homuhomu {

   // homuhomu が nil の時エラー
   NAKAssertNotNil(homuhomu, @"ほむほむは nil 以外");

   ...
}
```


### NAKAssertKindOfClass(obj, clazz, fmt, ...)

オブジェクトが指定したクラス, またはそのサブクラスのインスタンスであることを表明する.

リリースビルドでは取り除かれる.

```objc

id obj = ...;

// obj が NSArray か, そのサブクラスのインスタンスであることを表明
NAKAssertKindOfClass(obj, NSArray, @"obj は NSArray かサブクラス");
```


### NAKAssertMemberOfClass(obj, clazz, fmt, ...)

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


### NAKAssertCast(expression, clazz)

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


### NAKAssertArrayType(array, clazz, fmt, ...)

NSArray 内のすべての要素が指定したクラスのサブクラスのインスタンスであることを表明する.

リリースビルドでは取り除かれる.

```objc

- (void)setStringArray:(NSArray *)array {

   // array に NSString (またはそのサブクラス) 以外のオブジェクトが入っているとエラー
   NAKAssertArrayType(array, NSString, @"文字列の配列を指定する");

   ...
}
```


### NAKAssertMainThread(fmt, ...)

実行されているスレッドがメインスレッドであることを表明する.

リリースビルドでは取り除かれる.

```objc

- (void)beginHomuhomuAnimation {

   // メインスレッド以外から呼ばれるとエラー
   NAKAssertMainThread(@"UI をいじるのでメインスレッドから呼ぶこと！");

   ...
}
```


### NAKAssertDispatchQueue(queue, fmt, ...)

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

