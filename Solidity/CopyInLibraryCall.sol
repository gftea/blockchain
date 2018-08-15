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

    // function parameters allocated on "memory" by default
    function test() public {
        uint256[2] memory localMemoryVariable;
        uint256[2] storage localStorageVariable;
        
        localMemoryVariable[0] = 1;
        localStorageVariable[0] = 9;
        // For internal library call, always copy by reference within same type
        callee.internalCall(localMemoryVariable, localStorageVariable);
        assert(localMemoryVariable[0] == 1111);
        assert(localStorageVariable[0] == 2222);

        localMemoryVariable[0] = 1;
        localStorageVariable[0] = 9;
        // For public library call
        // copy by reference only for same storage type
        callee.publicCall(localMemoryVariable, localStorageVariable);
        assert(localMemoryVariable[0] == 1);
        assert(localStorageVariable[0] == 9999);
    }
}
