// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProposalContract {
    address owner;
    uint256 private counter;
    address[] private voted_addresses;
    struct Proposal {
        string title;
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 total_vote_to_end;
        bool current_state;
        bool is_active;
    }

    mapping(uint256 => Proposal) proposal_history;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can");
        _;
    }

    modifier isActive() {
        require(
            proposal_history[counter].is_active,
            "The proposal is not active"
        );
        _;
    }
    modifier newVoter(address _address) {
        require(!isVoted(_address), "Address has already voted");
        _;
    }

    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }

    function create(
        string memory _title,
        string calldata _description,
        uint256 _total_vote_to_end
    ) external onlyOwner {
        counter += 1;
        proposal_history[counter] = Proposal(
            _title,
            _description,
            0,
            0,
            0,
            _total_vote_to_end,
            false,
            true
        );
    }

    function setOwner(address new_owner) external onlyOwner {
        owner = new_owner;
    }

    function vote(uint8 choice) external isActive {
        Proposal storage proposal = proposal_history[counter];
        uint256 total_vote = proposal.reject + proposal.approve + proposal.pass;
        if (choice == 1) {
            proposal.approve += 1;
        } else if (choice == 2) {
            proposal.reject += 1;
        } else if (choice == 2) {
            proposal.pass += 1;
        }
        if (choice == 0 || choice == 1 || choice == 2) {
            voted_addresses.push(msg.sender);
            proposal.current_state = calculateCurrentState();
            if (
                (proposal.total_vote_to_end - total_vote == 1) &&
                (choice == 1 || choice == 2 || choice == 0)
            ) {
                proposal.is_active = false;
                voted_addresses = [owner];
            }
        }
    }

    function isVoted(address _address) view private returns (bool) {
        for (uint256 v = 0; v < voted_addresses.length; v++) {
            if (_address == voted_addresses[v]) {
                return true;
            }
        }
        return false;
    }

    function calculateCurrentState() view private returns (bool) {
        Proposal storage proposal = proposal_history[counter];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass = proposal.pass;

        if (proposal.pass % 2 == 1) {
            pass += 1;
        }

        pass = pass / 2;

        if (approve > reject + pass) {
            return true;
        } else {
            return false;
        }
    }
}
