/**
 *Submitted for verification at testnet.bscscan.com on 2024-03-18
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CryptoGadoDonate {
    address owner;
    uint public totalDonation;
    
    struct Donator {
        uint amount;
        address sender;
    }

    Donator[] public lead;

    constructor(address _ownerAddress) {
        owner = _ownerAddress;
    }

    function donate() external payable {
        require(msg.value >= 0.00001 ether, "Minimum donation amount not met");
        totalDonation += msg.value;
        
        bool isExistingDonator = false;
        for(uint i = 0; i < lead.length; ++i){
            if(lead[i].sender == msg.sender){
                lead[i].amount += msg.value;
                isExistingDonator = true;
                break;
            }
        }

        if (!isExistingDonator) {
            lead.push(Donator({
                amount: msg.value,
                sender: msg.sender
            }));
        }
    }

    function withdraw() external onlyOwner {
        uint amount = address(this).balance;
        (bool success,) = owner.call{value: amount}("");
        require(success == true, "Failed to withdraw");
    }

    function getCurrentLeader() external view returns (address[] memory, uint256[] memory) {
        address[] memory addresses = new address[](lead.length);
        uint256[] memory amounts = new uint256[](lead.length);

        for (uint256 i = 0; i < lead.length; i++) {
            addresses[i] = lead[i].sender;
            amounts[i] = lead[i].amount;
        }

        for (uint256 i = 0; i < lead.length - 1; i++) {
            for (uint256 j = i + 1; j < lead.length; j++) {
                if (amounts[i] < amounts[j]) {
                    address tempAddress = addresses[i];
                    uint256 tempAmount = amounts[i];

                    addresses[i] = addresses[j];
                    amounts[i] = amounts[j];

                    addresses[j] = tempAddress;
                    amounts[j] = tempAmount;
                }
            }
        }

        return (addresses, amounts);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
}