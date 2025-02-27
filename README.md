
# Move-Aptos-Smart-Contract

## Overview

Move-Aptos-Smart-Contract is a smart contract written in the Move programming language for the Aptos blockchain. It facilitates donations of essential supplies (batteries, bread, diapers, pasta) using AptosCoin (APT). Donors can contribute specified amounts, and the contract maintains a record of received donations.

## Features

-   **Initialize Contract**: Deploy the contract with a designated recipient address.
    
-   **Make Donations**: Send donations in APT to purchase essential supplies.
    
-   **Withdraw Donations**: The recipient can withdraw received items.
    
-   **View Functions**: Retrieve prices and available donation counts for each item.
    

## Contract Structure

### `DonationContract` Struct

This struct stores the recipient's address, item prices, and donation counts:

```
struct DonationContract has key {
    recipient: address,
    battery_price: u64,
    bread_price: u64,
    diaper_price: u64,
    pasta_price: u64,
    battery_count: u64,
    bread_count: u64,
    diaper_count: u64,
    pasta_count: u64,
}
```

### Functions

#### 1. `initialize(account: &signer, recipient: address)`

Initializes the contract with predefined prices and an empty donation count.

#### 2. `donate(account: &signer, contract_address: address, donation1: u64, donation2: u64)`

Allows users to donate funds, increasing the count of items purchased based on a predefined format.

#### 3. `withdraw_donation(account: &signer, contract_address: address, withdrawal1: u64, withdrawal2: u64)`

Permits the recipient to withdraw donated items.

#### 4. View Functions

Retrieve information about item counts and prices:

-   `get_battery_count(contract_address: address) -> u64`
    
-   `get_battery_price(contract_address: address) -> u64`
    
-   `get_bread_count(contract_address: address) -> u64`
    
-   `get_bread_price(contract_address: address) -> u64`
    
-   `get_diaper_count(contract_address: address) -> u64`
    
-   `get_diaper_price(contract_address: address) -> u64`
    
-   `get_pasta_count(contract_address: address) -> u64`
    
-   `get_pasta_price(contract_address: address) -> u64`
    

## Donation Encoding Format

Each donation is represented as a `u64` number using the following format:

```
Battery (thousands place) | Bread (hundreds place) | Diaper (tens place) | Pasta (ones place)
```

For example, a donation value of `1203` translates to:

-   1 battery
    
-   2 bread
    
-   0 diapers
    
-   3 pasta
    

## Deployment

1.  Install the Aptos CLI.
    
2.  Compile and deploy the contract to an Aptos account.
    
3.  Interact with the contract using the Aptos CLI or an integrated frontend.
    

## License

This project is licensed under the MIT License.
