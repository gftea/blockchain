pragma solidity ^0.4.13;

contract AssignmentTest {
    // state variables are always on "storage"
    uint256 stateValue;
    uint256[2] stateArray;
    uint256[2] stateArray_2;
    
    // function arguments always on "memory" 
    function test(uint256 inValue, uint256[2] inArray) public {
        
        /*********************************************
         * value type assignments 
        **********************************************/        
        // below will NOT compile because data location can only used 
        // on reference type a.k.a struct/array
        // uint256 storage _local1; 
        // uint256 memory _local2;
        
        // local variable of value type allocated on "stack"
        uint256 localValue; 
        
        // copy by value between memory and stack
        localValue = inValue; 
        localValue = 1;
        assert(localValue != inValue);
        // copy by value between storage and stack
        stateValue = localValue; 
        stateValue = 2;
        assert(stateValue != localValue);
        // copy by value between storage and memory
        inValue = stateValue; 
        inValue = 3;
        assert(inValue != stateValue);

        /*********************************************
         * reference type assignments 
        **********************************************/
        uint256[2] localArrayDefault; // default data location of local variable of reference type is "storage"
        uint256[2] storage localArrayStorage;
        uint256[2] memory localArrayMemory;

        //// copy by value if assigned to memory from another type.
        // 1. from local-storage varible
        localArrayMemory = localArrayStorage;
        localArrayMemory[0] = 99;
        assert(localArrayMemory[0] != localArrayStorage[0]);
        // 2 from state varible
        localArrayMemory = stateArray;
        localArrayMemory[0] = 33; 
        assert(localArrayMemory[0] != stateArray[0]);
        
        ////*** copy by reference from same type a.k.a memory
        localArrayMemory = inArray; 
        localArrayMemory[0] = 11; 
        assert(localArrayMemory[0] == inArray[0]);
        
        //// copy by value if assigned to state variable no matther from
        //// local-storage, memory or another state variable.
        // 1. from local-storage
        stateArray = localArrayStorage;
        stateArray[0] = 222;
        assert(stateArray[0] != localArrayStorage[0]);
        // 2. from memory
        stateArray = localArrayMemory; 
        stateArray[0] = 444;
        assert(stateArray[0] != localArrayMemory[0]);
        // 3. from another state variable
        stateArray = stateArray_2;
        stateArray[0] = 666;
        assert(stateArray[0] != stateArray_2[0]);
        
        //// will NOT compile if assign to local-storage variable from memory
        // localArrayStorage = localArrayMemory;
        // localArrayStorage = inArray;
        
        ////*** copy by reference if assigning local-storage variable from storage
        // 1. from state variable
        localArrayStorage = stateArray; 
        localArrayStorage[0] = 8888;
        assert(localArrayStorage[0] == stateArray[0]);
        // 2. from another local-storage variable
        localArrayStorage = localArrayDefault; 
        localArrayStorage[0] = 9999;
        assert(localArrayStorage[0] == localArrayDefault[0]);   
    }
}
