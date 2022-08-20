// contracts/Blog.sol
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WasteRecord {
    string public name;
    address public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _recordIds;

    struct Record {
        uint256 id;
        string weight;
        string companyID;
        string datetime;
        string content;
    }
    /* here we create lookups for Records by id and record by ipfs hash */
    mapping(uint256 => WasteRecord) private idToRecord;
    mapping(string => WasteRecord) private hashToRecord;

    /* events facilitate communication between smart contractsand their user interfaces  */
    /* i.e. we can create listeners for events in the client and also use them in The Graph  */
    event WasteRecordCreated(uint256 id, string companyID, string hash);

    /* when the blog is deployed, give it a name */
    /* also set the creator as the owner of the contract */
    constructor(string memory _name) {
        name = _name;
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    /* fetches an individual post by the content hash */
    function fetchRecord(string memory hash)
        public
        view
        returns (Record memory)
    {
        return hashToRecord[hash];
    }

    /* creates a new post */
    function createWasteRecord(
        string memory title,
        string memory companyID,
        string memory hash
    ) public onlyOwner {
        _recordIds.increment();
        uint256 recordId = _recordIds.current();

        Record storage record = idToRecord[recordId];

        record.id = recordId;
        record.companyID = companyID;
        record.content = hash;

        hashToRecord[hash] = record;

        emit WasteRecordCreated(recordId, companyID, hash);
    }

    /* fetches all posts */
    function fetchRecords() public view returns (Record[] memory) {
        uint256 itemCount = _recordIds.current();

        Record[] memory records = new Record[](itemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            Record storage currentItem = idToRecord[currentId];
            records[i] = currentItem;
        }
        return records;
    }

    /* this modifier means only the contract owner can */
    /* invoke the function */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
