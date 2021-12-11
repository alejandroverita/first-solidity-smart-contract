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

