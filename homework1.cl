class A2I {
    c2i(char : String) : Int {
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
        abort();
        0;
    };

    l2i_aux(s : String) : Int {
        let int : Int <- 0 in
        let j : Int <- s.length() in
        let i : Int <- 0 in
        while i < j loop
            int <- int * 10 + self.c2i(s.substr(i, 1));
            i <- i + 1;
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

class List {
    isNil() : Bool {
        true;
    };

    cons(i : String) : Cons {
        (new Cons).init(i, self);
    };

    head() : String {
        abort();
        "";
    };

    tail() : List {
        abort();
        self;
    };
};

class Cons inherits List {
    first : String;
    rest : List;

    init(head : String, next : List) : Cons {
        first <- head;
        rest <- next;
        self;
    };

    isNil() : Bool {
        false;
    };

    head() : String {
        first;
    };

    tail() : List {
        rest;
    };
};

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
