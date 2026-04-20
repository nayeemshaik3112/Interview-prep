Java 17 Complete Notes

Java 17 is a long term support release that focuses on reducing boilerplate, improving safety, enforcing better design, and providing modern language features.

Java 8 introduced functional programming. Java 11 focused on cleanup and stability. Java 17 focuses on modern language design, safety, and maintainability. 

Records

Definition
Record is a special type of class used to represent immutable data. It automatically generates constructor, accessors, equals, hashCode and toString methods.

Explanation
Record is used when a class is only meant to hold data. It removes unnecessary boilerplate and clearly expresses that the class is immutable and has no behavior-heavy logic.

Syntax
record User(String name, int age) {}

Accessing data
user.name()
user.age()

Constructors
record User(String name, int age) {
public User {
if (age < 0) throw new IllegalArgumentException();
}
}

Methods
record User(String name, int age) {
public boolean isAdult() {
return age >= 18;
}
}

Important points
Fields are final
Class is final
Cannot extend another class
inheritance not supported
Can implement interfaces
Shallow immutable (internal objects can change)

Usage
DTOs, API responses, event payloads, read-only models
-----------------------------------------------------------------

Sealed Classes

Definition
Sealed class restricts which classes can extend it using the permits keyword.

Explanation
It is used to control inheritance and model a fixed set of types. It prevents unwanted extensions and improves domain safety.

Syntax
sealed class Vehicle permits Car, Bike {}

final class Car extends Vehicle {}
final class Bike extends Vehicle {}

Modifiers
final means no further extension
sealed means controlled extension
non-sealed means open again

Example
sealed class Payment permits CreditCard, UPI {}

final class CreditCard extends Payment {}
final class UPI extends Payment {}

Usage
Domain modeling, event types, state machines

-----------------------------------------------------------------

Pattern Matching for instanceof

Definition
Pattern matching allows type checking and casting in a single step.

Explanation
It removes explicit casting and makes code cleaner and safer.

Syntax
if (obj instanceof String s) {
System.out.println(s.length());
}

Advanced
if (obj instanceof String s && s.length() > 5) {
System.out.println(s);
}

Important points
No manual casting required
Variable scope limited to condition block

-----------------------------------------------------------------

Switch Expressions

Definition
Switch expression is a modern switch that returns a value and avoids fall-through.

Explanation
It simplifies decision logic and removes the need for break statements.

Syntax
int result = switch(day) {
case MONDAY -> 1;
case TUESDAY -> 2;
default -> 0;
};

Block usage
int result = switch(day) {
case MONDAY -> {
yield 1;
}
default -> 0;
};

Important points
No fall-through
Returns value
Cleaner syntax

-----------------------------------------------------------------

Text Blocks

Definition
Text block is a multi-line string literal that avoids escape characters.

Explanation
It is used for writing JSON, SQL, XML or any multi-line content in a clean format.

Syntax
String json = """
{
"name": "Nayeem"
}
""";

Important points
No need for \n or concatenation
Maintains readability
Still treated as String internally

-----------------------------------------------------------------

Helpful NullPointerException

Definition
Helpful NullPointerException provides detailed information about which object was null.

Explanation
Instead of a generic null pointer error, Java shows exactly where the null occurred in a chain.

Example
String name = user.getAddress().getCity();

Error
Cannot invoke "Address.getCity()" because "user.getAddress()" is null

Important points
Improves debugging
Does not prevent null pointer
Only improves error message

-----------------------------------------------------------------

Strong Encapsulation

Definition
Strong encapsulation restricts access to internal JDK APIs.

Explanation
Developers can no longer access internal classes like sun.misc.Unsafe. Only official APIs are allowed.

Example
import sun.misc.Unsafe;  // not allowed in Java 17

Important points
Improves security
Improves stability
Forces use of standard APIs

Bypass (not recommended)
--add-opens
--add-exports

-----------------------------------------------------------------

Foreign Function and Memory API

Definition
Foreign Function and Memory API allows Java to interact with native code and off-heap memory without JNI.

Explanation
It provides a safer and simpler way to call C or C++ functions and manage memory outside JVM heap.

Concepts
Foreign function means calling native code
Foreign memory means accessing off-heap memory

Important components
MemorySegment represents memory block
MemoryAddress represents pointer
Linker connects Java to native code

Usage
High performance systems, native integrations

Important points
Replaces JNI conceptually
Safer and structured
Incubator feature in Java 17

-----------------------------------------------------------------

Vector API

Definition
Vector API allows performing computations on multiple data elements in parallel using CPU vector instructions.

Explanation
Instead of processing one value at a time, it processes multiple values together, improving performance.

Example concept
Normal
for each element do operation

Vector
process multiple elements in one CPU instruction

Usage
Scientific computing, data processing, machine learning

Important points
Improves performance
Uses SIMD (Single Instruction Multiple Data)
Incubator feature in Java 17

-----------------------------------------------------------------

Enhanced Pseudo Random Number Generator

Definition
Enhanced random generator provides better random number algorithms and flexibility.

Explanation
Java 17 introduces new interfaces and implementations for generating random numbers with better quality and performance.

Example
RandomGenerator generator = RandomGenerator.of("L64X128MixRandom");
int value = generator.nextInt();

Important points
Multiple algorithms available
Better performance than old Random
More control over randomness

-----------------------------------------------------------------

Remaining Java 17 Features Summary

Records
Sealed Classes
Pattern Matching for instanceof
Switch Expressions
Text Blocks
Helpful NullPointerException
Strong Encapsulation
Foreign Function and Memory API
Vector API
Enhanced Random Number Generator

-----------------------------------------------------------------

Final Understanding

Java 17 focuses on making Java code cleaner, safer, and more expressive. It reduces boilerplate through records, controls design using sealed classes, simplifies logic using pattern matching and switch expressions, improves debugging with helpful null pointer messages, enforces security through strong encapsulation, and introduces advanced APIs for performance and native integration.
