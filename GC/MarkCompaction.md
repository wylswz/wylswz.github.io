# Mark and Compaction Algorithms
Mark and compaction alorithms can illeviate fragmentation of memory by relocating live objects

## Strategy of relocating

- Arbitrary: Relocate objects in arbitrary order.
  - Simple to implement
  - Poor data locality for mutators
- Linearising: Relocate object based on dependencies (like referencing fields)
  - Better locality
- Sliding: Slide object to one end of the heap

## Algorithms

### Two finger compaction

The idea is that if we know the total size of live objects, we can find the **high water threshold** of the heap, then we simple move data below that threshold.

1. Find high-water threshold
2. Initialize two pointers, **free** and **scan**
   1. Free start at the beginning of address space and move forward
   2. Scan start at end of address space and move backward
3. Move **free** to first **gap** where space is available
4. If **scan** finds live object, it is relocated at the **free** pointer
5. After relocating one object, proceed **free** to next **gap**

The Two Finger Algorithm is:
- Memory efficient
- Good cache performance for collector, but bad data locality for mutator
- Easy to implement

Only handles fixed-size objects :(


### Lisp 2 Algorithm
Lisp 2 algorithm aims to improve throughput of mark & compaction collectors. Similar to two finger algorithm, lisp 2 also has free and scan pointers.

- **Phase 1** It traverses the heap, and set `forwardingAddress` field of the object with value of **free** pointer, which is also the target address of this object.
- **Phase 2** Traverse the heap again, and relocate objects based on `forwardingAddress` field.

Lisp 2 Algorithm is:
- easily parallelized, thus high throughput can be achieved.
- But it requires 3 traversals over the heap, which is quite in-efficient
- Space is added to object to store additional field
  - Space in-efficient
  - Invasion!


### Threading compaction
**Destructivity:** The algorithm is destructive if live data is overwritten by relocated objects. Lisp 2 is non-destructive because it tracks target address in object header.

**Threading**: Allow all references to N can be found from N by following thread pointers

1. Thread the node N by chaining referers. Swap one field of N into the Field that holds the reference of N of the last node of the threaded chain temporary.
2. Calculate the new address of N (which is **free**), and update this reference into referers' fields.
3. Actually reallocate objects

This is a smart way by storing N's info in referer's field which referring to N, thus no additional space is required.

Threading algorithm suffers from cache in-efficiency because it needs to follow thread pointers!


### One pass algorithms

- Divide heap into blocks
- Use an offset vector to calculate offset address for each block
- Process each block in parallel and relocate using local address + offset vector



## Limitations of Mark & Compaction Collectors
- Additional space to save reloating-address
- Two-Finger only handles fixed-size objects
- Threaded compaction requires that it is possible to distinguish thread pointers from references