Class 4 06/03/2019
Binary Search Tree 
Difference between two data structures
Hashing	BST	
O(1)	h	insert(key,value)
O(1)	h	lookup(key)
O(1)	h	delete(key)
amartized running time	O(logn) basically
support traversing by ordered keys
Binary Search Tree
Definition
class Node {
    int key;
    Node left;
    Node right;
}
     5
   /   \
  3     8
   \
    4
This is a BST

     5
   /   \
  3     8
   \
    6
This is not a BST
Left subtree is BST
Right subtree is BST
root.key > all keys in left subtree
and root.key < all keys in right subtree
Tree Traversals
Level-order
Pre-order
Post-order
In-order
Level-order Traversal
void LevelOrder(Node root) {
    Queue<Node> q = new LinkedList<>();
    q.offer(root);
    while (!q.isEmpty()) {
        Node cur = q.poll();
        // processing on cur; print cur.key;
        if (cur.left != null) q.offer(cur.left);
        if (cur.right != null) q.offer(cur.right);
    }
}
Right Side View Question
     5
   /   \
  3     8
   \
    4
we get the right side view as [5, 8, 4]
// we can just modify the original code by
cur, curLevel = q.dequeue();
res[cur_level] = cur.key


class Solution {
    // level order traversal 
    // on time on space
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> res = new LinkedList<>();
        if (root == null) return res;
        LinkedList<TreeNode> queue = new LinkedList<>();
        queue.offerLast(root);
        int size = 1;
        while (!queue.isEmpty()) {
            int temp=0;
            for (int i = 0; i < size; i++) {
                TreeNode cur = queue.pollFirst();
                if (cur.left != null) queue.offerLast(cur.left);
                if (cur.right != null) queue.offerLast(cur.right);
                temp = cur.val;
            }
            res.add(temp);
            size = queue.size();
        }
        return res;
    }
}
Pre-order Traversal
void PreOrder(Node cur) {
    if (cur == null) return;
    Process(cur);
    PreOrder(cur.left);
    PreOrder(cur.right);
}
In-order Traversal
     5
   /   \
  3     8
   \
    4
we get the inorder node list as [3, 4, 5, 8], which is  sorted.
Represent duplicate keys in BST
Requirement
Has to support root >= all left and root < all right.

MultiSet
MultiMap
       5
     /   \
    5     8
  /
  3     
   \
    4
```    

### Implementation
#### Lookup
```java
boolean Lookup(Node cur, int key) {
    if (cur == null) return false;
    if (cur.key == key) return true;
    if (cur.key < key) return Lookup(cur.right, key);
    return Lookup(cur.left, key);
}
Insert
Node insert(Node cur, int key, String val) {
    if (cur == null) return new Node(key, val);
    if (key == cur.key) cur.val = val;
    else if (key < cur.key) {
        cur.left = insert(cur.left, key, val);
    } else {
        cur.right = insert(cur.right, key, val);
    }
    return cur;
}
Delete
          5
        /   \
       3     6
     /  \
    2    4

Delete 5(2 children)

          4
        /   \
       3     6
     /  
    2    
```    

__Case 1: No children__
update parent's reference

__Case 2: Single child__
Parent pointing to child

__Case 2: two children__
1. find predecessor p
2. swap
3. delete recursively

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    # O logn time O logn space
    # Recursion
    # recursively find the root to delete
    # 3 edge cases
    # if no children, then simply return None
    # if 1 left child, then find the predecessor, swap, and delete the predecessor
    # if 1 right child, then find the successor, swap, and delete the successor
    # in common case, a node has both children, in this case we can find the predecessor as newNode or successor as new Node
    def deleteNode(self, root: TreeNode, key: int) -> TreeNode:
        if not root:
            return None
        if root.val > key:
            root.left = self.deleteNode(root.left, key)
        elif root.val < key:
            root.right = self.deleteNode(root.right, key)
        else:
            if not root.left and not root.right:
                root = None
            elif root.left:
                root.val = self.getPrev(root)
                root.left = self.deleteNode(root.left, root.val)
            else:
                root.val = self.getNext(root)
                root.right = self.deleteNode(root.right, root.val)
        return root
    def getPrev(self, root):
        temp = root.left
        while temp.right:
            temp = temp.right
        return temp.val
    def getNext(self, root):
        temp = root.right
        while temp.left:
            temp = temp.left
        return temp.val
Recap of BST
Predecessor and Successor
Logical view
          5
        /   \
       3     8
     /  \   /  \ 
    2    4 6    10
   /        \
  1          7
pre(8) = 7
pre(6) = 5
``` 
#### Predecessor
1. case1: rightmost node of the left subtree
2. case2: find smaller node on the ancestor path

#### Re-Definition of node
```Java
class Node {
    int key;
    Node left;
    Node right;
    Node parent;
}
Find Kth key in BST
Idea of In-order traversal
We can find the kth key by stopping at kth step during in-order traversal.

Our goal is to control the time in O(h).

Re-definition of Node
class Node {
    int key;
    Node left;
    Node right;
    Node parent;
}
Logical View
      5(5)
    /      \
   3(3)     10(1)
 /    \   
2(1)   4(1)
Code
int kth(Node root, int k) {
    rank = root.left.size + 1;
    if (rank == k) return root;
    if (rank < k) return kth(root.right, k - rank);
    return kth(root.left, k);
}
Example
          5(5)
        /      \
       3(3)     10(1)
     /    \   
    2(1)   4(1)

to find kth(4), rank = 4 = k, we just return 5

to find kth(3), rank = 2 < k, we call the func on 4(1), rank = 1 = k, return 4
