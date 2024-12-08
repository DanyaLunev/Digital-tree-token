// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DigitalTreeToken is ERC20, Ownable {
    // Общее количество токенов
    uint256 private constant INITIAL_SUPPLY = 100000 * (10 ** 18);

    constructor(address initialOwner) ERC20("DigitalTreeToken", "DTK") Ownable(initialOwner) {
        _mint(msg.sender, INITIAL_SUPPLY); // Выпуск токенов на адрес создателя контракта
    }

    // Функция для покупки токенов
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy some tokens");

        // Устанавливаем курс токена (например, 1 ETH = 1000 DTK)
        uint256 tokensToBuy = msg.value * 1000;
        require(balanceOf(owner()) >= tokensToBuy, "Not enough tokens in the reserve");

        // Переводим токены покупателю
        _transfer(owner(), msg.sender, tokensToBuy);
    }

    // Функция для получения ETH за токены
    function sellTokens(uint256 tokenAmount) public {
        require(tokenAmount > 0, "Specify an amount of tokens to sell");
        require(balanceOf(msg.sender) >= tokenAmount, "Not enough tokens");

        // Устанавливаем курс токена (например, 1 ETH = 1000 DTK)
        uint256 etherAmount = tokenAmount / 1000;
        require(address(this).balance >= etherAmount, "Not enough ETH in the contract");

        // Переводим токены обратно в контракт
        _transfer(msg.sender, owner(), tokenAmount);
        // Переводим ETH продавцу
        payable(msg.sender).transfer(etherAmount);
    }

    // Функция для получения баланса контракта
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
