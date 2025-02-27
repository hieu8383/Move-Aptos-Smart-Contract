module donation_contract_v2::donation_contract_v2 {
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::signer;

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

    public entry fun initialize(account: &signer, recipient: address) {
        let contract = DonationContract {
            recipient,
            battery_price: 1000000, // 1 APT in octas
            bread_price: 500000,    // 0.5 APT
            diaper_price: 300000,   // 0.3 APT
            pasta_price: 400000,    // 0.4 APT
            battery_count: 0,
            bread_count: 0,
            diaper_count: 0,
            pasta_count: 0,
        };
        move_to(account, contract);
    }

    public entry fun donate(
        account: &signer,
        contract_address: address,
        donation1: u64,
        donation2: u64
    ) acquires DonationContract {
        let contract = borrow_global_mut<DonationContract>(contract_address);
        let total_cost = 0u64;

        process_donation(donation1, &mut contract.battery_count, &mut contract.bread_count, 
                         &mut contract.diaper_count, &mut contract.pasta_count, 
                         contract.battery_price, contract.bread_price, 
                         contract.diaper_price, contract.pasta_price, &mut total_cost);

        process_donation(donation2, &mut contract.battery_count, &mut contract.bread_count, 
                         &mut contract.diaper_count, &mut contract.pasta_count, 
                         contract.battery_price, contract.bread_price, 
                         contract.diaper_price, contract.pasta_price, &mut total_cost);

        coin::transfer<AptosCoin>(account, contract.recipient, total_cost);
    }

    fun process_donation(
        donation: u64,
        battery_count: &mut u64,
        bread_count: &mut u64,
        diaper_count: &mut u64,
        pasta_count: &mut u64,
        battery_price: u64,
        bread_price: u64,
        diaper_price: u64,
        pasta_price: u64,
        total_cost: &mut u64
    ) {
        let battery_amount = donation / 1000 % 10;
        let bread_amount = donation / 100 % 10;
        let diaper_amount = donation / 10 % 10;
        let pasta_amount = donation % 10;

        *battery_count = *battery_count + battery_amount;
        *bread_count = *bread_count + bread_amount;
        *diaper_count = *diaper_count + diaper_amount;
        *pasta_count = *pasta_count + pasta_amount;

        *total_cost = *total_cost + (battery_amount * battery_price) +
                      (bread_amount * bread_price) +
                      (diaper_amount * diaper_price) +
                      (pasta_amount * pasta_price);
    }

    public entry fun withdraw_donation(
        account: &signer,
        contract_address: address,
        withdrawal1: u64,
        withdrawal2: u64
    ) acquires DonationContract {
        let contract = borrow_global_mut<DonationContract>(contract_address);
        assert!(signer::address_of(account) == contract.recipient, 1); // Only recipient can withdraw

        process_withdrawal(withdrawal1, &mut contract.battery_count, &mut contract.bread_count, 
                           &mut contract.diaper_count, &mut contract.pasta_count);
        process_withdrawal(withdrawal2, &mut contract.battery_count, &mut contract.bread_count, 
                           &mut contract.diaper_count, &mut contract.pasta_count);
    }

    fun process_withdrawal(
        withdrawal: u64,
        battery_count: &mut u64,
        bread_count: &mut u64,
        diaper_count: &mut u64,
        pasta_count: &mut u64
    ) {
        let battery_amount = withdrawal / 1000 % 10;
        let bread_amount = withdrawal / 100 % 10;
        let diaper_amount = withdrawal / 10 % 10;
        let pasta_amount = withdrawal % 10;

        assert!(*battery_count >= battery_amount, 2); // Not enough batteries
        assert!(*bread_count >= bread_amount, 3); // Not enough bread
        assert!(*diaper_count >= diaper_amount, 4); // Not enough diapers
        assert!(*pasta_count >= pasta_amount, 5); // Not enough pasta

        *battery_count = *battery_count - battery_amount;
        *bread_count = *bread_count - bread_amount;
        *diaper_count = *diaper_count - diaper_amount;
        *pasta_count = *pasta_count - pasta_amount;
    }

    // View functions
    #[view]
    public fun get_battery_count(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).battery_count
    }

    #[view]
    public fun get_battery_price(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).battery_price
    }

    #[view]
    public fun get_bread_count(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).bread_count
    }

    #[view]
    public fun get_bread_price(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).bread_price
    }

    #[view]
    public fun get_diaper_count(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).diaper_count
    }

    #[view]
    public fun get_diaper_price(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).diaper_price
    }

    #[view]
    public fun get_pasta_count(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).pasta_count
    }

    #[view]
    public fun get_pasta_price(contract_address: address): u64 acquires DonationContract {
        borrow_global<DonationContract>(contract_address).pasta_price
    }
}