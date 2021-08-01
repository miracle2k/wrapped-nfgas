//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "hardhat/console.sol";


contract WrappedNFGas is ERC721, IERC721Receiver {

  IERC721 private nfGas;

  constructor(address _nfgasContract) ERC721("Wrapped NFGas", "WNFG")
  {
    nfGas = IERC721(_nfgasContract);
  }

  // Mint a new one when receiving an NFGas
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) public override returns (bytes4) {
    if (msg.sender != address(nfGas)) {
      return "";
    }
    return IERC721Receiver.onERC721Received.selector;
  }

  function burn(uint256 gasIdx)  public
  {
    require(_isApprovedOrOwner(msg.sender, gasIdx), "not owner nor approved");
    _burn(gasIdx);
    nfGas.safeTransferFrom(address(this), msg.sender, gasIdx);
  }
}