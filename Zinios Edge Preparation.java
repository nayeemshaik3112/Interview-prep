1. Two Sum
Store each numbers index in a HashMap. For each element, check if (target - num) already exists.
// O(n) time, O(n) space

public int[] twoSum(int[] nums, int target) {
    Map<Integer, Integer> map = new HashMap<>();
    for (int i = 0; i < nums.length; i++) {
        int complement = target - nums[i];
        if (map.containsKey(complement))
            return new int[]{map.get(complement), i};
        map.put(nums[i], i);
    }
    return new int[]{};
}
---------------------------------------------------------------------------------------------------------
2. Longest Substring Without Repeating Characters
Use a sliding window with a HashSet. Expand right pointer; if duplicate found, shrink left.
// O(n) time, O(min(n,m)) space

public int lengthOfLongestSubstring(String s) {
    Set<Character> set = new HashSet<>();
    int left = 0, maxLen = 0;
    for (int right = 0; right < s.length(); right++) {
        while (set.contains(s.charAt(right)))
            set.remove(s.charAt(left++));
        set.add(s.charAt(right));
        maxLen = Math.max(maxLen, right - left + 1);
    }
    return maxLen;
}
---------------------------------------------------------------------------------------------------------
3. Group Anagrams
Given a list of strings, group the anagrams together.
// O(n * k log k) time where k = avg string length
 
public List<List<String>> groupAnagrams(String[] strs) {
    Map<String, List<String>> map = new HashMap<>();

    for (String word : strs) {

        // Step 1: convert to char array and sort
        char[] arr = word.toCharArray();
        Arrays.sort(arr);

        // Step 2: create key from sorted chars
        String key = new String(arr);

        // Step 3: add into map
        if (!map.containsKey(key)) {
            map.put(key, new ArrayList<>());
        }
        map.get(key).add(word);
    }

    // Step 4: return grouped values
    return new ArrayList<>(map.values());
}
---------------------------------------------------------------------------------------------------------
4. Find Missing Number in Array
// O(n) time, O(1) space — XOR method

public int missingNumber(int[] nums) {
    int xor = nums.length;
    for (int i = 0; i < nums.length; i++)
        xor ^= i ^ nums[i];
    return xor;
}
---------------------------------------------------------------------------------------------------------
5. Maximum Subarray Sum (Kadanes Algorithm)
// O(n) time, O(1) space

public int maxSubArray(int[] nums) {
    int currentSum = nums[0];
    int maxSum = nums[0];

    for (int i = 1; i < nums.length; i++) {
        currentSum = Math.max(nums[i], currentSum + nums[i]);
        maxSum = Math.max(maxSum, currentSum);
    }

    return maxSum;
}
---------------------------------------------------------------------------------------------------------