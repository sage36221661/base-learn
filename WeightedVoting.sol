// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Constants
    uint256 public constant maxSupply = 1_000_000;
    uint256 private constant CLAIM_AMOUNT = 100;

    // Errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    // Vote enum
    enum Vote { AGAINST, FOR, ABSTAIN }

    // Issue struct (order matters for testing)
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    // Return struct for getIssue (since we can't return EnumerableSet)
    struct IssueView {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    // State variables
    Issue[] private issues;
    mapping(address => bool) private hasClaimed;

    constructor() ERC20("WeightedVoting", "VOTE") {
        // Initialize the first issue
        issues.push();
        Issue storage zeroIssue = issues[0];
        zeroIssue.issueDesc = "";
        zeroIssue.closed = true;
    }

    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalSupply() + CLAIM_AMOUNT > maxSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        _mint(msg.sender, CLAIM_AMOUNT);
    }

    function createIssue(string calldata _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint256 _id) external view returns (IssueView memory) {
        Issue storage issue = issues[_id];
        
        // Convert EnumerableSet to array for return value
        address[] memory voters = new address[](EnumerableSet.length(issue.voters));
        for (uint256 i = 0; i < voters.length; i++) {
            voters[i] = EnumerableSet.at(issue.voters, i);
        }

        return IssueView({
            voters: voters,
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage issue = issues[_issueId];
        
        if (issue.closed) {
            revert VotingClosed();
        }

        if (EnumerableSet.contains(issue.voters, msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 voterBalance = balanceOf(msg.sender);
        if (voterBalance == 0) {
            revert NoTokensHeld();
        }

        EnumerableSet.add(issue.voters, msg.sender);
        issue.totalVotes += voterBalance;

        if (_vote == Vote.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else {
            issue.votesAbstain += voterBalance;
        }

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            issue.passed = issue.votesFor > issue.votesAgainst;
        }
    }

    function getIssuesLength() external view returns (uint256) {
        return issues.length;
    }
} 