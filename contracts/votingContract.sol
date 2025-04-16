// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract GasEfficientVoting {
    uint8 public ProposalCount;

    struct Proposal {
        bytes32 name;
        uint32 voteCount;
        uint32 startTime;
        uint32 endTime;
        bool executed;
    }

    mapping(uint8 => Proposal) public proposals;
    mapping(address => uint256) private voterRegistry;
    mapping(uint8 => uint32) public proposalVoterCount;

    event Voted(address indexed voter, uint8 indexed proposedId);
    event ProposalExecuted(uint8 indexed proposalId, uint8 indexed currentTime);
    event ProposalCreated(uint8 indexed proposedId, bytes32 name);

    // ✅ Helper: Convert string to bytes32
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory temp = bytes(source);
        if (temp.length == 0) {
            return 0x0;
        }
        require(temp.length <= 32, "String too long, max 32 characters");
        assembly {
            result := mload(add(source, 32))
        }
    }

    // ✅ Create proposal using bytes32 name
    function createProposal(bytes32 name, uint32 duration) public {
        require(duration > 0, "Duration must be greater than 0");

        uint8 proposalId = ProposalCount;
        ProposalCount++;

        Proposal memory newProposal = Proposal({
            name: name,
            voteCount: 0,
            startTime: uint32(block.timestamp),
            endTime: uint32(block.timestamp) + duration,
            executed: false
        });

        proposals[proposalId] = newProposal;
        emit ProposalCreated(proposalId, name);
    }

    // ✅ Wrapper to create proposal using string (for Remix)
    function createProposalWithString(string memory name, uint32 duration) external {
        bytes32 nameBytes = stringToBytes32(name);
        createProposal(nameBytes, duration);
    }

    function vote(uint8 proposalId) external {
        require(proposalId < ProposalCount, "Invalid proposal");
        uint32 currentTime = uint32(block.timestamp);
        require(currentTime >= proposals[proposalId].startTime, "Voting has not started");
        require(currentTime <= proposals[proposalId].endTime, "Voting has ended");

        uint256 voterData = voterRegistry[msg.sender];
        uint256 mask = 1 << proposalId;

        require((voterData & mask) == 0, "Already voted for this proposal");

        voterRegistry[msg.sender] = voterData | mask;
        proposals[proposalId].voteCount++;
        proposalVoterCount[proposalId]++;

        emit Voted(msg.sender, proposalId);
    }

    function executeProposal(uint8 proposalId, uint8 currentTime) external {
        require(proposalId < ProposalCount, "Invalid proposal");
        require(block.timestamp > proposals[proposalId].endTime, "Voting is still ongoing");
        require(!proposals[proposalId].executed, "Proposal already executed");

        proposals[proposalId].executed = true;
        emit ProposalExecuted(proposalId, currentTime);
    }

    function hasVoted(address voter, uint8 proposalId) external view returns (bool) {
        return (voterRegistry[voter] & (1 << proposalId)) != 0;
    }

    function getProposal(uint8 proposalId) external view returns (
        bytes32 name,
        uint32 voteCount,
        uint32 startTime,
        uint32 endTime,
        bool executed,
        bool active
    ) {
        require(proposalId < ProposalCount, "Invalid proposal");

        Proposal storage proposal = proposals[proposalId];

        return (
            proposal.name,
            proposal.voteCount,
            proposal.startTime,
            proposal.endTime,
            proposal.executed,
            (block.timestamp >= proposal.startTime && block.timestamp <= proposal.endTime)
        );
    }
}
