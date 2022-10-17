import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";

async function main() {
  const whiteList: string[] = [
    "0x001D848434ef45Eb236d8EfA86edeb8232b6E6aD",
    "0x00AcF792f4FA7DE9bA9E6fF4771c31E50D05e5DF",
    "0x013eD8216940d70727Bf9A1c8B5CB0F51ed3Ae26",
    "0x01679bd0cda6ed40A7927dA038Ac7B0dFad32Df2",
    "0x01C09635357C1C42d124F8FaC72f564235D034B7",
    "0x01e74CC9AaeaA874c3a3Db24FA89b43512739f7e",
    "0x023bB83563931295591092144805678C0EABB737",
    "0x0241708e986f9d4dCC3292942Ed744b45D4c72F3",
    "0x0248122190f2E032EC0361e4c87209152E2538Cd",
    "0x026E25AF4FD2EBe19D2078C8875343Aa5b5d6454",
    "0x028A8B6a265F9Cd00De045c7F96c3526Befe5a06",
    "0x02F7db889411eC2AAb2D73F324e2B840BeB2ec1A",
    "0x030824b3cb21F33aa22E5c57d875FF7850e194a0",
    "0x038062022f252443eaDcf62450Eb164309777D99",
    "0x038FC58b02992A2D1974eB0a041B43F705dE9d41",
    "0x0474979707B02004E16095ad9F30a61945EbC6CF",
  ];
  const leafNodes = whiteList.map((item) => keccak256(item));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
  const rootHash = merkleTree.getHexRoot();
  console.log("rootHash", rootHash);
  console.log(merkleTree.toString());
  const first = keccak256("0x001D848434ef45Eb236d8EfA86edeb8232b6E6aD");
  const proof = merkleTree.getHexProof(first);
  console.log(proof);
  const verified = merkleTree.verify(proof, first, rootHash);
  console.log("verified", verified);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
