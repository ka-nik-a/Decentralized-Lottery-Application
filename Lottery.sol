// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Lottery
{
    //entities
    address public manager;
    address payable[] public participants; //We have to transfer ethers to participants account

    constructor()
    {
        manager=msg.sender; //global variable
    }

    receive() external payable
    {
        require(msg.value==0.01 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        //below code line will only run if the above require statement is true
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public
    {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        address payable winner;
        uint index=r%participants.length;
        winner=participants[index];
        winner.transfer(getBalance());
        //reset the dynamic array
        participants = new address payable[](0);
    }

}