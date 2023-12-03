# JNI
https://juejin.cn/post/7139843955457261605#heading-0
https://www.jianshu.com/p/87ce6f565d37
https://developer.android.com/training/articles/perf-jni?hl=zh-cn

## 方法注册

* `System.loadLibrary`
* 静态注册
    * 通过`javac -h . <.java>`生成头文件, 根据方法名将Java方法和native方法建立关联
    * 初次调用native方法时, 建立关联
* 动态注册
    * 在`JNI_OnLoad`函数通过RegisterNatives注册
    * System.loadLibrary时调用

## JavaVM和JNIEnv

* JavaVM: Android规定每个进程只有一个
* JNIEnv: 所有native函数的第一个参数, 线程局部变量, 跨线程无效.
* 常用API参考:
    * [Java与Native相互调用](https://www.jianshu.com/p/b71aeb4ed13d)
    * [JNI常用方法](https://www.jianshu.com/p/67081d9b0a9c)

## 类型对应

| Java    | JNI      | 签名 |
| ------- | -------- | ---- |
| byte    | jbyte    | B    |
| char    | jchar    | C    |
| double  | jdouble  | D    |
| float   | jfloat   | F    |
| int     | jinit    | I    |
| short   | jshort   | S    |
| long    | jlong    | J    |
| boolean | jboolean | Z    |
| void    | void     | V    |

| Java      | JNI           | 签名                  |
| --------- | ------------- | --------------------- |
| 类Object  | jobject       | L+class+;             |
| Class     | jclass        | Ljava/lang/Class;     |
| Throwable | jthrowable    | Ljava/lang/Throwable; |
| String    | jstring       | Ljava/lang/String;    |
| Object[]  | jobjectArray  | [L+classname+;        |
| byte[]    | jbyteArray    | [B                    |
| char[]    | jcharArray    | [C                    |
| double[]  | jdoubleArray  | [D                    |
| float[]   | jfloatArray   | [F                    |
| int[]     | jintArray     | [I                    |
| short[]   | jshortArray   | [S                    |
| long[]    | jlongArray    | [J                    |
| boolean[] | jbooleanArray | [Z                    |

可以通过`javap -s -p <.class>`命令查看一个Java类所有方法和成员签名

## JNI引用类型

* 局部引用: 最常见的引用类型, 在native方法返回时失效, 可通过DeleteLocalRef手动提前失效
* 全局引用: 需要手动NewGlobalRef和ReleaseGlobalRef, 在整个过程中有效, 可跨线程使用
* 弱全局引用: 和全局引用相似, 需要手动NewWeakGlobalRef和ReleaseWeakGlobalRef, 但即使没有ReleaseWeakGlobalRef也可能被gc
* 可以使用`(*env)->IsSameObject(env, obj1, obj2)`判断两个应用指向的对象是否相同
