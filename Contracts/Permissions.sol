// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Permission {
    address private owner;

    string public projectName = 'Solidity en Platzi';

    constructor(){
        owner = msg.sender;

    }

    //valida que el que ejecuta la funcion es el Owner del contracto 
    modifier onlyOwner() {
        require ( //require: 1er parametro la condicion que va a validad, 2do param mensaje cuando la validacion falla
            msg.sender == owner,
            'Only owner can change project name'
        );
        _; //el guion bajo identificara de donde se insertara el codigo de la funcion 
    }

    function changeProjectName(string memory _projectName) public onlyOwner{
        projectName = _projectName;
    }