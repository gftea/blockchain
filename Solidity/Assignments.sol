pragma solidity ^0.4.24;

contract AssignmentTest {
    // state variables are forced to be allocated on "storage"
    uint256 stateValue;
    
    uint256[2] stateArray;
    uint256[2] stateArray_2;
    
    function test(uint256 inValue, uint256[2] inArray) public {
        
        uint256 localValue; // allocated on stack
        
        /////////////////////////////////////////////////////////
        // copy if local variable to local variable
        localValue = inValue; 
        localValue = 1;
        assert(localValue != inValue);
        // copy if local variable to state variable
        stateValue = localValue; 
        stateValue = 2;
        assert(stateValue != localValue);
        // copy if state variable to local variable
        localValue = stateValue; 
        localValue = 3;
        assert(localValue != stateValue);

        /////////////////////////////////////////////////////////
        // below will not compile because location can only used 
        // on reference type a.k.a struct, array
        //uint256 storage _localV1; 
        //uint256 memory _localV2;
    
        uint256[2] localArrayDefault; // default location is storage
        uint256[2] storage localArrayStorage;
        uint256[2] memory localArrayMemory;

        // copy if local storage variable to local memory
        inArray = localArrayStorage;
        inArray[0] = 99;
        assert(inArray[0] != localArrayStorage[0]);
        // copy if state variable to local memory
        localArrayMemory = stateArray;
        localArrayMemory[0] = 33; 
        assert(localArrayMemory[0] != stateArray[0]);
        //* reference if local memory to local memory
        localArrayMemory = inArray; 
        localArrayMemory[0] = 11; 
        assert(localArrayMemory[0] == inArray[0]);
        
        // copy if local variable to state variable
        stateArray = localArrayStorage;
        stateArray[0] = 4444;
        assert(stateArray[0] != localArrayStorage[0]);
        // copy if local memory to state variable
        stateArray = localArrayMemory; 
        stateArray[0] = 2222;
        assert(stateArray[0] != localArrayMemory[0]);
        // copy if state variable to state variable
        stateArray_2 = stateArray;
        stateArray_2[0] = 6666;
        assert(stateArray_2[0] != stateArray[0]);
        
        // will not compile
        //localArrayStorage = localArrayMemory;         
        //* reference if state variable to local storage variable
        localArrayStorage = stateArray; 
        localArrayStorage[0] = 888;
        assert(localArrayStorage[0] == stateArray[0]);
        //* reference if local storage variable to local storage variable
        localArrayStorage = localArrayDefault; 
        localArrayStorage[0] = 999;
        assert(localArrayStorage[0] == localArrayDefault[0]);   
        
    }
}
