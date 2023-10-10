// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TheMoneyBoys is ERC721, Ownable {
    uint constant maxSupply = 10000;
    uint public totalSupply = 0;
    uint public mintPrice = 0.002 ether;
    Grid grid;
    struct Seeds {
        uint seed1;
        uint seed2;
        uint seed3;
        uint seed4;
        uint seed5;
        uint seed6;
        uint seed7;
        uint seed8;
    }

    Seeds public seeds;

    // Mapping to store SVG for each token
    mapping(uint => string) public tokenIdToSvg;

    // Events
    event Minted(uint indexed tokenId);

    constructor() ERC721("The Money Boys", "MB") {
        grid = new Grid();
    }

    // 8. Return hustle status e.g balance
    function hustle(uint index) internal view returns (string memory) {}

    // 9. Final SVG code for the NFT
    function generateFinalSvg(
        uint seed1,
        uint seed2,
        uint seed3,
        uint seed4,
        uint seed5,
        uint seed6,
        uint seed7,
        uint seed8
    ) public view returns (string memory) {
        // SVG opening and closing tags, background color + 3 lines generated
        string memory finalSvg = string(
            abi.encodePacked(
                "<svg width='640' height='640' viewBox='0 0 64 64' xmlns='http://www.w3.org/2000/svg' style='background:#000;' stroke-width='2'>",
                grid.background(seed8),
                grid.grid(),
                face(seed1),
                tattoo(seed2),
                beard(seed3),
                chain(seed4),
                studs(seed5),
                smoke(seed6),
                hair(seed7),
                '<image xmlns="http://www.w3.org/2000/svg" href="https://aquamarine-passing-rhinoceros-611.mypinata.cloud/ipfs/QmfB2AmBZyB8mE2ZKu4QBjPodnQRDnhsmp8QUy51quUfoY/title.svg" x="0" y="0" height="64px" width="64px"/>',
                '<image xmlns="http://www.w3.org/2000/svg" href="https://aquamarine-passing-rhinoceros-611.mypinata.cloud/ipfs/QmfB2AmBZyB8mE2ZKu4QBjPodnQRDnhsmp8QUy51quUfoY/logo.svg" x="0" y="0" height="64px" width="64px"/>',
                // grid.amount(),
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
                                Strings.toString(tokenId),
                                '", "description": "Money boys, money racks, money stacks. Fully on-chain, randomly generated, art boys", "attributes": "", "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(tokenIdToSvg[tokenId])),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    // b. Mint a token
    function mint(uint tokenId) public payable {
        // Require token ID to be between 1 and maxSupply (10,000)
        require(tokenId >= 0 && tokenId < maxSupply, "Token ID invalid");

        // Make sure the amount of ETH is equal or larger than the minimum mint price
        require(msg.value >= mintPrice, "Not enough ETH sent");

        seeds.seed1 =
            uint(keccak256(abi.encodePacked(block.basefee, block.timestamp))) %
            3;
        seeds.seed2 =
            uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) %
            4;
        seeds.seed3 =
            uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) %
            4;
        seeds.seed4 =
            uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) %
            3;
        seeds.seed5 =
            uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) %
            4;
        seeds.seed6 =
            uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) %
            3;
        seeds.seed7 =
            uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) %
            22;
        seeds.seed8 =
            uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) %
            26;

        tokenIdToSvg[tokenId] = generateFinalSvg(
            seeds.seed1,
            seeds.seed2,
            seeds.seed3,
            seeds.seed4,
            seeds.seed5,
            seeds.seed6,
            seeds.seed7,
            seeds.seed8
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

    // functions

    // 1 face
    function face(uint index) internal pure returns (string memory) {
        string[3] memory faceType = [
            // 1.1 brownskin
            '<path d="M36 27H22m16 2h-2m-14 0h-4m22 2h-2m-18 0h-2m22 2h-2m-18 0h-4m26 2h-2m-22 0h-2m26 2h-4m-20 0h-2m28 2h-2m-4 0h-2m-10 0h-2m-6 0h-2m30 2h-2m-20 0h-2m-4 0h-2m30 2h-2m-20 0h-2m-4 0h-2m28 2h-2m-18 0h-2m-4 0h-2m28 2h-2m-16 0h-2m-6 0h-2m26 2h-2m-12 0h-2m-8 0h-2m28 2h-2m-24 0h-2m26 2h-2m-22 0h-2m26 2h-2m-22 0h-2m26 2H32m-14 0h-2m18 2h-2m-14 0h-2m18 2h-2m-14 0h-2m18 2h-2m-14 0h-2" stroke="#000"/><path d="M36 29H22m16 2h-6m-2 0H20m18 2h-4m-2 0H20m20 2H18m16 2H18m24 2h-4m-4 0h-8m-2 0h-6m26 2h-4m-4 0H24m-2 0h-4m26 2H24m-2 0h-4m22 2H24m-2 0h-4m24 2H28m-6 0h-4m20 2H28m-2 0h-8m24 2H18m22 2H18m22 2h-8m-4 0H18m14 2H18m14 2H18m14 2H18m14 2H18m14-8h-4" stroke="#dbb180"/><path d="M32 31h-2m4 2h-2" stroke="#e7cba9"/><path d="M38 37H34" stroke="#86581e"/><path d="M36 39h-2m4 2h-2m-8 6h-2m-2 0h-2m18 2h-2" stroke="#a66e2c"/><path d="M40 41h-2m4 4h-2" stroke="#a77c47"/>',
            // 1.2 darkskin
            '<path d="M36 27H22m16 2h-2m-14 0h-4m22 2h-2m-18 0h-2m22 2h-2m-18 0h-4m26 2h-2m-22 0h-2m26 2h-4m-20 0h-2m28 2h-2m-4 0h-2m-10 0h-2m-6 0h-2m30 2h-2m-20 0h-2m-4 0h-2m30 2h-2m-20 0h-2m-4 0h-2m28 2h-2m-18 0h-2m-4 0h-2m28 2h-2m-16 0h-2m-6 0h-2m26 2h-2m-12 0h-2m-8 0h-2m28 2h-2m-24 0h-2m26 2h-2m-22 0h-2m26 2h-2m-22 0h-2m26 2H32m-14 0h-2m18 2h-2m-14 0h-2m18 2h-2m-14 0h-2m18 2h-2m-14 0h-2" stroke="#000"/><path d="M36 29H22m16 2h-4m-2 0H20m18 2h-2m-2 0H20m20 2H18m16 2H18m24 2h-4m-4 0h-8m-2 0h-6m26 2h-4m-4 0H24m-2 0h-4m26 2h-4m-2 0H24m-2 0h-4m22 2H24m-2 0h-4m24 2H28m-6 0h-4m20 2H28m-2 0h-8m24 2H18m22 2H18m22 2h-8m-4 0H18m14 2H18m14 2H18m14 2H18m14 2H18" stroke="#713f1d"/><path d="M34 31h-2m4 2h-2" stroke="#8b532c"/><path d="M38 37h-4m6 4h-2m4 4h-2m-8 10h-4" stroke="#552f16"/><path d="M36 39h-2m4 2h-2m4 2h-2m-10 4h-2m-2 0h-2m18 2h-2" stroke="#562600"/>',
            // 1.3 white
            '<path d="M36 27H22m16 2h-2m-14 0h-4m22 2h-2m-18 0h-2m22 2h-2m-18 0h-4m26 2h-2m-22 0h-2m26 2h-8m-16 0h-2m28 2h-2m-4 0h-2m-10 0h-2m-6 0h-2m30 2h-2m-20 0h-2m-4 0h-2m30 2h-2m-20 0h-2m-4 0h-2m28 2h-2m-18 0h-2m-4 0h-2m28 2h-2m-16 0h-2m-6 0h-2m26 2h-2m-12 0h-2m-8 0h-2m28 2h-2m-24 0h-2m26 2h-2m-22 0h-2m26 2h-2m-22 0h-2m26 2H32m-14 0h-2m18 2h-2m-14 0h-2m18 2h-2m-14 0h-2m18 2h-2m-14 0h-2" stroke="#000"/><path d="M34 31h-4m6 2h-2" stroke="#fff"/><path d="M36 29H22m16 2h-4m-4 0H20m18 2h-2m-2 0H20m20 2H18m16 2H18m24 2h-4m-4 0h-8m-2 0h-6m26 2h-4m-4 0H24m-2 0h-4m26 2H24m-2 0h-4m22 2H24m-2 0h-4m24 2H28m-6 0h-4m20 2H28m-2 0h-8m24 2H18m22 2H18m22 2h-8m-4 0H18m14 2H18m14 2H18m14 2H18m14 2H18m14-8h-4" stroke="#ead9d9"/><path d="M36 39h-2m6 2h-4" stroke="#c9b2b2"/><path d="M42 45h-2m-12 2h-2m-2 0h-2m18 2h-2" stroke="#a58d8d"/>'
        ];

        return faceType[index];
    }

    // 2 tattoo
    function tattoo(uint index) internal pure returns (string memory) {
        string[4] memory tattooType = [
            // 2.1 birthmark
            '<path d="M34 45h-4m6 2h-6m6 2h-4" stroke="#222" stroke-width="2"/>',
            // 2.2 cross
            '<path d="M34 39h-2m4 2h-6m4 2h-2m2 2h-2m6 6h-2m2 2h-2" stroke="#222" stroke-width="2"/>',
            // 2.3 neck
            '<path d="M28 51H18m14 2H18m14 2H18m14 2h-4m-6 0h-4m14 2h-6m-2 0h-6m14 2h-6m-2 0h-6m14 2H18" stroke="#222" stroke-width="2"/>',
            ""
        ];

        return tattooType[index];
    }

    // 3 beard
    function beard(uint256 index) internal pure returns (string memory) {
        string[4] memory beardType = [
            // 3.1 goattee
            '<path d="M44 55h-6m6 2h-6" stroke="#000" stroke-width="2"/>',
            // 3.2 bleached
            '<path d="M32 45h-2m-2 0h-2m16 2h-4m-4 0h-6m10 2H28m14 2H30m10 2H30m10 2h-8" stroke="#a62" stroke-width="2"/>',
            // 3.3 philly
            '<path d="M44 47h-8m-2 0h-4m10 2h-4m-2 0h-4m14 2H30m16 2H30m16 2H30m16 2H30m16 2H32m10 2H32" stroke="#000" stroke-width="2"/>',
            ""
        ];
        return beardType[index];
    }

    // 4 chain
    function chain(uint index) internal pure returns (string memory) {
        string[3] memory chainType = [
            // 4.1 gold
            '<path d="M24 57h-6m8 2h-4m6 2h-4m8 2h-6" stroke="#fb0" stroke-width="2"/>',
            // 4.2 silver
            '<path d="M24 57h-6m8 2h-4m6 2h-4m8 2h-6" stroke="#ddd" stroke-width="2"/>',
            ""
        ];
        return chainType[index];
    }

    // 5 studs
    function studs(uint index) internal pure returns (string memory) {
        string[4] memory studsType = [
            // 5.1 diamond
            '<path d="M28 47H26" stroke="#ccc" stroke-width="2"/>',
            // 5.2 gold
            '<path d="M28 47H26" stroke="#fb0" stroke-width="2"/>',
            // 5.3 asscher
            '<path d="M30 47h-4m4 2h-4" stroke="#eee" stroke-width="2"/>',
            ""
        ];
        return studsType[index];
    }

    // 6 smoke
    function smoke(uint index) internal pure returns (string memory) {
        string[3] memory smokeType = [
            // 6.1 backwood
            '<path d="M52 39h-2m2 2h-2m2 2h-2m2 2h-2" stroke="#ccc"/><path d="M52 47H42m0 2h-2m12 2H42" stroke="#000"/><path d="M52 49H50" stroke="#e52"/><path d="M50 49H42" stroke="#521"/>',
            // 6.2 tobacco
            '<path d="M52 39h-2m2 2h-2m2 2h-2m2 2h-2m0 4h-8" stroke="#ccc"/><path d="M52 47H42m0 2h-2m12 2H42" stroke="#000"/><path d="M52 49H50" stroke="#e52"/>',
            ""
        ];

        return smokeType[index];
    }

    // 7 hair
    function hair(uint index) internal pure returns (string memory) {
        string[22] memory hairType = [
            // 7.1
            '<path d="M36 19H18m20 2H16m24 2H14m28 2H14m28 2H14m28 2H30m-12 0h-4m28 2h-2m-4 0h-6m-12 0h-6m30 2H8" stroke="#d11"/><path d="M30 29h-4m4 2h-4" stroke="#d80"/><path d="M26 29h-4m4 2h-4" stroke="#dd0"/><path d="M22 29h-4m4 2h-4" stroke="#190"/><path d="M40 31H36" stroke="#cdc"/><path d="M30 35H8m20 2H14m8 2h-8m6 2h-6m6 2h-2m-2 0h-2m6 2h-2" stroke="#000"/>',
            // 7.2
            '<path d="M36 27H20m18 2H18m22 2H16m24 2H16m24 2h-2m-2 0H12m28 2h-2m-2 0h-2m-2 0h-4m-2 0H14m28 2h-2m-4 0h-2m-2 0h-2m-2 0h-4m-2 0h-2m-2 0h-6m22 2h-2m-2 0h-2m-2 0h-4m-2 0h-2m-2 0h-2m20 2h-2m-8 0h-2m6 2h-2m-2 0h-2m2 2h-2" stroke="#000" stroke-width="2"/>',
            // 7.3
            '<path d="M36 27H18m22 2H16m24 2H14m28 2H14m28 2H12m32 2h-2m-2 0H14m30 2H12m34 2h-4m-2 0h-2m-2 0H12m32 2h-2m-2 0h-2m-2 0h-6m-2 0H14m22 2h-2m-6 0h-2m-2 0H12m14 2H14m-2 0h-2m14 2H12m12 2h-2m-2 0h-4m-2 0h-2m12 2h-2m-4 0h-6m2 2h-2" stroke="#000"/><path d="M44 35h-2m0 2h-2m2 4h-2m8 2h-4m-2 0h-2m-10 0h-2m20 2h-2m-2 0h-2m-2 0h-2m-4 0h-2m-2 0h-2m-16 0h-2m26 2h-2m-20 0h-2m24 2h-2m-12 2h-2m-4 0h-2m26-4h-2m-8 0h-2" stroke="#6017ae"/>',
            // 7.4
            '<path d="M36 25h-2m-2 0h-8m-2 0h-2m18 2H16m24 2H14m28 2H14m28 2H14m28 2H12m32 2h-2m-2 0H12m32 2h-6m-2 0H26m-2 0H12m34 2h-4m-2 0h-2m-2 0H26m-2 0H12m32 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0H12m24 2h-2m-2 0h-2m-6 0H12m12 2H14m-2 0h-2m14 2H12m12 2h-2m-2 0h-8m12 2h-2m-4 0h-6m2 2h-2" stroke="#a77c47" stroke-width="2"/>',
            // 7.5
            '<path d="M36 27H20m8 2h-6m-2 0h-2m10 2h-8m-2 0h-2m14 2H16m12 2H16m8 2h-8m6 2h-6m4 2h-4" stroke="#a66e2c"/><path d="M22 29h-2m0 2h-2" stroke="#bd823d"/>',
            // 7.6
            '<path d="M36 27H20m18 2H18m22 2H16m20 2H16m18 2H12m22 2H14m16 2h-4m-2 0H12m18 2h-2m-6 0H12m10 2h-8m8 2H12m10 2h-8m4 2h-4" stroke="#a66e2c" stroke-width="2"/>',
            // 7.7
            '<path d="M36 19H16m22 2H14m26 2H12m30 2H12m30 2H12m30 2H24m-6 0h-6m30 2h-2m-4 0H24m-6 0H8m34 2H8" stroke="#10029c"/><path d="M24 29H18" stroke="#e22"/><path d="M40 31H36" stroke="#a7a5bc"/><path d="M24 31H18" stroke="#094"/><path d="M30 35H10m18 2H10m14 2H10m12 2H12m10 2h-4m-2 0h-6m10 2h-2m-2 0h-6m10 2h-2m-2 0h-4m4 2h-2" stroke="#000"/>',
            // 7.8
            '<path d="M36 19H16m22 2H14m26 2H12m30 2H12m30 2H12m30 2H12m30 2h-2m-4 0H8m34 2H8" stroke="#10029c"/><path d="M40 31H36" stroke="#a7a5bc"/><path d="M30 35H10m18 2H10m14 2H10m12 2H12m10 2h-4m-2 0h-6m10 2h-2m-2 0h-6m10 2h-2m-2 0h-4m4 2h-2" stroke="#000"/>',
            // 7.9
            '<path d="M36 27h-6m-4 0h-6m18 2h-8m-4 0h-8m22 2H30m-4 0H16" stroke="#710cc7"/><path d="M30 27h-4m4 2h-4m4 2h-4m4 2h-4" stroke="#c37dff"/><path d="M40 33H30m-4 0H16m16 2h-4m4 2h-4m2 2h-2m2 2h-2" stroke="#6107ae"/>',
            // 7.10
            '<path d="M36 25h-2m-2 0h-8m-2 0h-2m18 2H16m24 2H14m28 2H14m28 2H14m28 2H12m32 2h-2m-2 0H12m32 2h-6m-2 0H26m-2 0H12m34 2h-4m-2 0h-2m-2 0H26m-2 0H12m32 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0H12m24 2h-2m-2 0h-2m-6 0H12m12 2H14m-2 0h-2m14 2H12m12 2h-2m-2 0h-8m12 2h-2m-4 0h-6m2 2h-2" stroke="#000" stroke-width="2"/>',
            // 7.11
            '<path d="M36 19H16m22 2H14m26 2H12m30 2H12m30 2H24m-2 0h-2m-2 0h-6m30 2H26m-2 0h-2m-2 0h-2m-2 0h-4m30 2h-2m-4 0H26m-2 0h-2m-2 0h-2m-2 0H8m34 2H8" stroke="#025214"/><path d="M24 27h-2m-2 0h-2m8 2h-2m-2 0h-2m-2 0h-2m10 2h-2m-2 0h-2m-2 0h-2" stroke="#ffe70e"/><path d="M40 31H36" stroke="#8e929d"/><path d="M30 35H10m18 2H10m14 2H10m12 2H12m10 2h-4m-2 0h-6m10 2h-2m-2 0h-6m10 2h-2m-2 0h-4m4 2h-2" stroke="#000"/>',
            // 7.12
            '<path d="M30 21h-2m16 2h-2m-10 0h-2m12 2h-2m-8 0h-2m12 2h-2m2 2h-2m0 2h-2m2 2h-2" stroke="#bdcc43"/><path d="M28 21h-2m4 2h-6m-6 0h-2m24 2h-2m-8 0h-8m-2 0h-4m24 2H16m24 2h-2m-8 0h4m-8 0h-4m-4 0h-2m14 2h4m-8 0h-4m-4 0h-2m22 2H16" stroke="#fed212"/><path d="M38 29h-4m4 2h-4" stroke="#dd6060"/><path d="M30 29h-4m4 2h-4" stroke="#299f26"/><path d="M22 29h-4m4 2h-4" stroke="#6ac5e1"/>',
            // 7.13
            '<path d="M36 19H16m22 2H14m26 2H12m30 2H26m-2 0h-2m-2 0h-8m30 2H12m30 2H26m-2 0h-2m-2 0h-8m30 2h-2m-4 0H8m34 2H8" stroke="#f8a704"/><path d="M26 25h-2m-2 0h-2m6 4h-2m-2 0h-2" stroke="#682323"/><path d="M40 31H36" stroke="#8e929d"/><path d="M30 35H10m18 2H10m14 2H10m12 2H12m10 2h-4m-2 0h-6m10 2h-2m-2 0h-6m10 2h-2m-2 0h-4m4 2h-2" stroke="#000"/>',
            // 7.14
            '<path d="M36 27H20m18 2h-4m-2 0H16m24 2h-4m-2 0H14m26 2H16m28 2H14m30 2H14m30 2h-4m-2 0H12m34 2h-2m-2 0h-2m-4 0h-4m-2 0H12m36 2h-2m-2 0h-6m-2 0h-4m-2 0H14m34 2h-2m-2 0h-2m-2 0h-2m-2 0h-4m-2 0h-2m-4 0H10m26 2h-2m-4 0h-2m-2 0H12m24 2h-2m-10 0H12m12 2H12m12 2h-2m-4 0h-2m-2 0h-2m2 2h-2" stroke="#229000"/><path d="M34 29h-2m4 2h-2" stroke="#5bfa29"/>',
            // 7.15
            '<path d="M36 19H16m22 2H14m26 2H12m30 2H12m30 2H12m30 2H12m30 2h-2m-4 0H8m34 2H8" stroke="#025214"/><path d="M40 31H36" stroke="#8e929d"/><path d="M30 35H10m18 2H10m14 2H10m12 2H12m10 2h-4m-2 0h-6m10 2h-2m-2 0h-6m10 2h-2m-2 0h-4m4 2h-2" stroke="#000"/>',
            // 7.16
            '<path d="M36 19H18m20 2H16m24 2H14m28 2H14m28 2H14m28 2H26m-8 0h-4m28 2h-2m-4 0H26m-8 0h-6m30 2H8m22 2H8m20 2H14m8 2h-8m6 2h-6m6 2h-2m-2 0h-2m6 2h-2" stroke="#000"/><path d="M26 29h-2m2 2h-2" stroke="#018652"/><path d="M24 29h-2m2 2h-2" stroke="#fff"/><path d="M22 29h-2m2 2h-2" stroke="#018652"/><path d="M20 29h-2m2 2h-2" stroke="#000"/><path d="M40 31H36" stroke="#8e929d"/>',
            // 7.17
            '<path d="M42 23H20m24 2h-4m-18 0h-6m30 2h-2m-2 0h-2m-22 0h-2m30 2h-2m-2 0h-2m-22 0h-2m28 2h-4m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m36 2H42m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m32 2h-8" stroke="#000"/><path d="M40 25H22m18 2H18m22 2H18" stroke="#26314a"/><path d="M44 27h-2m2 2h-2" stroke="#ffd800"/><path d="M40 31h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2" stroke="#dfdfdf"/><path d="M42 33h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2" stroke="#fff"/>',
            // 7.18
            '<path d="M36 27H20m18 2H18m22 2H16m24 2H16m28 2H12m32 2h-8m-2 0H14m30 2h-6m-4 0h-2m-2 0H12m34 2h-8m-4 0h-2m-2 0h-2m-2 0H12m36 2H38m-2 0h-4m-2 0h-2m-2 0h-2m-2 0h-8m34 2h-2m-2 0h-2m-2 0h-2m-2 0h-4m-2 0h-2m-6 0H10m30 2h-2m-2 0h-2m-4 0h-2m-6 0H12m24 2h-2m-12 0H12m12 2H12m12 2h-2m-4 0h-2m-2 0h-2m2 2h-2" stroke="#e22626" stroke-width="2"/>',
            // 7.19
            '<path d="M34 25H22m14 2H18m20 2H16m20 2H16m20 2H14m22 2H14m22 2H12m24 2H12m24 2H12m24 2H12m24 2H12m24 2h-2m-2 0H12m24 2h-2m-2 0H12m24 2h-2m-2 0h-2m-2 0H12m24 2h-2m-2 0h-2m-2 0h-6m-2 0h-8m24 2h-2m-2 0h-2m-2 0h-6m-2 0h-8m24 2h-2m-2 0H12m24 2H12m24 2h-6m-2 0H12m24 2H24m-2 0H12" stroke="#000" stroke-width="2"/>',
            // 7.20
            '<path d="M38 25h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m20 2h-2m-6 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m20 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m8 2h-2m-2 0h-2m16 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m24 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m0 2h-2m-2 2h-2" stroke="#dc1d1d"/><path d="M36 25h-2m-2 0h-2m-2 0h-2m-2 0h-2m12 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m20 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m22 4h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m24 2h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m-2 0h-2m4 2h-2m-2 2h-2m0 2h-2" stroke="#e65700"/><path d="M38 27H36" stroke="#faa069"/><path d="M36 27H34" stroke="#f7833c"/><path d="M22 29h-2m16 2h-2" stroke="#f50208"/><path d="M40 31h-2m-14 0h-2m-2 0h-2" stroke="#c20d0d"/><path d="M38 31H36" stroke="#d25102"/><path d="M34 31h-2m-2 0h-2m-2 0h-2m-2 0h-2" stroke="#b14605"/>',
            // 7.21
            '<path d="M36 19H18m20 2H16m24 2H14m28 2H14m28 2H14m28 2H14m28 2h-2m-4 0H12m30 2H8m22 2H8m20 2H14m8 2h-8m6 2h-6m6 2h-2m-2 0h-2m6 2h-2" stroke="#000"/><path d="M40 31H36" stroke="#8e929d"/>',
            ""
        ];
        return hairType[index];
    }
}

contract Grid {
    function grid() external pure returns (string memory) {
        return
            '<image xmlns="http://www.w3.org/2000/svg" href="https://ipfs.io/ipfs/QmXfoQSzayNdg5z6FCxu1gzPsyTcyXAM4Uqp4hndqVaRtt/grid.svg" x="0" y="0" height="64px" width="64px"/>';
    }

    function str() external pure returns (string memory) {
        return Strings.toString(uint256(10));
    }

    function background(uint index) external pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<image xmlns="http://www.w3.org/2000/svg" href="https://aquamarine-passing-rhinoceros-611.mypinata.cloud/ipfs/QmXuaLY1nCYqipQ8NTm7r3GvjKtGwjBQyNmZr43Xr25XD4/',
                    Strings.toString(index),
                    '.svg" x="0" y="0" height="64px" width="64px"/>'
                )
            );
    }

    function amount() external pure returns (string memory) {
        return
            '<text x="60" y="16" fill="#fff" stroke-width=".05" stroke="#000" style="font:bold 2px sans-serif;" text-anchor="end">$250,000,000</text>';
    }
}
