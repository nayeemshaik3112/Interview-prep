

//     public static void main(String[] args) {
//         int[] arr1 = {1, 2, 3, 2};
//         int[] arr2 = {2, 3, 1, 2};

//         boolean result = areEqualIgnoringOrder(arr1, arr2);
//         System.out.println(result);
//     }

//     public static boolean areEqualIgnoringOrder(int[] arr1, int[] arr2) {
        
//         Map<Integer, Integer> hmap = new HashMap<>();

//         for (int i=0; i< arr1.length; i++){
//             hmap.put(arr1[i] , hmap.getOrDefault(arr1[i], 0) + 1);
//         }

//         for (int i=0; i< arr2.length; i++){
//             Integer count = hmap.get(arr2[i]);

//             if (count == 0 || count == null) return false;
//             if (count == 1) hmap.remove(arr2[i]);
//             else hmap.put(arr2[i], count - 1);
//         }
//         return hmap.isEmpty();
//     }
// }
// -----------------------------------------------------------------------

// class Main {
//     public static void main(String[] args) {
//         String s = "his mine his ours mine yours his ours his theirs";

//         int count = countHis(s);
//         System.out.println(count);
//     }


//     public static int countHis(String s) {
//         int count = 0;
//         String [] words = s.split(" ");
//         for (String word : words){
//             if (word.equals("his")) count ++;
//         }
//         return count;
//     }
// }
// -----------------------------------------------------------------------

// class Main {

//     public static void main(String[] args) {
//         int[] nums = {1, 2, 3, 4};
//         List<int[]> pairs = generatePairs(nums);

//         for (int[] pair : pairs) {
//             System.out.println("[" + pair[0] + ", " + pair[1] + "]");
//         }
//     }

//     public static List<int[]> generatePairs(int[] nums) {
//         List<int[]> list = new ArrayList<>();

//         for (int i=0; i< nums.length; i++){
//             for (int j=i + 1; j<nums.length; j++){
//                 list.add(new int []{nums[i] , nums[j]});
//             }
//         }
//         return list;
//     }
// }
// -----------------------------------------------------------------------

// class Main {

//     public static void main(String[] args) {
//         int[] nums = {-2, 1, -3, 4};

//         int result = maxSubarraySum(nums);
//         System.out.println(result);
//     }

//     public static int maxSubarraySum(int[] nums) {
//     int maxi = Integer.MIN_VALUE, sum = 0;
//         for (int i=0; i<nums.length; i++){
            

//             sum = sum + nums[i];

//             if (sum > maxi) maxi = sum;
//             if (sum < 0) sum = 0;
//         }
//         return maxi;
//     }
// }
// // -----------------------------------------------------------------------
// class Main {

//     public static void main(String[] args) {
//         int[] nums = {2, 2, 1, 4, 4, 5, 5, 1, 0};

//         int result = findSingleNumber(nums);
//         System.out.println(result);
//     }

//     public static int findSingleNumber(int[] nums) {

//         Map<Integer, Integer> hmap = new HashMap<>();
//         for (int i : nums){
//             hmap.put(i, hmap.getOrDefault(i, 0) + 1);
//         }

//         for (Map.Entry<Integer, Integer> map : hmap.entrySet()){
//             if (map.getValue() == 1) return map.getKey();
//         }

//     return -1;
//     }
// }
// -----------------------------------------------------------------------
class Main {

    public static void main(String[] args) {
        int[] nums = {2, 7, 11, 15};
        int target = 9;

        int[] result = twoSum(nums, target);
        System.out.println(result[0] + " " + result[1]);
    }

    public static int[] twoSum(int[] nums, int target) {

        java.util.Map<Integer, Integer> hmap = new java.util.HashMap<>();

        for (int i = 0; i < nums.length; i++) {
            int val = target - nums[i];

            if (hmap.containsKey(val)) {
                return new int[]{hmap.get(val), i};
            } else {
                hmap.put(nums[i], i);
            }
        }

        return new int[]{-1, -1};
    }
}
// -----------------------------------------------------------------------