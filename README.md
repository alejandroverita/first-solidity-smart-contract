### ¿Qué son las funciones en Solidity?

Las funciones son secciones de un programa que se encargar de ejecutar instrucciones de forma independiente. Estas pueden recibir parametros para usarlos dentro del código y pueden retornar una o más varibales. (Conocido como input y output)

Tienen visibilidad al igual que las variables de estado, pueden ser.

- Public::Totalmente accesible, sea cual sea el origen.
- Private: Accesible únicamente a través de una función incluida en el mismo contrato.
- Internal: Accesible únicamente a través de otra función incluida en el mismo contrato, o desde una función de un contrato que deriva del mismo. NO es accesible desde un mensaje de un contrato externo o una transacción externa.
- External: Accesible desde una cuenta de propiedad externa y a través de un mensaje (llamada desde otro contrato). No es accesible desde una función del mismo contrato o uno derivado del mismo.

Keywords

- **payable:** La usamos cuando necesitamos dentro de una función enviar ether alguna dirección de la blockchain


    // SPDX-License-Identifier: GPL-3.0
    
    pragma solidity >=0.7.0 <0.9.0;
    
    contract Fund {
        function sendEther(address payable receiver) public payable {
            receiver.transfer(msg.value);
        }
    }


- **view :** La usamos para definir que una función no va modificar las variables de estado, sino que sólo las puede leer.


	// SPDX-License-Identifier: GPL-3.0

	pragma solidity >=0.7.0 <0.9.0;

	contract Asset {
		string name = "PlatziCoin";

		function getName() public view returns (string memory) {
			return name;
		}
	}

- **pure:** Se usa para definir que una función no lee ni modifica ninguna de las variables de estado y además no usa ninguna variable global


	// SPDX-License-Identifier: GPL-3.0

	pragma solidity >=0.7.0 <0.9.0;

	contract Sum {
		int256 number = 100;

		function sum(int256 a, int256 b) public pure returns (int256 result) {
			result = a + b;
		}
	}

### Data Location

- Storage: Queda guardada dentro de la blockchain, siempre vamos a poder obtener el valor almacenado, pues este nunca se va borrar. Memoria Persistente.

- Memory (Modificable): Solo existe mientras se llama una función y no podemos acceder de nuevo a el dato.

- Call data (inmodificable): Solo existe mientras se llama la función

Por defecto las variables de estado se almacenan en el storage y los parámetros en memory.


### Modifier

 Require: 1er parametro la condicion que va a validar, 2do param mensaje cuando la validacion falla

 Los modificadores son funciones especiales por el usuario y que se añaden a otra función para envolver su funcionamiento

	modifier <name>(<type> <parameter>..., [,...]) {
	  <content>
	}


El guión bajo
El guión bajo (también conocido como placeholder), es una instrucción especial del modificador que indica dónde se va a ejecutar el código de la función inicial que envuelve al modifier.

Por ejemplo

	## Primero valida y luego ejecuta
	modifier isOwner() {
	  if(<condicion>) revert()
	  _;
	}

	## Primero ejecuta y luego valida
	modifier isOwner() {
	   _;
	  if(<condicion>) revert()
	}

	## Ejecuta, valida y vuelve a ejecutar
	modifier isOwner() {
	   _;
	  if(<condicion>) revert()
	   _;
	}

La función revert() se utiliza para arrojar una excepción en nuestro smart contract y revertir la función que la llama. Se puede agregar un mensaje como parámetro describiendo el error

	modifier EsOwner() {
		if (msg.sender != owner) revert("Solo el dueño del contrato puede modificarlo.");
		_;
	}
 

### Eventos

Permite conectar lo que pasa dentro de la Blockchain con el exterior porque a tráves de un protocolo otras aplicaciones se pueden suscribir a ellos y escuchar todo lo que está pasando en el Smart Contract.
Se usan para: 
- Registrar cambios que se hicieron
- Feedback (Retroalimentación)

### Errores

- Dan información específica sobre el fallo
- Revierte los cambios aplicados para dar conciencia a la ejecución (El valor del gas cobrado por la ejecución no se devuelve a quien llama el contrato)

### Struct types

Solidity permite al usuario crear su propio tipo de datos en forma de estructura. La estructura contiene un grupo de elementos con un tipo de datos diferente. Generalmente, se usa para representar un registro. Para definir una estructura se utiliza la palabra clave struct, que crea un nuevo tipo de datos.

	struct Hero {
	  string name;
	  uint age;
	  uint power;
	  string team;
	}
	Hero cap = Hero('Cap',103, 80, 'Avengers');
	cap.name  //Cap
	cap.age   //103
	cap.power  //80
	cap.team  //Avengers

### Enum types

Las enumeraciones son la forma de crear tipos de datos definidos por el usuario, generalmente se usa para proporcionar nombres para constantes integrales, lo que hace que el contrato sea mejor para el mantenimiento y la lectura. Las enumeraciones restringen la variable con uno de los pocos valores predefinidos, estos valores de la lista enumerada se denominan enumeraciones. Las opciones de se representan con valores enteros comenzando desde cero, también se puede dar un valor predeterminado para la enumeración. Mediante el uso de enumeraciones es posible reducir los errores en el código.

	enum <enumerator_name> { 
				element 1, elemenent 2,....,element n
	} 

### Array
- Contenedores que almacenan datos de un tipo especifico
- Pueden ser de tamanios dinamicos o fijos
	- Fijos: `uint[3] steps = [1,2,3];`
	- Dinamicos: `uint[] steps;`
- Se acceden a traves de su indice
- Metodos push y pop solo funcionan en arrays dinamicos
	

```
steps.push(1) // [1]
steps.push(2) // [1,2]
steps.pop() // [1]

steps[0]  //1
```

.
### Mapping

- Permite almacenar datos asociando una llave:valor
`mapping (string -> string) countries;`


```
countries['Felipe'] = 'Colombia';
countries['Laura']= 'Ecuador';

countries['Felipe'] // 'Colombia';
countries['Laura'] // 'Ecuador';
```

### Recibir Ether desde un contrato

- Receive: Recibe el saldo de trasferencias sin parámetros.
- FallBack: Recibe información adjunta a la trasferencia por medio de los parámetros.
- Función Payable: Se especifica el tipo payable a una función que puede recibir trasferencias.

### Manejo de dependencias y librerias

	// SPDX-License-Identifier: GPL-3.0

	pragma solidity >=0.7.0 <0.9.0;

	import "@openzeppelin/contracts/utils/math/SafeMath.sol";

	contract Importacion {

	  function sumarNumeros(uint numero1, uint numero2) public pure returns (uint) {
		return SafeMath.add(numero1,numero2);
	  }

	}

### Herencia
>“No hay que reinvetar la rueda”

Utilizamos la Herencia para reutilizar codigo en nuevos contratos. Solidity no es POO, pero se comporta similar. **Solidity es orientado a contratos.** Identificaremos con la sentencia ***is***. Si un contrato tiene un constructor con parametros, debemos indicar que valores debe tomar ese constructor para poder derivarse.

Entonces, se busca generar una relacion entre contratos para reutilizar el codigo mediante la Herencia. Por lo que la capacidad de agregar/modificar una funcion ya escrita en el contrato anterior nos sera de mucha utilidad.

Las funciones virtuales son funciones definidas para que se puedan reescrbir por las funciones override. Para esto debemos establecer una relacion de Herencia. Si una funcion virtual no define implementacion, el contrato se convierte en un contrato abstracto. Tambien hay contratos abstractos que usamos como moldes vacios para usar en futuros contratos.

Las interfaces no van a tener codigo. su funcion es indicarnos un comportamiento que queremos que tenga un contrato. Solo tiene declaraciones (definiciones de funciones) sin codigo.

**Herencia.sol** 📕📘📗

	// SPDX-Licence-Identifier: UNLICENSED

	pragma solidity >=0.7.0 < 0.9.0;

	import "./Interface.sol";
	import "./Modificadores.sol";

	contract Herencia is Suma, Modificadores {

		constructor(string memory nombreNuevo) Modificadores(nombreNuevo) {

		}

		function sumar(uint numero1, uint numero2) public override EsOwner() view returns(uint) {
			return numero1 + numero2;
		}
	}

Es buena practica traer todo el encabezado de la funcion de “Interface”, por lo que es recomendable copiar y pegar “function sumar(uint numero1, uint numero2)”

**Interface.sol** 📘

	// SPDX-Licence-Identifier: UNLICENSED

	pragma solidity >=0.7.0 < 0.9.0;

	interface Suma {

		function sumar(uint numero1, uint numero2) external returns (uint);
	}


**Modificadores.sol** 📗

	// SPDX-Licence-Identifier: UNLICENSED

	pragma solidity >=0.4.0 < 0.9.0;

	contract Modificadores {


		address private owner;
		string private nombreOwner;

		constructor(string memory nombre {
			owner = msg.sender;
			nombreOwner = nombre;
		}

		function Suma(uint numero1, uint numero2) public view EsOwner() returns (uint) {
			return numero1 + numero2;
		}

		modifier EsOwner() {
			if (msg.sender != owner) revert();
			_;
		}
	}

### Polimorfismo

Una convencion en las ´interfaces´ es llevar una **i** delante del nombre. 

Interfaces solo definen encabezados pero no pueden tener una implementacion en la red. No podemos hacer el `deploy` pero si podemos usar un contrato que lo implemente. 

Polimorfismo


```
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Interface.sol";

contract Polimorfismo {
    
    function sumarDesdeContrato(uint numero1, uint numero2, address direccionContrato)
        public returns(uint) {  
            Suma interfaceSuma = Suma(direccionContrato);
            return interfaceSuma.sumar(numero1,numero2);
    } 
    
}
```

ImplementacionSuma.sol


```
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Interface.sol";

contract ImplementacionSuma is Suma {
    
    function sumar(uint numero1, uint numero2) public override pure returns (uint) {
        return numero1 + numero2;
    }
    
}
```

Interface.sol



```
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface Suma {
    
    function sumar(uint numero1, uint numero2) external returns (uint);
    
}
```

Con el polimorfismo pudimos usar la suma que esta en otro contrato porque no llamamos directamente a la implementación de Suma sino que hicimos la llamada a la Interface, a pesar de que las interfaces no pueden ser implementadas en la red, pero con Polimorfismo pudimos hacerlo.

### Tokens

**ERC-20**
- Representa a los tokens fungibles
- Solo define su Interface
- Existen mas estándares pero mantienen compatibilidad con el ERC-20

[ERC-20 OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol)

**ERC-721**
- Representa a los tokens no fungibles. NFT
- Solo define su Interface
- Tienen un identificador único conocido como tokenId.

[ERC-721 OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol)**ABI**
- Application Binary Interface
- Es una interface que nos detalla que definiciones tiene el contrato y sus funciones, sin conocer su implementacion.
- Nos permite saber la forma que tiene un contrato para poder interactuar con las funciones.
- ABI se presenta en formato JSON

Herramientas que gestionan el ABI
- [HardHat](https://hardhat.org/)
- [Truffle](http://trufflesuite.com/truffle/)

