// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StarGame {
    uint public totalStars = 10;
    uint public playFee = 0.01 ether;

    // Stores the randomly arranged prizes
    string[10] public starRewards;

    // Tracks whether each star has been picked
    mapping(uint => bool) public isStarPicked;

    // Tracks whether the first prize has been claimed
    bool public isFirstPrizeClaimed;

    // Events for star selection and prize checking
    event StarPicked(address indexed player, uint star, string reward);
    
    constructor() {
        // Initializes the prize order in the array
        starRewards = ["Reward 1", "Reward 2", "Reward 3", "Reward 4", "Reward 5", 
                       "Reward 6", "Reward 7", "Reward 8", "Reward 9", "Reward 10"];
        
        // Shuffles the prizes in the starRewards array
        shuffleRewards();
    }

    // Function to randomly shuffle prizes in the stars
    function shuffleRewards() internal {
        for (uint i = 0; i < starRewards.length; i++) {
            uint randIndex = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, i))) % starRewards.length;
            string memory temp = starRewards[i];
            starRewards[i] = starRewards[randIndex];
            starRewards[randIndex] = temp;
        }
    }

    // Function for picking a star
    function pickStar(uint star) public payable {
        require(msg.value >= playFee, "Not enough Ether to play.");
        require(star > 0 && star <= totalStars, "Invalid star number.");
        require(!isStarPicked[star], "Star already picked.");

        // Successfully picks a star
        isStarPicked[star] = true;
        string memory reward = starRewards[star - 1];

        // Checks if the first prize was selected
        if (keccak256(abi.encodePacked(reward)) == keccak256(abi.encodePacked("Reward 1"))) {
            isFirstPrizeClaimed = true;
        }

        // Triggers event to show results
        emit StarPicked(msg.sender, star, reward);
    }

    // Function to check the status of the first prize
    function checkFirstPrizeStatus() public view returns (bool) {
        return isFirstPrizeClaimed;
    }

    // Function to reveal the prize of a picked star
    function revealReward(uint star) public view returns (string memory) {
        require(star > 0 && star <= totalStars, "Invalid star number.");
        require(isStarPicked[star], "Star not yet picked.");

        return starRewards[star - 1];
    }

    // Function to withdraw funds from the contract
    function withdrawFunds() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
