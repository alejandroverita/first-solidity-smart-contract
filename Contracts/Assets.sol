// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Asset {
    string public tokenName = "CryptoPlatzi";

    //los eventos permiten conectar lo que pasa en la Blockchain con el exterior. Se usa para registrar cambios o dar feedback sobre un proceso

    event ChangeName(address editor, string newName);

    function changeName(string memory newName) public {
        tokenName = newName;

        //se llama a los eventos con 'emit'
        emit ChangeName(msg.sender, newName);
    }
}