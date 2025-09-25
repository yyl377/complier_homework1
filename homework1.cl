class A2I {
    -- Convert a character to an integer
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
        abort(); 0;  -- The 0 is to prevent the type checker from erroring
    };

    -- Convert string to integer
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

    -- Handle conversion of negative numbers as well
    l2i(s : String) : Int {
        if s.length() = 0 then 0 else
        if s.substr(0, 1) = "-" then ~self.l2i_aux(s.substr(1, s.length() - 1)) else
        self.l2i_aux(s)
        fi fi;
    };

    -- Convert an integer to a string
    i2a(num : Int) : String {
        let result : String <- "" in
        let n : Int <- num in
        while n > 0 loop
            result <- result.concat(self.c2i(n % 10));
            n <- n / 10;
        pool;
        result;
    };
};

class List {
    -- Check if the list is empty (base case)
    isNil() : Bool {
        true;
    };

    -- Push a new element onto the stack
    cons(i : String) : Cons {
        (new Cons).init(i, self);  -- Create a new Cons object with i as head and self as rest
    };

    -- In the base case, list has no head, so abort
    head() : String {
        abort();
        "";
    };

    -- In the base case, list has no tail, so abort
    tail() : List {
        abort();
        self;
    };
};

class Cons inherits List {
    first : String;
    rest : List;

    -- Constructor to initialize the Cons object
    init(head : String, next : List) : Cons {
        first <- head;
        rest <- next;
        self;
    };

    -- Check if the list is empty
    isNil() : Bool {
        false;
    };

    -- Get the head (first element) of the list
    head() : String {
        first;
    };

    -- Get the rest (tail) of the list
    tail() : List {
        rest;
    };
};

class Main {
    stack : List;
    a2i : A2I;

    -- Initialize the main class, create stack and A2I instances
    init() : SELF_TYPE {
        stack <- new Cons("init", new List);  -- Initializing stack as Cons type, not List
        a2i <- new A2I;
        self;
    };

    -- Main evaluation method to process commands
    evaluate() : Void {
        let input : String in
        input <- io.in_string();

        while input != "x" loop  -- Loop until "x" is entered
            if input = "imnt" then
                let num : String in
                num <- io.in_string();
                stack <- stack.cons(num);  -- Push number into stack
            else
                if input = "+" then
                    if stack.isNil() then
                        out_string("Stack is empty\n");
                    else
                        let a : Int in
                        let b : Int in
                        stack <- stack.tail();
                        a <- a2i.l2i(stack.head());  -- Convert string to integer
                        stack <- stack.tail();
                        b <- a2i.l2i(stack.head());
                        stack <- stack.tail();
                        let sum : Int in
                        sum <- a + b;
                        stack <- stack.cons(a2i.i2a(sum));  -- Push the result back to stack
                    fi
                else
                    if input = "s" then
                        if stack.isNil() then
                            out_string("Stack is empty\n");
                        else
                            let a : String in
                            let b : String in
                            stack <- stack.tail();
                            a <- stack.head();  -- Swap top two elements
                            stack <- stack.tail();
                            b <- stack.head();
                            stack <- stack.tail();
                            stack <- stack.cons(a);  -- Push back a and b in swapped order
                            stack <- stack.cons(b);
                        fi
                    else
                        out_string("Invalid command\n");
                    fi
                fi
            fi;
            input <- io.in_string();  -- Read the next input
        pool;
    };
};
