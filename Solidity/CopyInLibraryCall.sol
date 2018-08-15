pragma solidity ^0.4.13;

library callee {
    
    function internalCall(uint256[2] memory mm, uint256[2] storage ss) internal {
        mm[0] = 1111;
        ss[0] = 2222;
    }
    
    function publicCall(uint256[2] memory mm, uint256[2] storage ss) public {
        mm[0] = 8888;
        ss[0] = 9999;
    }
}
contract caller {

    uint256[2] stateArray;
    
    // function arguments always on "memory"
    function test() public {
        uint256[2] memory localMemoryVariable;
        uint256[2] storage localStorageVariable;
        
        localMemoryVariable[0] = 0;
        localStorageVariable[0] = 0;
        //// For internal library call, 
        // copy by reference between variables of same data location
        callee.internalCall(localMemoryVariable, localStorageVariable);
        assert(localMemoryVariable[0] == 1111);
        assert(localStorageVariable[0] == 2222);

        
        //// For public library call, 
        //// copy by reference only between variables of "storage" location
        localMemoryVariable[0] = 0;
        localStorageVariable[0] = 0;
        // 1. pass in local variable 
        callee.publicCall(localMemoryVariable, localStorageVariable);
        assert(localMemoryVariable[0] == 0);
        assert(localStorageVariable[0] == 9999);
        // 2. pass in state variable
        stateArray[0] = 0;
        callee.publicCall(localMemoryVariable, stateArray);
        assert(stateArray[0] == 9999);

    }
}
