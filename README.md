# Account Reputation System
A reputation system for smart contracts

## Simple Summary
The proposed idea provides a system for smart contracts to retrieve the reputation of another account so they can decide how to interact -or whether or not to interact- with said account.

## Abstract
The following discusses the implementation of a system that can be accessed by any other smart contracts or EOA to provide and/or retrieve reputation data regarding another smart contract or EOA.

The idea behind this system is to provide a way for smart contracts to trust other smart contracts when they have to interact with them without having to manually review their code, which in a system where contract addresses might be submitted by users, doing so is unfeasible.

Accounts can each give a score to another account on a scale from 0 to 10 . Each score counts towards a negative/neutral/positive count (using the same scale as the Net Promoter Score) and that data can be used by other smart contracts to decide how to interact with the target smart contract, however they choose.

## Motivation
It is very common to need a smart contract to either call a function in another smart contract or have its functions being called by other smart contracts.

When interacting with untrusted smart contracts, as developers, we have to make sure we don't open our own smart contracts to vulnerabilities like reentrancy. The only way to prevent vulnerabilities is either not interacting with other 3rd party smart contracts altogether, which sometimes can't be helped; or manually reviewing the code of the smart contract/s we wish to interact with, if they are public, in order to make sure there is no malicious code.

Another use case for this might be in a system where users can submit the address of smart contracts for our own smart contract to interact with. In such cases, the only way to prevent executing malicious code would be to establish a whitelist and make sure the submitted smart contracts are not malicious before accepting them into the whitelist.

For example, in a system that accepts 3rd party ERC20 tokens and  "airdrops" them to subscribed users, we wouldn't be able to let just anyone "upload" their token contract to start distributing them without passing by some sort of verification where it is needed to make sure that the ERC20 methods are being implemented without malicious intents.

This Account Reputation System would provide an additional layer of security by letting the calling smart contract know what's the reputation of the target smart contract (or EOA) and letting it act upon it however it chooses. _Read Rationale section below for more information about this._

## Specification
### Methods
#### negativeCount / neutralCount / PositiveCount
Returns the amount of either negative, neutral or positive scores for a given account. 
A negative score is a score given from the range of 0 to 6. (According to NPS)
A neutral score is a score given from the range of 7 to 8. (According to NPS)
A positive score is a score given from the range of 9 to 10. (According to NPS)

``` js
function negativeCount(address _account) view returns (uint negativeCount)
function neutralCount(address _account) view returns (uint neutralCount)
function positiveCount(address _account) view returns (uint positiveCount)
```

#### totalCount
Returns the total amount of ratings for a given account. This can be used by the calling contract to calculate averages or ratios, as well as for specifying certain amount of ratings threshold required to start taking the ratings into account.

``` js
function totalCount(address _account) view returns (uint totalCount)
```

#### scoreSum
Returns the sum of all ratings for a given account. This can be used to calculate average scores, or for requiring a contract to have certain accumulated reputation before a contract can interact with it.

``` js
function scoreSum(address _account) view returns (uint scoreSum)
```

#### submitFeedback
This method allows any account to provide feedback for any other account. This function can only be called once per account for a single target account. 
`_account` is the target account that the caller is providing feedback for.
`_score` is the score that is going to be assigned to the target account (ranging from 0 to 10).
`_message` **optional** is an accompanying message for the score. It can be used as a review, or indication of why the score was given.

This method receives the score and applies it to the internal state variables of the Reputation contract in order to keep track of positive / neutral / negative ratings, total ratings, the sum of the scores, etc.

``` js
function submitFeedback(address _account, uint _score, string _message) public
```

#### Helper methods
The following methods allow accounts to get actionable data about a particular account from the ARS.

``` js
// Returns the percentage of ratings that correspond to a negative reputation for a given account
function getNegativeRatio(address _account) view public returns (uint) 

// Returns the percentage of ratings that correspond to a neutral reputation for a given account    
function getNeutralRatio(address _account) view public returns (uint) 
   
// Returns the percentage of ratings that correspond to a positive reputation for a given account
function getPositiveRatio(address _account) view public returns (uint) 

// Returns the score average for a given account    
function getScoreAverage(address _account) view public returns (uint)
```

### Events

#### SubmitFeedback
MUST trigger when a rating is submitted.
Logs the feedback given by an account to another account.

``` js
event SubmitFeedback(address indexed _from, address indexed _to, uint indexed date, uint _score, string _message);
```

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
https://github.com/pabloruiz55/AccountReputationSystem

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
