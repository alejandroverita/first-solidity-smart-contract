// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {

    // enum
    enum StatusProject { Active, Inactive }

    struct Contribution {
        address contributor;
        uint256 value;
    }

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
    Funding[] public funding;
    mapping(string => Contribution[]) public contributions;

    //Eliminamos constructor ya que solo los permite agrega 1 proyecto y ahora queremos agregar N cantidad 
    /* constructor(string memory _id, string memory _name, string memory _description, uint256 _fundGoal){
        funding = Funding(_id, _name, _description, payable(msg.sender), 0, _fundGoal, StatusProject.Active );
        
    } */

    event ProjectCreated(
        string id,
        string name,
        string description,
        uint fundGoal
    );

    //registrar fondos del proyecto. Con 'event' compatimos los datos ala Blockchain
    event ProjectFunded(string id, uint256 value);

    event ProjectStateChanged(string id, StatusProject projectStatus);

    // solo podemos modificar el estado del projecto siendo el propietario
    modifier onlyAuthor(uint256 projectIndex) {
        require(funding[projectIndex].author == msg.sender,
        "Only owner can change state of project"
        );
        _;
    }

    //No podemos recibir fondos propios
    modifier noSelfFunds(uint256 projectIndex) {
        require(
             funding[projectIndex].author != msg.sender,
            "Autofinance is not available"
        );
        _;
    }

    //CreateProject permite recibir los mismos datos que el constructor
    function createProject(string calldata id, string calldata name, string calldata description, uint256 fundGoal )public{
        require (fundGoal > 0, "Fundraising must be greater than 0");
        Funding memory fund = Funding(id, name, description, payable(msg.sender), 0, fundGoal, StatusProject.Active);
        funding.push(fund);
        emit ProjectCreated(id, name, description, fundGoal);

    }

    //caulquier persona la puede ver y se puede enviar ETH sin problemas
    function fundProject(uint256 projectIndex) public payable noSelfFunds (projectIndex) {

        // indice al proyecto que quiera aportar
        Funding memory fund = funding[projectIndex];

        //Project close
        require(fund.projectStatus != StatusProject.Inactive, "Project is already close. No more funds are collected");
        
        //validacion para que no se puedan hacer aportes de 0
        require(msg.value > 0, "No zero funds are allowed");

        fund.author.transfer(msg.value); //transfiere el valor del usuario al autor
        fund.funds += msg.value; //despues lo agrego a los fundos del proyecto para registrar el aporte

        funding[projectIndex] = fund;

        //mapping
        contributions[fund.id].push(Contribution(msg.sender, msg.value));

        emit ProjectFunded(fund.id, msg.value);
    }

    //modifica el estado del proyecto. Calldata ahorra gas, solo existe cuando se le llama a la funcion
    function changeProjectState(StatusProject newState, uint256 projectIndex) public onlyAuthor (projectIndex){
        Funding memory fund = funding[projectIndex];

        require(fund.projectStatus != newState, "Project has already that state");
        fund.projectStatus = newState;

        funding[projectIndex] = fund;
        
        emit ProjectStateChanged(fund.id, newState);
    }

}