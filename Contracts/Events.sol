// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    string public id;
    string public name;
    string public description;
    address payable public author;
    // string public projectState = "Open"; //por defecto abierto a recibir aporte
    uint public funds;
    uint256 public fundGoal; //define cuanto espero ganar con la ronda de levantamento de capital
    
    uint public projectStatus;

    constructor(string memory _id, string memory _name, string memory _description, uint256 _fundGoal){
        id = _id;
        name = _name;
        description = _description;
        fundGoal = _fundGoal;
        // Owner Information
        author = payable(msg.sender); //msg.sender por defecto no recibe ETH pero la convertimos a 'payable'
        
        // Status 0 = "Close"
        // Status 1 = "Open"
        // projectStatus = 1;
    }

    //registrar fondos del proyecto. Con 'event' compatimos los datos ala Blockchain
    event ProjectFunded(string projectId, uint256 value);

    event ProjectStateChanged(string id, uint state);

    // solo podemos modificar el estado del projecto siendo el propietario
    modifier onlyAuthor() {
        require(author == msg.sender ,
        "Only owner can change state of project"
        );
        _;
    }

    modifier noSelfFunds() {
        require(
             author != msg.sender,
            "Autofinance is not available"
        );
        _;
    }


    //caulquier persona la puede ver y se puede enviar ETH sin problemas
    function fundProject() public payable noSelfFunds {

        //Project close
        require(projectStatus != 1, "Project is already close. No more funds are collected");
        
        //validacion para que no se puedan hacer aportes de 0
        require(msg.value > 0, "No zero funds are allowed");

        author.transfer(msg.value); //transfiere el valor del usuario al autor
        funds += msg.value; //despues lo agrego a los fundos del proyecto para registrar el aporte

        emit ProjectFunded(id, msg.value);
    }

    //modifica el estado del proyecto. Calldata ahorra gas, solo existe cuando se le llama a la funcion
    function changeProjectState(uint newState) public onlyAuthor{
        require(projectStatus != newState, "Project has already that state");
        projectStatus = newState;
        emit ProjectStateChanged(id, newState);
    }

}