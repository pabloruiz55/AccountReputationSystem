# Account Reputation System
A reputation system for smart contracts

## Preamble

    EIP: <to be assigned>
    Title: Account Reputation System
    Author: Pablo Ruiz <me@pabloruiz.co>
    Type: Standard Track
    Category: ERC
    Status: Draft
    Created: 2017-12-26

## Simple Summary
The proposed idea provides a system for smart contracts to retrieve the reputation of another account so they can decide how to interact -or whether or not to interact- with said account.

## Abstract
The following discusses the implementation of a system that can be accessed by any other smart contracts or EOA to provide and/or retrieve reputation data regarding another smart contract or EOA.

The idea behind this system is to provide a way for smart contracts to trust other smart contracts when they have to interact with them without having to manually review their code. 

Accounts can each give a score to another account on a scale from 0 to 10 . Each score counts towards a negative/neutral/positive count (using the same scale as the Net Promoter Score) and that data can be used by other smart contracts to decide how to interact with the target smart contract, however they choose.

## Motivation
It is very common to need a smart contract to either call a function in another smart contract or have its functions being called by other smart contracts.

When interacting with untrusted smart contracts, as developers, we have to make sure we don't open our own smart contracts to vulnerabilities like reentrancy. The only way to prevent vulnerabilities is either not interacting with other 3rd party smart contracts altogether, which sometimes can't be helped; or manually reviewing the code of the smart contract/s we wish to interact with, if they are public, in order to make sure there is no malicious code.

For example, in a system that accepts 3rd party ERC20 tokens and  "airdrops" them to subscribed users, we wouldn't be able to let just anyone "upload" their token contract to start distributing them without passing by some sort of verification where it is needed to make sure that the ERC20 methods are being implemented without malicious intents.

This Account Reputation System would provide an additional layer of security by letting the calling smart contract know what's the reputation of the target smart contract (or EOA) and letting it act upon it however it chooses. _Read Rationale section below for more information about this._

## Specification

### Events

#### 

## Rationale
The Account Reputation System (ARS) allows accessing reputation data about any smart contract (if it exists) which is previously provided by other users or smart contracts.

By calling the ARS' `submitFeedback()` method, any account can provide reputation data (a score from 0 to 10 and an optional message) about another target account. This feedback CAN only be submitted once (One account -> One submission for target account).

Then, another smart contract wanting to base its logic on the ARS can access the data by calling any of the defined methods. For example, a smart contract could retrieve the amount of negative ratings a target contract has by calling `negativeCount(address)` or the percentage of positive ratings by calling `getPositiveRatio(address)`. 

The ARS only provides the raw data. The calling smart contract would then decide how to use that data as it sees fit. For example, a smart contract may decide to only allow interacting with a smart contract that has a 80% positive rating ratio and no more than 5 negative score count.  Another smart contract could be laxer and allow transactions with smart contracts with a lower positive rating ratio.

### Some issues I've yet to solve / I'd like to openly discuss:
**1. Spamming / false data:** Even though we accept only one rating per account for every contract, there's nothing stopping someone using multiple accounts to spam or provide false data. For example, a competitor could submit hundreds of negative ratings for our smart contract to make it seem like a bad actor. Conversely, the owner of a malicious smart contract could submit any number of positive ratings to make it look like a good actor.

I've found no immediate solution for this, other maybe establishing a system where the ratings of accounts with positive ratings have more weight than accounts with negative or no ratings.

## Implementation
Example implementation:
https://github.com/pabloruiz55/TokenWithVotingRights

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
