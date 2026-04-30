Repository ->
fetch data -> 
service layer decides business rules ->
stream/lambda/optional/collector helps express that logic cleanly

Full Java 8 Features List
These are the most important Java 8 features for backend/service-layer development:

Lambda Expressions
Functional Interfaces
Method References
Streams API
Stream operations
Optional
Default methods in interfaces
Static methods in interfaces
Collectors
forEach
Predicate
Function
Consumer
Supplier
BinaryOperator
Comparator improvements
Date and Time API (java.time)
CompletableFuture
Base64 API
Nashorn JavaScript engine

users.stream()
     .filter(User::isActive)
     .map(User::getEmail)
     .sorted()
     .collect(Collectors.toList());

stream() = I want to process a collection
filter() = keep only needed records
map() = convert one form to another
sorted() = arrange data
collect() = bring result back into a list/set/map

Then convert requirement into steps:

get users, keep active users, keep premium users, keep recent users, sorted, convert to DTO

public List<UserResponseDto> getRecentActivePremiumUsers() {
        LocalDate thirtyDaysAgo = LocalDate.now().minusDays(30);

        return userRepository.findAll().stream()
                .filter(User::isActive)
                .filter(user -> user.getPlan() == Plan.PREMIUM)
                .filter(user -> user.getCreatedDate() != null)
                .filter(user -> !user.getCreatedDate().isBefore(thirtyDaysAgo))
                .sorted(Comparator.comparing(User::getName))
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    private UserResponseDto toDto(User user) {
        return new UserResponseDto(user.getId(), user.getName(), user.getEmail());
    }
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Lambda Expression
What is it?
Short way to write implementation of functional interface.

Use when you need small behavior logic:

filtering
mapping
sorteding
validation rule
callback logic
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Functional Interface
What is it?
Interface with only one abstract method.

Examples:

Predicate<T> - represents a boolean-valued function of one argument.
Predicate<User> isAdult = user -> user.getAge() >= 18;

Predicate<User> active = User::isActive;
Predicate<User> verified = User::isVerified;

return users.stream()
        .filter(active.and(verified))
        .collect(Collectors.toList());
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function<T, R> - takes input T, returns R -> Function<User, UserDto> userMapper = this::toDto;

Consumer<T> - takes input T, returns nothing -> Consumer<User> userPrinter = System.out::println;

Supplier<T> - takes no input, returns T -> Supplier<User> userSupplier = () -> new User("John", 30);
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Method References - short form of lambda and used in filter/map/sorted operations when you want to call an existing method in same class
User::isActive
User::getEmail nothing but  user -> user.getEmail()

users.stream().filter(User::isActive()).map(user -> user.getEmail()).collect(Collectors.toList()).forEach(System.out::println);
Not to use method reference when you need to do more than just call a method, like user -> user.getEmail().toLowerCase() cannot be replaced with method reference.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Filter - Remove unwanted elements from stream based on condition
When to use in service layer?
Use when requirement says:

only active users
only paid orders
only successful transactions
only users with role ADMIN
only records after some date

When to use : when says only, exclude, include, eligible, matching
valid
public List<Order> getDeliveredOrders(List<Order> orders) {
    return orders.stream()
            .filter(order -> order.getStatus() == OrderStatus.DELIVERED)
            .collect(Collectors.toList());
}
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
map()
What is it?
Transforms one object into another.

.map(User::getEmail)
When to use in service layer?
Use when converting:

Entity -> DTO
DTO -> Entity
Order -> price
User -> username
Product -> ProductResponse
public List<UserDto> getUserDtos() {
    return userRepository.findAll().stream()
            .map(this::toDto)
            .collect(Collectors.toList());
}
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
sorted()
.sorted(Comparator.comparing(User::getName))

“If requirement says order, top, latest, ascending, descending, use sorted() or DB ORDER BY.”
public List<Employee> getEmployeessortedBySalary(List<Employee> employees) {
    return employees.stream()
            .sorted(Comparator.comparing(Employee::getSalary).reversed())
            .collect(Collectors.toList());
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
collect()
What is it?
Converts stream result into final structure.

Common types
Collectors.toList()
Collectors.toSet()
Collectors.toMap()
Collectors.groupingBy()
Collectors.joining()
Collectors.counting()
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
forEach()
users.stream()
    .filter(User::isActive)
    .forEach(user -> sendEmail(user));  // Ends here, can't add .map() after
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Date and Time API
Important classes:

LocalDate
LocalDateTime
LocalTime
ZonedDateTime
Period
Duration
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CompletableFuture

CompletableFuture<User> userFuture =
        CompletableFuture.supplyAsync(() -> userRepository.findById(id).orElseThrow());

CompletableFuture<List<Order>> orderFuture =
        CompletableFuture.supplyAsync(() -> orderRepository.findByUserId(id));

UserDashboard dashboard = userFuture.thenCombine(orderFuture, (user, orders) ->
        new UserDashboard(user, orders)
).join();
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a UserService method getActiveUserEmails() that fetches all users from userRepository, keeps only active users, converts them to email list, removes null emails, sorteds emails alphabetically, and returns List<String>.
public List<String> getActiveUserEmails(){
    return userRepository.findAll().stream().
        filter(user -> user.isActiveusers())
        .map(User::getemail && user -> user.getemail != null) //Not for null check only for converting into another object
        .sorted(Comparator.comparing(User::getName))
        .Collect(Collectors.toList())
}

correct :

public List<String> getActiveUserEmails() {
    return userRepository.findAll().stream()
            .filter(User::isActive)
            .map(User::getEmail)
            .filter(Objects::nonNull)
            .sorted()
            .collect(Collectors.toList());
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a UserService method getUserById(Long userId) that calls userRepository.findById(userId), throws RuntimeException("User not found") if absent, and returns a UserDto using map() or a mapper method.

public UserDto getUserById(Long userId){
    return userRepository.findById(userId)
            .map(this::toDTo);
            .orElseThrow(() -> new RuntimeException("User not found"));
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a ProductService method getAvailableProductssortedByPrice() that returns only products with available=true and stock > 0, sorted by price ascending, then mapped to ProductResponseDto.
public ProductResponseDto getAvailableProductssortedByPrice(){
    return userRepository.findall().stream()
            .filter(products -> products.isAvailable() == true)
            .filter(products -> products.getStock() > 0)
            .sorted(Comparator.comparing(Product::getPrice()))
            .map(this::toDto)
            .collect(Collectors.toList());
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write an OrderService method getDeliveredOrdersForCustomer(Long customerId) that fetches orders by customer id, keeps only delivered orders, sorteds by delivered date descending, and returns DTOs.
public List<OrderDto> getDeliveredOrdersForCustomer(Long customerId) {
    return orderRepository.findByCustomerId(customerId).stream()
            .filter(Order::isDelivered)
            .sorted(Comparator.comparing(Order::getDeliveredDate).reversed())
            .map(this::toDto)
            .collect(Collectors.toList());
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a PaymentService method getHighValueSuccessfulPayments(Long customerId) that returns payments where status is SUCCESS and amount is greater than 5000, sorted by created time descending.
public List<PaymentDto> getHighValueSuccessfulPayments(Long customerId) {
    return paymentRepository.findByCustomerId(customerId).stream()
            .filter(payment -> payment.getStatus() == PaymentStatus.SUCCESS)
            .filter(payment -> payment.getAmount().compareTo(BigDecimal.valueOf(5000)) > 0)
            .sorted(Comparator.comparing(Payment::getCreatedDate).reversed())
            .map(this::toDto)
            .collect(Collectors.toList());
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a DepartmentService method groupEmployeesByDepartment() that fetches all employees and returns Map<String, List<Employee>> using Collectors.groupingBy(...).
employees.stream().findAll().collect(Collectors.groupingBy(Employee::getDepartment))
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a UserService method getDistinctRolesOfActiveUsers() where each user has List<Role> roles. 
Fetch all users, keep only active users, flatten all roles, 
convert roles to role names, remove duplicates, sorted them, and return List<String>.

public List<String> getDistinctRolesOfActiveUsers() {
    return userRepository.findAll().stream()
            .filter(User::isActive)                          // Keep only active users
            .flatMap(user -> user.getRoles().stream())       // Flatten all roles
            .map(Role::getRoleName)                          // Convert to role name
            .distinct()                                       // Remove duplicates
            .sorted()                                         // Sort alphabetically
            .collect(Collectors.toList());
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Write a reusable Predicate<User> for “active premium user”, then use it in a service method getActivePremiumUsers().
private final Predicate<User> isActivePremiumUser =
        user -> user.isActive() && user.getPlan() == Plan.PREMIUM;

public List<UserDto> getActivePremiumUsers() {
    return userRepository.findAll().stream()
            .filter(isActivePremiumUser)
            .map(this::toDto)
            .collect(Collectors.toList());
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Java 8 / Functional Programming

What is Functional Interface
Can functional interfaces have default methods

Default methods are introduced in Java 8 to allow interfaces to have method implementations, enabling backward compatibility when new methods are added. They are inherited and can be overridden by implementing classes.

Static methods in interfaces belong to the interface itself, are not inherited, and are used for utility or helper functionality related to the interface.

Why default methods are introduced when abstract classes are already present
 Difference between intermediate and terminal stream operations

Intermediate operations are lazy and return a stream, while terminal operations trigger execution and produce a result.
Intermediate - filter , map . Terminal - which collect(), foreach(), count().

Map vs FlatMap

// Sample data
User1 (active): roles = [ADMIN, USER, MANAGER]
User2 (active): roles = [USER, VIEWER]
User3 (active): roles = [ADMIN, VIEWER]

// After filter(User::isActive)
Stream: [User1, User2, User3]

// After flatMap(user -> user.getRoles().stream())
// ↓ Flattens all role lists into single stream
Stream: [ADMIN, USER, MANAGER, USER, VIEWER, ADMIN, VIEWER]

// After map(Role::getRoleName)
Stream: ["ADMIN", "USER", "MANAGER", "USER", "VIEWER", "ADMIN", "VIEWER"]

// After distinct()
Stream: ["ADMIN", "USER", "MANAGER", "VIEWER"]

// After sorted()
Stream: ["ADMIN", "MANAGER", "USER", "VIEWER"]

List: ["ADMIN", "MANAGER", "USER", "VIEWER"]
