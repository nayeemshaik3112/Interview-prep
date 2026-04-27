It is stored in Key - Value pair

HashMap<Integer, String> hmap = new HashMap<>();
hmap.put(1, "Shaik");
hmap.put(2, "Nayeem");

hmap.containsKey(1);         -> Shaik
hmap.containsValue("Nayeem") -> True
----------------------------------------------------------
loop:
Set<Interger> keys = hmap.KeySet(); // Order won't exist in Hmap

for (Map.Entry<Integer, String> entries : hmap.entrySet()) {
    System.out.println("Key: " + entries.getKey() + " Value: " + entries.getValue());
}
----------------------------------------------------------
-> if we write same key with different value, it will override the previous value , means it will override
-> can have onlly one null key but can have multiple null values
-> Not Synchronized - Not thread safe , require external synchronization if used in threaded environment
-> offers 0(1) time complexity for get and put operations on average
----------------------------------------------------------
Internal Structure of HashMap:
hashmap has 4 components:
Key
value
Hash function
Bucket

Key, value is the data we want to store in the hashmap

Hash function is used to compute the hash code of the key, which determines the bucket where the key-value pair will be stored.
The hash function takes the key as input and returns an integer hash code.
hash code means the index of the bucket where the key-value pair will be stored.
int index = hash(key) % arraysize; // to get the index of the bucket
for example if we have a key "Shaik" and the hash function returns a hash code of 12345, and the array size is 100, then the index of the bucket will be 12345 % 100 = 45. 
So the key-value pair ("Shaik", "Nayeem") will be stored in bucket index 45.
Here the array size means the number of buckets in the hashmap. The default size of the bucket array is 16, but it can be increased or decreased as needed.

Bucket is a data structure that holds the key-value pairs. Each bucket can contain multiple key-value

When you declare a HashMap: HashMap<Integer, String> hmap = new HashMap<>();
It creates 16 buckets initially (bucket indices 0-15)
The Power of 2 resizing is about the TOTAL bucket count:

Initially: 16 buckets (indices 0-15)
After first resize: 32 buckets (indices 0-31)
After second resize: 64 buckets (indices 0-63)
After third resize: 128 buckets (indices 0-127)
And so on... (256, 512, 1024, etc.)
----------------------------------------------------------
How HashMap retrives a data:

Hashing the key: When you call hmap.get(1), the HashMap computes the hash code of the key (1 in this case) using the hash function. The hash code is an integer that represents the key
Finding the bucket: The HashMap uses the hash code to determine which bucket to look in. It does this by taking the hash code and performing a modulo operation with the number of buckets (hash code % number of buckets). This gives the index of the bucket where the key-value pair is stored.
Searching for the key: Once the HashMap identifies the correct bucket, it searches through the bucket for the key (1 in this case). If it finds the key, it returns the corresponding value ("Shaik"). If it does not find the key, it returns null.
----------------------------------------------------------
Collision in HashMap happens when two different keys are mapped to the same bucket index. This does not necessarily mean the hashCode is the same; even different hashCodes can result in the same index because the array size is limited.

Internally, HashMap stores entries in an array. When a collision occurs, multiple key-value pairs are stored at the same index. Initially, these are maintained using a linked list structure, where each node points to the next.

The drawback of a linked list is that search time can degrade to O(n) in the worst case, especially if many elements are stored in the same bucket.

To improve performance, from Java 8 onwards, if the number of elements in a bucket exceeds a certain threshold (typically 8), the linked list is converted into a Red-Black Tree. This ensures that operations like search, insert, and delete take O(log n) time instead of O(n).

If the number of elements reduces below a lower threshold (typically 6), the structure is converted back to a linked list.

Collision is a normal and expected behavior in hashing, and HashMap handles it efficiently using a combination of hashing, indexing, and dynamic data structure transformation.
----------------------------------------------------------

Keys:
"A" → index 4
"C" → index 4   (collision)

Array:

Index      Data
-----      ----
4          (A,100) → (C,300)
----------------------------------------------------------

LL : Index 4: 0(N) operations

(A,100) → (C,300) → (X,500) → (Y,700)
----------------------------------------------------------
Log(n) operations in Red-Black Tree
After Java 8 (Converted to Red-Black Tree)
Index 4:

            (C,300)
           /       \
     (A,100)     (X,500)
                       \
                       (Y,700)
----------------------------------------------------------
HashMap Rehashing:
In HashMap, the default load factor is 0.75. This means the HashMap will allow 75% of its capacity to be filled before resizing.

Initial capacity = 16
Load factor = 0.75

Threshold = 16 × 0.75 = 12

So, when the number of key-value pairs reaches 12, the HashMap will resize.

Resizing means:

* A new array is created with double the capacity (16 → 32)
* All existing entries are rehashed and placed into new buckets

Important point:
Resizing does not happen when the array is full (16), it happens when threshold (12) is crossed.

Reason:
To reduce collisions and maintain good performance.

After resizing:
New capacity = 32
New threshold = 32 × 0.75 = 24

This process continues as elements increase.

Summary:
HashMap grows dynamically based on load factor, not when it is completely full.
----------------------------------------------------------