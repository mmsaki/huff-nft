// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract TheMoneyBoys is ERC721, Ownable {
    uint constant maxSupply = 10000;
    uint public totalSupply = 0;
    uint public mintPrice = 0.002 ether;

    // Mapping to store SVG for each token
    mapping(uint => string) public tokenIdToSvg;

    // Events
    event Minted(uint indexed tokenId);

    constructor() ERC721("The Money Boys", "MB") {}

    // 8. Return hustle status e.g balance
    function hustle(uint index) internal view returns (string memory) {}

    // 9. Final SVG code for the NFT
    function generateFinalSvg(
        uint randomSeed1,
        uint randomSeed2,
        uint randomSeed3,
        uint randomSeed4,
        uint randomSeed5,
        uint randomSeed6,
        uint randomSeed7
    ) public pure returns (string memory) {
        // SVG opening and closing tags, background color + 3 lines generated
        string memory finalSvg = string(
            abi.encodePacked(
                "<svg width='64' height='64' viewBox='-8 -16 64 64' xmlns='http://www.w3.org/2000/svg'>",
                face(randomSeed1),
                tattoo(randomSeed2),
                beard(randomSeed3),
                chain(randomSeed4),
                studs(randomSeed5),
                smoke(randomSeed6),
                hair(randomSeed7),
                "</svg>"
            )
        );

        // console2.log("Final Svg: ", string(finalSvg));
        return finalSvg;
    }

    //
    // a. Generate token URI will all the SVG code, to be stored on-chain
    function tokenURI(
        uint tokenId
    ) public view override returns (string memory) {
        require(_exists(tokenId));

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "The Money Boys #',
                                uint2str(tokenId),
                                '", "description": "Money boys, money racks, money stacks. Fully on-chain, randomly generated, art boys", "attributes": "", "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(tokenIdToSvg[tokenId])),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    // b. Mint you bro
    function mint(uint tokenId) public payable {
        // Require token ID to be between 1 and maxSupply (10,000)
        require(tokenId > 0 && tokenId <= maxSupply, "Token ID invalid");

        // Make sure the amount of ETH is equal or larger than the minimum mint price
        require(msg.value >= mintPrice, "Not enough ETH sent");

        uint randomSeed1 = uint(
            keccak256(abi.encodePacked(block.basefee, block.timestamp))
        ) % 3;
        uint randomSeed2 = uint(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        ) % 4;
        uint randomSeed3 = uint(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 4;
        uint randomSeed4 = uint(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 3;
        uint randomSeed5 = uint(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 4;
        uint randomSeed6 = uint(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 3;
        uint randomSeed7 = uint(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 22;

        tokenIdToSvg[tokenId] = generateFinalSvg(
            randomSeed1,
            randomSeed2,
            randomSeed3,
            randomSeed4,
            randomSeed5,
            randomSeed6,
            randomSeed7
        );

        // Mint token
        _mint(msg.sender, tokenId);

        // Increase minted tokens counter
        ++totalSupply;

        emit Minted(tokenId);
    }

    // c. Withdraw
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    // From: https://stackoverflow.com/a/65707309/11969592
    function uint2str(
        uint _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // functions

    // 1 face
    function face(uint index) internal pure returns (string memory) {
        string[3] memory faceType = [
            // 1.1 brownskin
            "<path d='M28 11H14M30 13H28M14 13H10M32 15H30M12 15H10M32 17H30M12 17H8M34 19H32M10 19H8M34 21H30M10 21H8M36 23H34M30 23H28M18 23H16M10 23H8M38 25H36M16 25H14M10 25H8M38 27H36M16 27H14M10 27H8M36 29H34M16 29H14M10 29H8M36 31H34M18 31H16M10 31H8M34 33H32M20 33H18M10 33H8M36 35H34M10 35H8M34 37H32M10 37H8M34 39H32M10 39H8M34 41H24M10 41H8M26 43H24M10 43H8M26 45H24M10 45H8M26 47H24M10 47H8' stroke='#000' stroke-width='2'/><path d='M28 13H14M30 15H24M22 15H12M30 17H26M24 17H12M32 19H10M26 21H10M34 23H30M26 23H18M16 23H10M36 25H32M28 25H16M14 25H10M36 27H16M14 27H10M32 29H16M14 29H10M34 31H20M14 31H10M30 33H20M18 33H10M34 35H10M32 37H10M32 39H24M20 39H10M24 41H10M24 43H10M24 45H10M24 47H10M24 39H20' stroke='#DBB180' stroke-width='2'/><path d='M24 15H22M26 17H24' stroke='#E7CBA9' stroke-width='2'/><path d='M30 21H26' stroke='#86581E' stroke-width='2'/><path d='M28 23H26M30 25H28M20 31H18M16 31H14M32 33H30' stroke='#A66E2C' stroke-width='2'/><path d='M32 25H30M34 29H32' stroke='#A77C47' stroke-width='2'/>",
            // 1.2 darkskin
            "<path d='M28 11H14M30 13H28M14 13H10M32 15H30M12 15H10M32 17H30M12 17H8M34 19H32M10 19H8M34 21H30M10 21H8M36 23H34M30 23H28M18 23H16M10 23H8M38 25H36M16 25H14M10 25H8M38 27H36M16 27H14M10 27H8M36 29H34M16 29H14M10 29H8M36 31H34M18 31H16M10 31H8M34 33H32M20 33H18M10 33H8M36 35H34M10 35H8M34 37H32M10 37H8M34 39H32M10 39H8M34 41H24M10 41H8M26 43H24M10 43H8M26 45H24M10 45H8M26 47H24M10 47H8' stroke='#000' stroke-width='2'/><path d='M28 13H14M30 15H26M24 15H12M30 17H28M26 17H12M32 19H10M26 21H10M34 23H30M26 23H18M16 23H10M36 25H32M28 25H16M14 25H10M36 27H32M30 27H16M14 27H10M32 29H16M14 29H10M34 31H20M14 31H10M30 33H20M18 33H10M34 35H10M32 37H10M32 39H24M20 39H10M24 41H10M24 43H10M24 45H10M24 47H10' stroke='#713F1D' stroke-width='2'/><path d='M26 15H24M28 17H26' stroke='#8B532C' stroke-width='2'/><path d='M30 21H26M32 25H30M34 29H32M24 39H20' stroke='#552F16' stroke-width='2'/><path d='M28 23H26M30 25H28M32 27H30M20 31H18M16 31H14M32 33H30' stroke='#562600' stroke-width='2'/>",
            // 1.3 white
            "<path d='M28 11H14M30 13H28M14 13H10M32 15H30M12 15H10M32 17H30M12 17H8M34 19H32M10 19H8M34 21H26M10 21H8M36 23H34M30 23H28M18 23H16M10 23H8M38 25H36M16 25H14M10 25H8M38 27H36M16 27H14M10 27H8M36 29H34M16 29H14M10 29H8M36 31H34M18 31H16M10 31H8M34 33H32M20 33H18M10 33H8M36 35H34M10 35H8M34 37H32M10 37H8M34 39H32M10 39H8M34 41H24M10 41H8M26 43H24M10 43H8M26 45H24M10 45H8M26 47H24M10 47H8' stroke='#000' stroke-width='2'/><path d='M26 15H22M28 17H26' stroke='#fff' stroke-width='2'/><path d='M28 13H14M30 15H26M22 15H12M30 17H28M26 17H12M32 19H10M26 21H10M34 23H30M26 23H18M16 23H10M36 25H32M28 25H16M14 25H10M36 27H16M14 27H10M32 29H16M14 29H10M34 31H20M14 31H10M30 33H20M18 33H10M34 35H10M32 37H10M32 39H24M20 39H10M24 41H10M24 43H10M24 45H10M24 47H10M24 39H20' stroke='#EDD' stroke-width='2'/><path d='M28 23H26M32 25H28' stroke='#CBB' stroke-width='2'/><path d='M34 29H32M20 31H18M16 31H14M32 33H30' stroke='#A88' stroke-width='2'/>"
        ];

        return faceType[index];
    }

    // 2 tattoo
    function tattoo(uint index) internal pure returns (string memory) {
        string[4] memory tattooType = [
            // 2.1 birthmark
            "<path d='M26 29H22M28 31H22M28 33H24' stroke='#222' stroke-width='2'/>",
            // 2.2 cross
            "<path d='M26 23H24M28 25H22M26 27H24M26 29H24M30 35H28M30 37H28' stroke='#222' stroke-width='2'/>",
            // 2.3 neck
            "<path d='M20 35H10M24 37H10M24 39H10M24 41H20M14 41H10M24 43H18M16 43H10M24 45H18M16 45H10M24 47H10' stroke='#222' stroke-width='2'/>",
            ""
        ];

        return tattooType[index];
    }

    // 3 beard
    function beard(uint256 index) internal pure returns (string memory) {
        string[4] memory beardType = [
            // 3.1 goattee
            "<path d='M36 39H30M36 41H30' stroke='#000' stroke-width='2'/>",
            // 3.2 bleached
            "<path d='M24 29H22M20 29H18M34 31H30M26 31H20M30 33H20M34 35H22M32 37H22M32 39H24' stroke='#A62' stroke-width='2'/>",
            // 3.3 philly
            "<path d='M36 31H28M26 31H22M32 33H28M26 33H22M36 35H22M38 37H22M38 39H22M38 41H22M38 43H24M34 45H24' stroke='#000' stroke-width='2'/>",
            ""
        ];
        return beardType[index];
    }

    // 4 chain
    function chain(uint index) internal pure returns (string memory) {
        string[3] memory chainType = [
            // 4.1 gold
            "<path d='M16 41H10M18 43H14M20 45H16M24 47H18' stroke='#FB0' stroke-width='2'/>",
            // 4.2 silver
            "<path d='M16 41H10M18 43H14M20 45H16M24 47H18' stroke='#DDD' stroke-width='2'/>",
            ""
        ];
        return chainType[index];
    }

    // 5 studs
    function studs(uint index) internal pure returns (string memory) {
        string[4] memory studsType = [
            // 5.1 diamond
            "<path d='M20 31H18' stroke='#CCC' stroke-width='2'/>",
            // 5.2 gold
            "<path d='M20 31H18' stroke='#FB0' stroke-width='2'/>",
            // 5.3 asscher
            "<path d='M22 31H18M22 33H18' stroke='#EEE' stroke-width='2'/>",
            ""
        ];
        return studsType[index];
    }

    // 6 smoke
    function smoke(uint index) internal pure returns (string memory) {
        string[3] memory smokeType = [
            // 6.1 backwood
            "<path d='M44 23H42M44 25H42M44 27H42M44 29H42' stroke='#CCC' stroke-width='2'/><path d='M44 31H34M34 33H32M44 35H34' stroke='#000' stroke-width='2'/><path d='M44 33H42' stroke='#E52' stroke-width='2'/><path d='M42 33H34' stroke='#521' stroke-width='2'/>",
            // 6.2 tobacco
            "<path d='M44 23H42M44 25H42M44 27H42M44 29H42M42 33H34' stroke='#CCC' stroke-width='2'/><path d='M44 31H34M34 33H32M44 35H34' stroke='#000' stroke-width='2'/><path d='M44 33H42' stroke='#E52' stroke-width='2'/>",
            ""
        ];

        return smokeType[index];
    }

    // 7 hair
    function hair(uint index) internal pure returns (string memory) {
        string[22] memory hairType = [
            // 7.1
            "<path d='M28 11H10M32 13H8M32 15H6M34 17H6M34 19H4M36 21H34M32 21H6M36 23H4M38 25H34M32 25H30M28 25H4M36 27H34M32 27H30M28 27H22M20 27H6M28 29H26M20 29H18M16 29H4M18 31H6M4 31H2M16 33H4M16 35H14M12 35H8M6 35H4M16 37H14M10 37H4M6 39H4' stroke='#000' stroke-width='2'/><path d='M36 19H34M34 21H32M34 25H32M40 27H36M34 27H32M22 27H20M4 29H3M36 29H34M32 29H30M26 29H24M22 29H20M4 29H2M28 31H26M6 31H4M28 33H26M14 35H12M8 35H6M32 31H30M22 31H20' stroke='#60A' stroke-width='2'/>",
            // 7.2
            "<path d='M28 11H12M30 13H26M24 13H8M32 15H28M26 15H6M32 17H8M36 19H6M36 21H6M36 23H32M30 23H4M38 25H36M34 25H32M28 25H24M22 25H4M40 27H38M36 27H30M28 27H24M22 27H6M40 29H38M36 29H34M32 29H30M28 29H24M22 29H20M16 29H2M28 31H26M22 31H20M18 31H4M28 33H26M16 33H4M16 35H4M16 37H14M10 37H8M6 37H4M6 39H4' stroke='#290' stroke-width='2'/><path d='M26 13H24M28 15H26' stroke='#5F2' stroke-width='2'/>",
            // 7.3
            "<path d='M28 9H26M24 9H16M14 9H12M30 11H8M32 13H6M34 15H6M34 17H6M34 19H4M36 21H34M32 21H4M36 23H30M28 23H18M16 23H4M38 25H34M32 25H30M28 25H18M16 25H4M36 27H34M32 27H30M28 27H26M24 27H22M20 27H18M16 27H4M28 29H26M24 29H22M16 29H4M16 31H6M4 31H2M16 33H4M16 35H14M12 35H4M16 37H14M10 37H4M6 39H4' stroke='#A74' stroke-width='2'/>",
            // 7.4
            "<path d='M28 9H26M24 9H16M14 9H12M30 11H8M32 13H6M34 15H6M34 17H6M34 19H4M36 21H34M32 21H4M36 23H30M28 23H18M16 23H4M38 25H34M32 25H30M28 25H18M16 25H4M36 27H34M32 27H30M28 27H26M24 27H22M20 27H18M16 27H4M28 29H26M24 29H22M16 29H4M16 31H6M4 31H2M16 33H4M16 35H14M12 35H4M16 37H14M10 37H4M6 39H4' stroke='#000' stroke-width='2'/>",
            // 7.5
            "<path d='M28 11H12M30 13H10M32 15H8M32 17H8M36 19H4M36 21H28M26 21H6M36 23H30M26 23H24M22 23H4M38 25H30M26 25H24M22 25H20M18 25H4M40 27H30M28 27H24M22 27H20M18 27H16M14 27H6M40 29H38M36 29H34M32 29H30M28 29H24M22 29H20M14 29H2M32 31H30M28 31H26M22 31H20M14 31H4M28 33H26M14 33H4M16 35H4M16 37H14M10 37H8M6 37H4M6 39H4' stroke='#E22' stroke-width='2'/>",
            // 7.6
            "<path d='M26 9H14M28 11H10M30 13H8M28 15H8M28 17H6M28 19H6M28 21H4M28 23H4M28 25H4M28 27H4M28 29H4M28 31H26M24 31H4M28 33H26M24 33H4M28 35H26M24 35H22M20 35H4M28 37H26M24 37H22M20 37H14M12 37H4M28 39H26M24 39H22M20 39H14M12 39H4M28 41H26M24 41H4M28 43H4M28 45H22M20 45H4M28 47H16M14 47H4' stroke='#000' stroke-width='2'/>",
            // 7.7
            "<path d='M28 3H8M30 5H6M32 7H4M34 9H4M34 11H4M34 13H4M34 15H32M28 15H0M34 17H0' stroke='#051' stroke-width='2'/><path d='M32 15H28' stroke='#899' stroke-width='2'/><path d='M22 19H2M20 21H2M16 23H2M14 25H4M14 27H10M8 27H2M12 29H10M8 29H2M12 31H10M8 31H4M8 33H6' stroke='#000' stroke-width='2'/>",
            // 7.8
            "<path d='M28 3H8M30 5H6M32 7H4M34 9H4M34 11H4M34 13H4M34 15H32M28 15H0M34 17H0' stroke='#109' stroke-width='2'/><path d='M32 15H28' stroke='#A7A5BC' stroke-width='2'/><path d='M22 19H2M20 21H2M16 23H2M14 25H4M14 27H10M8 27H2M12 29H10M8 29H2M12 31H10M8 31H4M8 33H6' stroke='#000' stroke-width='2'/>",
            // 7.9
            "<path d='M28 3H8M30 5H6M32 7H4M34 9H4M34 11H16M14 11H12M10 11H4M34 13H18M16 13H14M12 13H10M8 13H4M34 15H32M28 15H18M16 15H14M12 15H10M8 15H0M34 17H0' stroke='#051' stroke-width='2'/><path d='M16 11H14M12 11H10M18 13H16M14 13H12M10 13H8M18 15H16M14 15H12M10 15H8' stroke='#FE0' stroke-width='2'/><path d='M32 15H28' stroke='#899' stroke-width='2'/><path d='M22 19H2M20 21H2M16 23H2M14 25H4M14 27H10M8 27H2M12 29H10M8 29H2M12 31H10M8 31H4M8 33H6' stroke='#000' stroke-width='2'/>",
            // 7.10
            "<path d='M28 3H10M30 5H8M32 7H6M34 9H6M34 11H6M34 13H6M34 15H32M28 15H4M34 17H0M22 19H0M20 21H6M14 23H6M12 25H6M12 27H10M8 27H6M12 29H10' stroke='#000' stroke-width='2'/><path d='M32 15H28' stroke='#899' stroke-width='2'/>",
            // 7.11
            "<path d='M28 3H10M30 5H8M32 7H6M34 9H6M34 11H6M34 13H18M10 13H6M34 15H32M28 15H18M10 15H4M34 17H0M22 19H0M20 21H6M14 23H6M12 25H6M12 27H10M8 27H6M12 29H10' stroke='#000' stroke-width='2'/><path d='M18 13H16M18 15H16' stroke='#0FA' stroke-width='2'/><path d='M16 13H14M16 15H14' stroke='#0E4EFF' stroke-width='2'/><path d='M14 13H10M14 15H10' stroke='#90F' stroke-width='2'/><path d='M32 15H28' stroke='#899' stroke-width='2'/>",
            // 7.12
            "<path d='M28 3H8M30 5H6M32 7H4M34 9H4M34 11H4M34 13H16M10 13H4M34 15H32M28 15H16M10 15H0M34 17H0' stroke='#109' stroke-width='2'/><path d='M16 13H10' stroke='#4A9' stroke-width='2'/><path d='M32 15H28' stroke='#AAB' stroke-width='2'/><path d='M16 15H10' stroke='#A44' stroke-width='2'/><path d='M22 19H2M20 21H2M16 23H2M14 25H4M14 27H10M8 27H2M12 29H10M8 29H2M12 31H10M8 31H4M8 33H6' stroke='#000' stroke-width='2'/>",
            // 7.13
            "<path d='M28 3H8M30 5H6M32 7H4M34 9H18M16 9H14M12 9H4M34 11H4M34 13H18M16 13H14M12 13H4M34 15H32M28 15H0M34 17H0' stroke='#FA0' stroke-width='2'/><path d='M18 9H16M14 9H12M18 13H16M14 13H12' stroke='#622' stroke-width='2'/><path d='M32 15H28' stroke='#899' stroke-width='2'/><path d='M22 19H2M20 21H2M16 23H2M14 25H4M14 27H10M8 27H2M12 29H10M8 29H2M12 31H10M8 31H4M8 33H6' stroke='#000' stroke-width='2'/>",
            // 7.14
            "<path d='M28 3H10M30 5H8M32 7H6M34 9H6M34 11H6M34 13H22M10 13H6M34 15H32M28 15H22M10 15H4M34 17H0' stroke='#D01612' stroke-width='2'></path><path d='M22 13H18M22 15H18' stroke='#D80' stroke-width='2'></path><path d='M18 13H14M18 15H14' stroke='#DD0' stroke-width='2'></path><path d='M14 13H10M14 15H10' stroke='#1D960D' stroke-width='2'></path><path d='M32 15H28' stroke='#C9D7CF' stroke-width='2'></path><path d='M22 19H0M20 21H6M14 23H6M12 25H6M12 27H10M8 27H6M12 29H10' stroke='#000' stroke-width='2'></path>",
            // 7.15
            "<path d='M28 11H12M20 13H14M12 13H10M20 15H12M10 15H8M22 17H8M20 19H8M16 21H8M14 23H8M12 25H8' stroke='#A62' stroke-width='2'/><path d='M14 13H12M12 15H10' stroke='#B83' stroke-width='2'/>",
            // 7.16
            "<path d='M28 11H12M30 13H10M32 15H8M32 17H8M32 19H30M28 19H4M32 21H30M28 21H26M24 21H20M18 21H6M34 23H32M28 23H26M24 23H22M20 23H16M14 23H12M10 23H4M26 25H24M22 25H20M18 25H14M12 25H10M8 25H6M26 27H24M16 27H14M20 29H18M16 29H14M16 31H14' stroke='#000' stroke-width='2'/>",
            // 7.17
            "<path d='M28 11H12M30 13H10M32 15H8M28 17H8M26 19H4M26 21H6M22 23H18M16 23H4M22 25H20M14 25H4M14 27H6M14 29H4M14 31H6M10 33H6' stroke='#A62' stroke-width='2'/>",
            // 7.18
            "<path d='M24 1H20M40 3H36M26 3H24M20 3H18M12 3H8M40 5H38M36 5H32M28 5H26M18 5H16M14 5H12M10 5H8M38 7H36M32 7H26M16 7H14M10 7H8M38 9H36M10 9H8M38 11H36M10 11H8M36 13H34M10 13H8M36 15H34M10 15H8M36 17H8' stroke='#000' stroke-width='2'/><path d='M24 3H22M38 5H36M26 5H24M36 7H34M26 7H24M36 9H34M36 11H34M34 13H32M34 15H32' stroke='#BC4' stroke-width='2'/><path d='M22 3H20M24 5H18M12 5H10M34 7H32M24 7H16M14 7H10M34 9H10M34 11H32M28 11H24M20 11H16M12 11H10M28 13H24M20 13H16M12 13H10M32 15H10' stroke='#FD1' stroke-width='2'/><path d='M32 11H28 M32 13H28' stroke='#D66' stroke-width='2'/><path d='M24 11H20 M24 13H20' stroke='#2A2' stroke-width='2'/><path d='M16 11H12 M16 13H12' stroke='#9DE' stroke-width='2'/>",
            // 7.19
            "<path d='M30 7H12M32 9H30M12 9H8M34 11H32M10 11H8M34 13H32M10 13H8M36 15H32M10 15H6M36 17H34M8 17H6M36 19H34M8 19H6M14 21H12M8 21H4M12 23H10M4 23H2M8 25H6M4 25H2M8 27H4M10 29H8' stroke='#000' stroke-width='2'/><path d='M30 9H28M26 9H24M22 9H20M18 9H16M14 9H12M32 11H30M24 11H22M20 11H18M16 11H14M12 11H10M30 13H28M26 13H24M22 13H20M18 13H16M24 15H22M20 15H18M34 17H32M30 17H28M26 17H24M22 17H20M18 17H16M14 17H12M10 17H8M32 19H30M28 19H26M24 19H22M20 19H18M16 19H14M12 19H10M10 21H8M6 23H4' stroke='#D11' stroke-width='2'/><path d='M28 9H26M24 9H22M20 9H18M16 9H14M26 11H24M22 11H20M18 11H16M14 11H12M32 13H30M28 13H26M24 13H22M20 13H18M16 13H14M12 13H10M32 17H30M28 17H26M24 17H22M20 17H18M16 17H14M12 17H10M34 19H32M30 19H28M26 19H24M22 19H20M18 19H16M14 19H12M10 19H8M12 21H10M8 23H6M6 25H4' stroke='#E50' stroke-width='2'/><path d='M30 11H28' stroke='#FA6' stroke-width='2'/><path d='M28 11H26' stroke='#F83' stroke-width='2'/><path d='M14 13H12M28 15H26' stroke='#F00' stroke-width='2'/><path d='M32 15H30M16 15H14M12 15H10' stroke='#C00' stroke-width='2'/><path d='M30 15H28' stroke='#D50' stroke-width='2'/><path d='M26 15H24M22 15H20M18 15H16M14 15H12' stroke='#B40' stroke-width='2'/>",
            // 7.20
            "<path d='M34 7H12M36 9H32M14 9H8M38 11H36M34 11H32M10 11H8M38 13H36M34 13H32M10 13H8M36 15H32M30 15H28M26 15H24M22 15H20M18 15H16M14 15H12M10 15H8M44 17H34M32 17H30M28 17H26M24 17H22M20 17H18M16 17H14M12 17H10M42 19H34' stroke='#000' stroke-width='2'/><path d='M32 9H14M32 11H10M32 13H10' stroke='#234' stroke-width='2'/><path d='M36 11H34M36 13H34' stroke='#FD0' stroke-width='2'/><path d='M32 15H30M28 15H26M24 15H22M20 15H18M16 15H14M12 15H10' stroke='#DDD' stroke-width='2'/><path d='M34 17H32M30 17H28M26 17H24M22 17H20M18 17H16M14 17H12M10 17H8' stroke='#fff' stroke-width='2'/>",
            // 7.21
            "<path d='M28 11H22M18 11H12M30 13H22M18 13H10M32 15H22M18 15H8' stroke='#70C' stroke-width='2'/><path d='M22 11H18M22 13H18M22 15H18M22 17H18' stroke='#C7F' stroke-width='2'/><path d='M32 17H22M18 17H8M24 19H20M24 21H20M22 23H20M22 25H20' stroke='#60A' stroke-width='2'/>",
            ""
        ];
        return hairType[index];
    }
}