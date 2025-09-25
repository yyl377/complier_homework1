Cool语言堆栈实现
概述
本项目使用 Cool 语言 实现了一个 栈。栈使用链表结构来存储元素，通过链表模拟栈的操作，包括数字和符号的处理。由于 Cool 语言的限制（只有 Int、String 和 Bool 三种基本数据类型），该栈实现采用字符串存储，并在处理时将字符串转换为整数。
主要功能:
A2I 类: 实现字符串和整数之间的转换。
List 和 Cons 类: 基于链表的栈实现。
Main 类: 处理用户输入和栈操作（如推入、弹出、加法和交换）。

设计与功能
A2I 类
A2I 类提供了将字符串转换为整数的方法：
c2i: 将单个字符转换为对应的整数值（0-9）。
l2i_aux: 将字符串转换为整数，逐个字符转换。
l2i: 处理负数情况，将字符串转换为整数。

List 和 Cons 类
List: 作为栈的基类，表示一个空栈。
Cons: 作为栈的节点，包含一个字符串和指向下一个节点的引用。它实现了栈的基本操作。
isNil(): 检查栈是否为空。
cons(): 将一个新元素压入栈。
head(): 返回栈顶元素。
tail(): 返回去除栈顶元素后的栈。

Main 类
Main 类负责管理栈和处理用户输入：
imnt: 将字符串压入栈。
+: 弹出栈顶两个元素，将其转换为整数，相加并将结果压回栈。
s: 弹出栈顶两个字符串，交换它们，然后重新压回栈。
x: 退出程序。

使用方法
运行步骤
安装 Cool 语言编译器：确保安装了 Cool 编译器（coolc）。如果尚未安装，请参考 Cool 语言文档中的安装说明。
编写代码：将提供的代码复制到 .cl 文件中。
编译代码：
使用以下命令编译你的 Cool 代码：
coolc <filename>.cl
运行代码：
编译成功后，使用 Cool 语言解释器（如果可用）运行程序。程序会提示你输入命令并执行栈操作。


代码结构
A2I 类
class A2I {
    c2i(char : String) : Int {
        if char = "0" then 0 else
        ...
    };

    l2i_aux(s : String) : Int {
        let int : Int <- 0 in
        let j : Int <- s.length() in
        let i : Int <- 0 in
        while i < j loop
            int <- int * 10 + self.c2i(s.substr(i, 1));
            i <- i + 1
        pool;
        int;
    };

    l2i(s : String) : Int {
        if s.length() = 0 then 0 else
        if s.substr(0, 1) = "-" then ~self.l2i_aux(s.substr(1, s.length() - 1)) else
        self.l2i_aux(s)
        fi fi;
    };
};

List 和 Cons 类
class List {
    isNil() : Bool {
        true
    };

    cons(i : String) : Cons {
        (new Cons).init(i, self)
    };

    head() : String {
        abort();
        ""
    };

    tail() : List {
        abort();
        self
    };
};

class Cons inherits List {
    first : String;
    rest : List;

    init(head : String, next : List) : Cons {
        first <- head;
        rest <- next;
        self
    };

    isNil() : Bool {
        false
    };

    head() : String {
        first
    };

    tail() : List {
        rest
    };
};

Main 类
class Main {
    stack : List;
    a2i : A2I;

    init() : SELF_TYPE {
        stack <- new List;
        a2i <- new A2I;
        self;
    };

    evaluate() : Void {
        let input : String in
        input <- io.in_string();

        while input != "x" loop
            if input = "imnt" then
                let num : String in
                num <- io.in_string();
                stack <- stack.cons(num)
            else
                if input = "+" then
                    let a : Int in
                    let b : Int in
                    stack <- stack.tail();
                    a <- a2i.l2i(stack.head());
                    stack <- stack.tail();
                    b <- a2i.l2i(stack.head());
                    stack <- stack.tail();
                    let sum : Int in
                    sum <- a + b;
                    stack <- stack.cons(z.i2a(sum))
                else
                    if input = "s" then
                        let a : String in
                        let b : String in
                        stack <- stack.tail();
                        a <- stack.head();
                        stack <- stack.tail();
                        b <- stack.head();
                        stack <- stack.tail();
                        stack <- stack.cons(a);
                        stack <- stack.cons(b)
                    else
                        out_string("Invalid command\n")
                    fi
                fi
            fi;
            input <- io.in_string();
        pool;
    };
};
