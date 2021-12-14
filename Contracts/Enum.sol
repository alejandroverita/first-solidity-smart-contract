// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {

    // enum
    enum StatusProject { Active, Inactive }

    struct Funding {
        string id;
        string name;
        string description;
        address payable author;
        uint funds;
        uint256 fundGoal; //define cuanto espero ganar con la ronda de levantamento de capital
        
        StatusProject projectStatus;
    }

    //Nombres de los tipos en mayusculos, variables en minusculas
    Funding public funding;

    constructor(string memory _id, string memory _name, string memory _description, uint256 _fundGoal){
        funding = Funding(_id, _name, _description, payable(msg.sender), 0, _fundGoal, StatusProject.Active );
        
    }

    //registrar fondos del proyecto. Con 'event' compatimos los datos ala Blockchain
    event ProjectFunded(string projectId, uint256 value);

    event ProjectStateChanged(string id, StatusProject projectStatus);

    // solo podemos modificar el estado del projecto siendo el propietario
    modifier onlyAuthor() {
        require(funding.author == msg.sender ,
        "Only owner can change state of project"
        );
        _;
    }

    //No podemos recibir fondos propios
    modifier noSelfFunds() {
        require(
             funding.author != msg.sender,
            "Autofinance is not available"
        );
        _;
    }


    //caulquier persona la puede ver y se puede enviar ETH sin problemas
    function fundProject() public payable noSelfFunds {

        //Project close
        require(funding.projectStatus != StatusProject.Inactive, "Project is already close. No more funds are collected");
        
        //validacion para que no se puedan hacer aportes de 0
        require(msg.value > 0, "No zero funds are allowed");

        funding.author.transfer(msg.value); //transfiere el valor del usuario al autor
        funding.funds += msg.value; //despues lo agrego a los fundos del proyecto para registrar el aporte

        emit ProjectFunded(funding.id, msg.value);
    }

    //modifica el estado del proyecto. Calldata ahorra gas, solo existe cuando se le llama a la funcion
    function changeProjectState(StatusProject newState) public onlyAuthor{
        require(funding.projectStatus != newState, "Project has already that state");
        funding.projectStatus = newState;
        emit ProjectStateChanged(funding.id, newState);
    }

}