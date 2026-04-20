Encapsulation, Inheritance, Polymorphism, Abstraction, SOLID, HashMap, ConcurrentHashMap, TreeMap, HashSet, 
Load factor, Rehashing, ConcurrentHashMap, CopyOnWriteArrayList, Thread lifecycle, Runnable, 
Callable, Future, ExecutorService, ForkJoinPool, synchronized, Lock, ReentrantLock, volatile, Heap, Stack, 
Metaspace, GC algorithms, map, filter, reduce, flatMap, parallel streams, Predicate, Function, Consumer, Supplier, 
Checked exception, Unchecked exception, Custom exception, Singleton, Factory, Builder, Strategy

# Why are Wrapper Classes Needed?
-> To Convert primitive into Objects.
Best Practices in Using Wrapper Classes
-> To convert into different values , Integer.parseInt, double into String

# How does Java optimize memory usage with Integer.valueOf()?  
->Java Optimise the memory with valueof by not creating one more new object instead it will convert the existing int into
means primitive into Wrapper.
Java Integer creates -128 to 127 so Integer a = valueof(100) Integer b = valueof(100) Both are equal because it falls on in b/w -128 to 127 
If it is valueof(200) then it is out of range so it creates a new obj

# Why Are Wrapper Classes in Java Immutable and how we can achieve the immutability
-> 3 Ways we can achive immutability
1. Through no setters , only getters4
2. private final fields -> Prevents mutable after intilization
3. final class -> prevents subclassing

# String vs StringBuffer vs StringBuilder and Why Are String Classes in Java Immutable?
C:\Users\Lenovo\Desktop\Projects\Notes\Interview Prep\DSA - Notes.md

How do Text Blocks Help?
C:\Users\Lenovo\Desktop\Projects\Notes\Interview Prep\Java - 17 Features.md 
- TEXT BLOCKS 

What is a String Pool?
How Does intern() Work?
-> It forces the created object to move into string pool even if it is created with New keyword
s1.intern() -> moves to pool

What are the things to be careful about when comparing Strings?
-> String s1 = new String ("Hello") and String s2 = "Hello"
if s1 == s2 then false
s1.equals(s2) true , it validates the content

How does Local Variable Type Inference Help? (Java 10)
How do Records improve the conciseness of Java code?
What are the best practices with Records?
What are the things that you should be careful about when using Records?
