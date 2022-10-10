<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/aolgzz/Vending_Machine">
    <img src="images/512px-Racket-logo.svg.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Vending Machine</h3>

  <p align="center">
    A text file based vending Machine written in the Racket programming language. 
    <br />
    <a href="https://github.com/aolgzz/Vending_Machine"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/aolgzz/Vending_Machine">View Demo</a>
    ·
    <a href="https://github.com/aolgzz/Vending_Machine/issues">Report Bug</a>
    ·
    <a href="https://github.com/aolgzz/Vending_Machine/issues">Request Feature</a>
  </p>
</div>

<div align = "center">
  
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
  
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

<div align = "center">

[![Product Name Screen Shot][product-screenshot]](https://github.com/aolgzz/Vending_Machine)

</div>

<div align = "justify">

El programa por realizar en Scheme es un simulador de una máquina expendedora que puede tener diversos productos de diferentes precios y que sólo acepta pagos con monedas, teniendo la capacidad de dar cambio si un pago lo requiere.

Las máquinas expendedoras en esta simulación tienen “slots” o cajones, cada uno con un inventario del producto a la venta. Cada slot está identificado con una letra, lo que le permite al comprador indicar qué producto quiere. Así mismo, cada slot tiene el precio del producto asociado.

Por otro lado, la máquina también tiene un compartimiento no visible para el usuario, en donde se almacenan las monedas. Las monedas que se manejarán en esta máquina son de las siguientes denominaciones: $1, $2, $5, $10, $20 y $50 pesos. Cuando una máquina empieza a operar, tiene un inventario mínimo de monedas para poder dar cambio. Conforme hay ventas, este inventario se incrementa.

El contenido de la máquina será modelado en Scheme con una lista en la que se pueda identificar claramente el contenido de la máquina, tanto lo de los slots, como lo de las monedas almacenadas. Esta información será guardada permanentemente en un archivo texto que contenga la lista con los datos. El programa leerá al inicio los datos de este archivo, y trabajará las transacciones de la simulación grabando cada vez en el archivo la lista actualizada.

La simulación consistirá en procesar las transacciones de venta que estarán en otro archivo de texto con los datos de estas. Cada transacción de venta se identifica con la letra del producto a comprar y la secuencia de monedas que se depositan para la compra. El programa al procesar una transacción indicará con letreros en pantalla si la compra se realiza y las monedas sobrantes en caso de que las haya. Obviamente, cada transacción deberá actualizar los inventarios correspondientes. Cuando una transacción no sea posible, se deberá indicar con un mensaje la situación, por ejemplo, una venta no posible por falta de producto, o un sobrante de monedas no factible de entregar.

Cuando el programa haya realizado todas las transacciones de venta del archivo de entrada, dará los siguientes resultados:

Ganancia obtenida después de todas las transacciones de venta.
Productos con poco inventario o inventario nulo.
Denominaciones de monedas que tienen el repositorio lleno o casi lleno.
Denominaciones de monedas que tienen poco inventario o nulo.
El criterio para identificar poco inventario y repositorio lleno puede ser diseñado libremente en el programa, pero deberá estar claramente documentado en el código.

Por lo pronto, no habrá una interfase para modificar inventarios a través del programa. Cualquier ajuste de inventario para las pruebas de simulación se hará directamente en la lista de datos de la máquina.

La interfase de ejecución para este programa es completamente libre, y no se requiere nada gráfico ni especializado. Incluso, se puede manejar directamente la llamada a funciones desde el intérprete de Dr. Racket. Lo importante es que los datos se lean de los archivos correspondientes, se actualice el archivo de la máquina, y se desplieguen en pantalla los resultados esperados después de todas las transacciones.

En cuanto a los algoritmos para procesar las transacciones, el programa DEBERÁ utilizar un autómata de estados finitos para reconocer el pago con las monedas. El diseño del mismo es clave para el funcionamiento correcto del programa, y deberá considerar los diferentes precios de los productos, así como el control de los inventarios correspondientes.
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* [![Next][Next.js]][Next-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/github_username/repo_name.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
4. Enter your API in `config.js`
   ```js
   const API_KEY = 'ENTER YOUR API';
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

See the [open issues](https://github.com/github_username/repo_name/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email@email_client.com

Project Link: [https://github.com/github_username/repo_name](https://github.com/github_username/repo_name)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/aolgzz/Vending_Machine.svg?style=for-the-badge
[contributors-url]: https://github.com/aolgzz/Vending_Machine/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/aolgzz/Vending_Machine.svg?style=for-the-badge
[forks-url]: https://github.com/aolgzz/Vending_Machine/network/members
[stars-shield]: https://img.shields.io/github/stars/aolgzz/Vending_Machine.svg?style=for-the-badge
[stars-url]: https://github.com/aolgzz/Vending_Machine/stargazers
[issues-shield]: https://img.shields.io/github/issues/aolgzz/Vending_Machine.svg?style=for-the-badge
[issues-url]: https://github.com/aolgzz/Vending_Machine/issues
[license-shield]: https://img.shields.io/github/license/aolgzz/Vending_Machine.svg?style=for-the-badge
[license-url]: https://github.com/aolgzz/Vending_Machine/blob/master/LICENSE.txt
[product-screenshot]: images/_screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
