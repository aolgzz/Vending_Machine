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

This Racket program consist of a "simulator" of a vending machine that can hold a wide variety of products of different prices, and payments can be with coins or bills, it is able to return change if requiered to do so. 

The machine has slots, each of them with an inventory of the product for sale. Each slot is identified with an ID, which allows the user to choose which product is of its desire.  Likewise, each slot has the price of the associated product.

On the other hand, the machine also has an invisible compartment to the user, in which the money is stored. The coins, and bills used by default are of the following denominations: $1, $2, $5, $10, $20, and $50. Also by default, when the machine begins to operate it has a minimum money inventory for giving change. As there are sales, this inventory changes. (All this default values can later be modified, that is explain later in the Getting Started section).

The inside of the machine is modeled with matrices in which is clear to identify the machine's inventory, both of the slots of the products, and of the money denominations (backend). This information is stored in two text files. The program will read both files, depending on how sales progress is that the backend is updated (there are cases in which it remains the same).

The simulation consists in processing sales transactions which will be stored in a third text file. Each transaction is identified with the product's ID, and the sequence of coins, and bills that are inserted for its purchase. When processing a transaction, the program will write into (frontend) a fourth text file (this file will behave as the machine's sales report/receipt) if the purchase is made and the remaining coins, if any. Obviously, each transaction must update the corresponding inventories (backend). When a transaction is not possible, the situation must be indicated with a message, for example, a sale not possible due to lack of product, or a surplus of coins that cannot be delivered.

When the program has processed all the sales transactions of the input file, it will give the following results:

- The total revenue after all valid transactions have been processed.
- Products with little or no inventory.
- Money denominations with nearly or full inventory.
- Money denominations with little or no inventory.

Note: The machine uses a Finite State Machine that processes all sales transactions, depening on them they may have the following states: invalid denomination inserted, not enough credit, no change (exact paymente), and give change.

</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* [![Next][Next.js]][Next-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```
  
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
