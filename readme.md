设计思路
cool语言中只有Int，String和Bool三种基本变量类型，此处输入既有数字也有符号，且无法预测，如果使用数字进行存储和处理，在读入处使用in_int，则所有的符号输入值均为0，因此，此处需要使用in_string进行输入；同时，在存储时如果使用Int，即用某个Int值来表示某个符号，必将导致Int能表示的数字变少，因此，此处采用读入String，存储String，仅在处理时将其取出转化为整数的方法。

A2I类的设计
设计A2I类的目的在于包含所有的字符串和数字之间相互转化的函数
首先是单个字符和单个数字之间相互转化的函数

--c2i将单个的字符转换成数字
c2i(char : String) : Int 
{
	if char = "0" then 0 else
	if char = "1" then 1 else
	if char = "2" then 2 else
	if char = "3" then 3 else
	if char = "4" then 4 else
	if char = "5" then 5 else
	if char = "6" then 6 else
	if char = "7" then 7 else
	if char = "8" then 8 else
	if char = "9" then 9 else
	{ abort(); 0; }  -- the 0 is needed to satisfy the typchecker
	fi fi fi fi fi fi fi fi fi fi
};

cool语言中的条件语句只有if，case语句用于实现runtime type tests on objects，故此处只能采用if嵌套。
接着设计字符串转化为整数，首先处理正数，此处采用了循环的方法，从字符串首到尾部进行扫描，将其转化为数字

l2i_aux(s : String) : Int
{
	(let int : Int <- 0 in
	{
		(let j : Int <- s.length() in
		(
			let i : Int <- 0 in
				while i < j loop
				{
					--使用循环，将字符串一一转化为数字
					int <- int * 10 + c2i(s.substr(i,1));
					i <- i + 1;
				}
				pool
		));
	int;
	})
};

接着，当需要处理的字符串为正数时，直接调用即可，否则取返回值的相反数

l2i(s : String) : Int
{
	--如果字符串长度为0，则直接返回0
	if s.length() = 0 then 0 else
	--如果第一个符号是负号，则返回后续数字的相反数
	if s.substr(0,1) = "-" then ~l2i_aux(s.substr(1,s.length()-1)) else
	--否则直接处理即可
	l2i_aux(s)
	fi fi
};

反方向同理即可。

堆栈类的设计
因为cool语言内容很少，既不能对指针进行操作，也没有数组，所以无法使用顺序表或者链表来实现栈，故此处借用链表的思路，不过不存储下一元素的链表，而是直接将除了栈的剩余部分都放在栈顶Cons里，下面我们用stack代表我们使用的栈。

List类

List类的本质是栈顶，一旦有元素入栈，那么stack就不再是List类，因此若stack为List，那么直接可以认为栈是空的，可依此设计List的函数isNil

isNil() : Bool 
{
	true
};
另一个有用的函数是cons，用于入栈

cons(i : String) : Cons
{
	(new Cons).init(i, self)
};

两个虚函数用于让cons来继承

head() : String
{
	{abort();
	"";}
};
	
tail() : List
{
	{abort();
	self;}
};

Cons类

Cons类继承List类，Cons类的本质可以认为是是栈中的元素，如果stack的类型是cons，那么栈中一定是有元素的，栈一定不是空的，可以依此设计出Cons的函数isNil

isNil() : Bool
{
	false
};
Cons类中有两个元素，first代表当前的栈顶元素，而rest则存储了栈除了栈顶以外的全部内容；

first : String;
rest :  List;

此处应当注意rest设定的类型是List，但是当我们的Cons不为栈底的第一个元素时，其rest类型应该是Cons，此处可用的原因在于Cons类继承了List类，根据COOL官方文档，所有接受List的地方都接受Cons，故可以这样使用。
一个栈可以如下图表示

通过上面的示意图我们可以进一步发现，一个栈中，只有栈底的类型是List类型。
head函数用于返回当前栈顶元素，即当前Cons的first，对应图中stack正在指向的Cons2的first，即为1。

head() : String
{	
	first
};

tial函数用于出栈，我们可以发现，当需要出栈时，仅需要将stack指向当前Cons的rest即可，例如图中若出栈，即可直接指向Cons2的rest，即为Cons1

tail() : List
{
	rest
};
init函数用于创建一个新的Cons，

init(head : String, next : List) : Cons
{
	{
		first<-head;
		rest<-next;
		self;
	}
};

结合List类的cons函数，我们可以发现其入栈操作为，先生成一个cons，其first为输入值，rest为当前的栈，然后使用cons函数将stack指向新生成的cons即可完成入栈操作。
此处我们就可以明确的知道，List类中的head和tail函数都是虚函数，作用仅为让Cons类来继承。

Main类
mian函数的本质在于始终进行循环并根据不同的输入进行处理，同上，cool语言中的条件语句只有if，case语句用于runtime type tests on objects，因此只能使用if嵌套的方式。

加操作

1、取出两个栈顶元素a,b
2、将其转换为int,即为anum和bnum
3、anum + bnum，得到结果cnum
4、结果转换为字符串c
5、将c压入栈

let a : Int <- new Int, b : Int <- new Int in 	
{
	a <- z.a2i(stack.head());
	stack <- stack.tail();
	b <- z.a2i(stack.head());
	stack <- stack.tail();
	let c : Int <- a + b in
	stack <- stack.cons(z.i2a(c));
};

s交换操作

1、取出两个元素a,b
2、按先a后b的顺序压入这两个元素

let a : String <- new String , b : String <- new String in 
{
	a <- stack.head();
	stack <- stack.tail();
	b <- stack.head();
	stack <- stack.tail();
	stack <- stack.cons(a);
	stack <- stack.cons(b);
};
