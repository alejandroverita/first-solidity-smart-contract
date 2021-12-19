// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TokenNoFungible is ERC721("TokenNoFungible","TNF") {
    
    //Funcion mint es la que emite los tokens y pide una direccion y un identificador
    constructor() {

        //tener la precaucion de siempre tener un ID que no se repita, unico
        _mint(msg.sender, 1);
    }
    
}