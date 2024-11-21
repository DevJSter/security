### Prerequisites


### **1. Basics of Solidity**
- **Smart Contracts**: Building blocks of Ethereum applications.
- **Version Pragma**: Specify the compiler version.
  ```solidity
  pragma solidity ^0.8.0;
  ```
- **State Variables**: Persist data on the blockchain.
  ```solidity
  uint public count; // Example state variable
  ```

---

### **2. Data Types**
- **Value Types**: Include:
  - `uint` (unsigned integer): e.g., `uint256`.
  - `int` (signed integer).
  - `address`: Holds Ethereum addresses.
  - `bool`: `true` or `false`.
  - `bytes`: Fixed-size byte arrays.
  - `string`: Text data.
  
- **Reference Types**:
  - Arrays (fixed and dynamic): `uint[]` or `uint[5]`.
  - Mappings: `mapping(address => uint)`.

---

### **3. Functions**
- **Visibility Modifiers**:
  - `public`: Callable externally and internally.
  - `private`: Only callable within the contract.
  - `internal`: Callable within the contract and inherited ones.
  - `external`: Callable only from outside.

- **Function Modifiers**: Add pre-/post-conditions.
  ```solidity
  modifier onlyOwner {
      require(msg.sender == owner);
      _;
  }
  ```

---

### **4. Events**
Used for logging data to the blockchain.
```solidity
event Transfer(address indexed from, address indexed to, uint amount);

function transfer(address to, uint amount) public {
    emit Transfer(msg.sender, to, amount);
}
```

---

### **5. Fallback and Receive Functions**
Handle plain Ether transfers or unknown function calls.
- **`fallback`**: Triggered if no matching function is found.
  ```solidity
  fallback() external payable {
      // Fallback logic
  }
  ```
- **`receive`**: Specifically handles plain Ether transfers.
  ```solidity
  receive() external payable {
      // Receive Ether logic
  }
  ```

---

### **6. Error Handling**
- **`require`**: Validate inputs or conditions.
- **`assert`**: Check for internal errors.
- **`revert`**: Provide custom error messages.
  ```solidity
  require(amount > 0, "Amount must be greater than zero");
  revert("Custom error");
  ```

---

### **7. Enums**
Define a fixed set of states or options.
```solidity
enum Status { Pending, Shipped, Delivered }

Status public currentStatus;

function setStatus(Status _status) public {
    currentStatus = _status;
}
```

---

### **8. Inheritance**
Allows contracts to inherit behavior from parent contracts.
```solidity
contract Parent {
    function greet() public pure returns (string memory) {
        return "Hello!";
    }
}

contract Child is Parent {}
```

---

### **9. Payable Functions**
Enable Ether transfers to the contract.
```solidity
function deposit() public payable {}
```

---

### **10. Mappings**
Key-value storage.
```solidity
mapping(address => uint) public balances;

function updateBalance(uint amount) public {
    balances[msg.sender] = amount;
}
```

---

### **11. Libraries**
Reusable, stateless functions for contracts.
```solidity
library Math {
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
}
```

---

### **12. Storage vs Memory**
- `storage`: Persistent (stored on-chain).
- `memory`: Temporary (used in function calls).

---

### **13. Structs**
Custom data types.
```solidity
struct User {
    string name;
    uint balance;
}

User public user = User("Alice", 100);
```

---

### **14. Gas Optimization Tips**
- Use `constant` or `immutable` for fixed values.
- Minimize state variable writes.
- Favor `calldata` over `memory` for external function parameters.

---

---

### **1. ERC Standards**
#### **ERC-20 (Fungible Tokens)**  
ERC-20 is the standard for fungible tokens (all units are identical). Key functions include:  
- **`totalSupply()`**: Total token supply.  
- **`balanceOf(address)`**: Token balance of an address.  
- **`transfer(to, amount)`**: Transfer tokens directly.  
- **`approve(spender, amount)`**: Authorize a spender.  
- **`transferFrom(from, to, amount)`**: Transfer tokens on behalf of another user.  
- **`allowance(owner, spender)`**: Remaining tokens a spender can spend.

Example:  
```solidity
pragma solidity ^0.8.0;

contract MyToken {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint public totalSupply = 1_000_000 * 10**uint(decimals);

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}
```

#### **ERC-721 (Non-Fungible Tokens)**  
ERC-721 is the standard for non-fungible tokens (unique assets).  
Key functions:  
- **`balanceOf(owner)`**: Number of tokens owned by an address.  
- **`ownerOf(tokenId)`**: Token owner.  
- **`safeTransferFrom(from, to, tokenId)`**: Transfer tokens safely.  
- **`approve(to, tokenId)`**: Approve token transfer.  

Uses:
- Gaming assets, art, and unique ownership tokens.  

#### **ERC-1155 (Multi-Token Standard)**  
Combines fungible, non-fungible, and semi-fungible tokens into one standard.  
- **Batch transfers**: Efficient operations for multiple tokens.  
- Popular in gaming and marketplaces (e.g., Enjin).  

---

### **2. EIPs (Ethereum Improvement Proposals)**  
Some notable EIPs:  
- **EIP-1559**: Introduced the base fee and priority fee mechanism for gas optimization.  
- **EIP-2612**: Adds `permit` functionality to ERC-20, enabling gasless token approvals using signatures.  
- **EIP-2981**: Royalty standard for NFTs.  

You can find all EIPs [here](https://eips.ethereum.org).  

---

### **3. VRF (Verifiable Random Function)**  
Chainlink VRF generates provably random values on-chain, often used in games and lotteries.  
Example usage:  
```solidity
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Randomness is VRFConsumerBase {
    bytes32 private keyHash;
    uint256 private fee;
    uint256 public randomResult;

    constructor(address vrfCoordinator, address linkToken) 
        VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = 0x...; // Key hash for Chainlink
        fee = 0.1 * 10**18; // LINK fee
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        randomResult = randomness;
    }
}
```

---

### **4. Governance Tokens**
Governance tokens are typically ERC-20 tokens used for decentralized decision-making (e.g., voting on proposals).  
- **Compound-style governance**: Weighted voting based on token holdings.  
- **Snapshot voting**: Uses off-chain tools but verifies on-chain signatures.  

Example governance workflow:  
1. Token holders propose changes.  
2. Voting period begins.  
3. Proposal executed if a quorum is met.  

Tools:  
- [OpenZeppelin Governor](https://docs.openzeppelin.com/contracts/4.x/governance).  
- [Tally](https://www.withtally.com/): Governance dashboards.  

---

### **5. Scaffold-ETH**  
[Scaffold-ETH](https://github.com/scaffold-eth/scaffold-eth) is a developer framework for building Ethereum apps quickly.  
- Comes with pre-configured Hardhat, React, and ethers.js.  
- Features like hot-reloading and a connected front end.  
- Supports deploying and testing contracts, UI scaffolding, and debugging tools.  

---

### **6. Security Best Practices**
- **Reentrancy Attack Prevention**:  
  Use the **checks-effects-interactions** pattern.  
  ```solidity
  function withdraw() public {
      uint balance = balances[msg.sender];
      require(balance > 0, "No balance");
      balances[msg.sender] = 0; // Effects
      payable(msg.sender).transfer(balance); // Interaction
  }
  ```
- **Access Control**: Use modifiers like `onlyOwner`.  
- **Prevent Overflow**: Use `SafeMath` (built-in from Solidity 0.8).  

---

### **7. Testing and Tools**
- **Hardhat**: Compile, deploy, and test contracts.  
- **Foundry**: Faster and lightweight for testing.  
- **Tools**: Remix, Truffle, ethers.js.  

---

---

### **1. Advanced ERC-20: Gasless Transactions with EIP-2612**
Gasless transactions improve user experience by letting users sign approvals instead of spending gas.  
- **Permit**: ERC-20 tokens implement `permit()` to allow approvals via signatures.  

Example:  
```solidity
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MyToken is ERC20Permit {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}
```  

- **Why it matters**: Users don’t need Ether to interact with dApps, boosting adoption.  

---

### **2. Flash Loans and Arbitrage**
Flash loans allow borrowing large amounts of funds without collateral, provided the loan is repaid in the same transaction.  

Example use case: Arbitrage  
1. Borrow tokens from a lending pool (e.g., Aave).  
2. Buy assets on one exchange where they are cheap.  
3. Sell them on another exchange where they are expensive.  
4. Repay the loan and pocket the profit.  

Libraries like **Aave's FlashLoanReceiverBase** simplify implementation.  

---

### **3. Cross-Chain Bridges**
Cross-chain bridges connect blockchains, enabling token and data transfer between them.  
- **Why important?** Multi-chain ecosystems require seamless communication.  
- **Example bridges**: Wormhole, Connext, and Polygon Bridge.  

Example flow:  
1. Lock tokens on Chain A.  
2. Mint equivalent tokens on Chain B.  
3. Burn/mint when transferring back.  

---

### **4. Account Abstraction (EIP-4337)**
- **Goal**: Improve wallet usability by turning externally owned accounts (EOAs) into smart contract wallets.  
- **Features**:  
  - Gasless transactions using a relayer.  
  - Social recovery of accounts.  
  - Custom verification logic (e.g., multisig).  

Impact: dApps can abstract complexities like paying gas in tokens, onboarding users seamlessly.  

---

### **5. Modular Smart Contracts**
Modular smart contracts make dApps flexible and upgradeable.  
- **Proxy Patterns**: Split contracts into logic and storage layers.  
  - **Transparent Proxy**: Only admin can call upgrade functions.  
  - **UUPS Proxy**: Combines logic and proxy into a single contract for efficiency.  
- **Diamond Standard (EIP-2535)**:  
  Allows contracts to use multiple facets (modular logic). Useful for large-scale systems like marketplaces.  

---

### **6. Real-World DeFi Example: Staking and Rewards**  
A staking contract to reward users based on their token stake:  
```solidity
pragma solidity ^0.8.0;

contract Staking {
    mapping(address => uint) public stakes;
    mapping(address => uint) public rewards;
    uint public rewardRate = 100; // Reward tokens per staked token.

    function stake(uint amount) external {
        stakes[msg.sender] += amount;
    }

    function calculateReward(address user) public view returns (uint) {
        return stakes[user] * rewardRate;
    }

    function claimReward() external {
        uint reward = calculateReward(msg.sender);
        rewards[msg.sender] = reward;
    }
}
```  

---

### **7. Decentralized Identity (DID)**  
Web3 apps are moving towards self-sovereign identity systems using standards like **DID** and **Verifiable Credentials**.  
- **ENS (Ethereum Name Service)**: Map human-readable names (e.g., `alice.eth`) to wallet addresses.  
- **Sign-In with Ethereum**: Enables decentralized authentication via wallet signatures.  

---

### **8. Zero-Knowledge Proofs (ZKPs)**  
ZKPs enable verifying data without revealing it.  
- **Use cases**:  
  - Private voting systems.  
  - Anonymous transactions (e.g., Tornado Cash).  
  - Identity verification without KYC.  

Example frameworks:  
- **zkSync**: Scalable Ethereum layer-2.  
- **Snark.js**: Write ZK circuits in JavaScript.  

---

### **9. AI and Web3 Integration**  
- AI can power:  
  - NFT generation (dynamic art).  
  - Predictive DeFi models (e.g., impermanent loss estimators).  
  - Smart contract auditing (AI-based tools like ChatGPT or CertiK).  

Example: Dynamic NFTs that change appearance based on external AI data (like weather or sports results).  

---

### **10. Building Full-Stack dApps**  
1. **Backend**: Smart contracts (Solidity).  
2. **Frontend**: React + ethers.js or web3.js.  
3. **Middleware**: Indexing services like **The Graph** for querying blockchain data.  
4. **Testing**: Hardhat/Foundry for unit testing.  



## **What is an NFT?**
An **NFT (Non-Fungible Token)** is a digital asset stored on a blockchain. Unlike cryptocurrencies like Bitcoin or Ether, which are **fungible** (interchangeable), NFTs are **unique** and **non-interchangeable**.  

#### **Key Features**:
1. **Uniqueness**: Each NFT has a unique token ID and metadata.
2. **Ownership**: NFTs are owned via blockchain wallets. The blockchain records the ownership history, ensuring transparency.
3. **Indivisibility**: Most NFTs can’t be divided into smaller units like cryptocurrencies can.
4. **Interoperability**: NFTs can be used across multiple platforms (e.g., NFTs in games or metaverses).  

#### **Use Cases**:
- **Art**: Digital paintings or music (e.g., Beeple’s art sold for $69M).  
- **Gaming**: In-game assets like characters or weapons.  
- **Real Estate**: Tokenized representation of property.  
- **Collectibles**: Trading cards or digital memorabilia.  

#### **How NFTs Work**:
1. **Smart Contract Standards**:
   - **ERC-721**: Standard for unique, one-of-a-kind NFTs.
   - **ERC-1155**: Allows creation of both NFTs and fungible tokens (e.g., 100 swords, 1 rare sword).  

2. **Minting Process**:
   - **Minting**: Creating an NFT involves uploading metadata (image, video, etc.) and linking it to a token on the blockchain. This process writes the asset to a smart contract.
   - **Example**:  
     ```solidity
     pragma solidity ^0.8.0;
     import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

     contract MyNFT is ERC721 {
         uint public nextTokenId;
         address public admin;

         constructor() ERC721('MyNFT', 'MNFT') {
             admin = msg.sender;
         }

         function mint(address to) external {
             require(msg.sender == admin, "Only admin can mint");
             _mint(to, nextTokenId);
             nextTokenId++;
         }
     }
     ```
   
3. **Metadata**: The asset’s information (image, description) is usually stored off-chain using systems like IPFS (InterPlanetary File System) for efficiency.  

4. **Buying and Selling**:
   - NFTs are traded on platforms like OpenSea, Blur, or Rarible.
   - Ownership is transferred via blockchain transactions.  

---

### **What is a Liquidity Pool?**
A **Liquidity Pool (LP)** is a collection of funds locked in a smart contract. These pools are used in **decentralized finance (DeFi)** to enable automated trading, lending, and yield farming.  

#### **Why Liquidity Pools Exist**:
- Traditional markets use **order books**: buyers and sellers directly match their prices.
- DeFi replaces this with **Automated Market Makers (AMMs)**, powered by liquidity pools, ensuring there’s always liquidity (i.e., enough tokens to trade).  

#### **How a Liquidity Pool Works**:
1. **Tokens in the Pool**:
   - A pool typically consists of **two tokens** (e.g., ETH and USDC).
   - Liquidity providers (LPs) deposit equal value of both tokens into the pool.

2. **Automated Market Maker (AMM)**:
   - AMMs like **Uniswap** use a formula to determine prices:
     \[
     x \cdot y = k
     \]
     Where:
     - \(x\): Amount of Token A in the pool.
     - \(y\): Amount of Token B in the pool.
     - \(k\): Constant value (remains unchanged).

   - Example:
     - A pool starts with 10 ETH and 20,000 USDC (\(k = 10 \times 20,000 = 200,000\)).
     - If someone buys 1 ETH, they must add USDC to the pool, increasing \(y\) while decreasing \(x\).

3. **Liquidity Providers (LPs)**:
   - LPs earn a share of the trading fees (e.g., 0.3% per trade on Uniswap).
   - LPs also face **impermanent loss**: potential loss compared to holding the tokens outside the pool, due to price fluctuations.  

4. **Slippage**:
   - The bigger the trade, the more it shifts the token price in the pool (based on \(x \cdot y = k\)). This is known as **slippage**.

#### **Real-World Example**:
- Imagine a pool with 1 ETH = 2000 USDC.
- A trader wants to buy ETH:
  - They add 1000 USDC to the pool and withdraw ETH.
  - The new ratio determines the price of ETH.  

#### **Yield Farming and LP Tokens**:
- When LPs add liquidity, they get **LP tokens** representing their share of the pool.
- LP tokens can be staked in other protocols to earn extra rewards.

---

### **Comparison: NFT vs. Liquidity Pool**  
| **Feature**         | **NFT**                                     | **Liquidity Pool**                                   |
|----------------------|---------------------------------------------|----------------------------------------------------|
| **Purpose**          | Represent unique assets.                   | Enable token swaps and provide liquidity.          |
| **Ownership**        | One NFT = One owner.                       | Pool funds shared among all LPs.                  |
| **Earning Potential**| Can be sold for profit (if valuable).       | Earn trading fees and farming rewards.            |
| **Risks**            | Market demand may drop.                    | Impermanent loss and protocol risks.              |

---



**never share your private key** when selling an NFT—or for any reason! Selling an NFT is done securely through a **smart contract on a marketplace** or directly through a **peer-to-peer transfer**. Here's how it works:

---

### **1. Selling an NFT on a Marketplace**
Marketplaces like **OpenSea**, **Blur**, or **Rarible** make selling NFTs simple and secure.

#### **Steps to Sell**:
1. **Connect Your Wallet**:
   - Visit a marketplace.
   - Connect your wallet (e.g., MetaMask, WalletConnect).
   - The wallet signs a message (not a transaction) to authenticate you without exposing your private key.

2. **List the NFT for Sale**:
   - Select the NFT from your wallet.
   - Set a **fixed price** or start an **auction**:
     - **Fixed Price**: Buyers pay the listed amount directly.
     - **Auction**: Buyers bid, and the highest bidder wins.
   - Sign a transaction to approve the NFT for sale.

3. **Transaction Execution**:
   - When someone buys the NFT:
     - The smart contract handles the transfer of the NFT to the buyer and the payment to you.
     - You’ll receive payment (usually in ETH or another token) directly to your wallet.

4. **Transaction Fees**:
   - **Gas Fees**: Paid for the transaction on the blockchain.
   - **Marketplace Fee**: A small percentage (e.g., 2.5% on OpenSea) is deducted from the sale price.

---

### **2. Selling an NFT Peer-to-Peer**
You can sell an NFT directly to another person without using a marketplace. This is less convenient but avoids marketplace fees.

#### **Steps to Sell**:
1. **Negotiate Terms**:
   - Agree on a price with the buyer (in ETH, USDC, or another token).

2. **Transfer the NFT**:
   - Use your wallet (e.g., MetaMask) to send the NFT:
     - Go to the **NFT section** of your wallet.
     - Select the NFT, input the buyer’s wallet address, and click **Transfer**.
     - You’ll pay a small gas fee for this transaction.

3. **Receive Payment**:
   - Ask the buyer to send the agreed payment to your wallet **before transferring the NFT**.  
   - To increase trust, you can use an escrow service or a trusted middleman smart contract.

---

### **3. Behind the Scenes: How It Works**
When selling an NFT, the following happens:
- **Approval**: You approve the marketplace or smart contract to manage your NFT. This allows it to transfer the NFT from your wallet to the buyer.
- **Atomic Swap**: The smart contract ensures that the NFT and payment exchange happen simultaneously.  
  - If the buyer doesn’t pay, the NFT isn’t transferred.  
  - If the NFT transfer fails, the payment is reverted.  

#### Code Example (ERC-721 Transfer):
Here’s what the marketplace or your wallet does when transferring an NFT:
```solidity
IERC721 nftContract = IERC721(nftAddress);
nftContract.safeTransferFrom(seller, buyer, tokenId);
```
This ensures that:
1. The **seller owns the NFT**.
2. The **buyer receives the NFT**.

---

### **4. Security Tips**
- **Never Share Private Keys**: Use your wallet’s interface for transactions. The private key is only for signing internally.
- **Verify Addresses**: Always double-check the buyer’s wallet address before transferring.
- **Use Trusted Marketplaces**: Avoid shady platforms or unknown buyers to prevent scams.
- **Confirm Payment**: For peer-to-peer sales, confirm that the payment has arrived in your wallet before transferring the NFT.

---
Let’s break this down clearly and include the requested **code examples** for **Liquidity Pools (LPs)**, **NFT marketplaces**, and **AMMs**.

---

# **Why NFTs Are Sellable Despite Being Non-Fungible**

Non-fungible means **each NFT is unique**, but ownership is transferable. Selling an NFT doesn’t "interchange" it; instead, the ownership of that unique token is transferred to a buyer.  

For example:  
- **Fungible tokens**: 1 ETH from Alice is interchangeable with 1 ETH from Bob.  
- **Non-fungible tokens**: Alice’s NFT art is uniquely identified by its token ID (e.g., `#1234`). When sold, token `#1234` is **transferred**, not swapped for another NFT.  

---

### **Code Example 1: Simple NFT Marketplace**
A smart contract that allows listing and buying NFTs (ERC-721).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace {
    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;

    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external {
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(nft.isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");

        listings[nftAddress][tokenId] = Listing(msg.sender, price);
    }

    function buyNFT(address nftAddress, uint256 tokenId) external payable {
        Listing memory listing = listings[nftAddress][tokenId];
        require(msg.value == listing.price, "Incorrect payment");

        delete listings[nftAddress][tokenId];
        payable(listing.seller).transfer(msg.value);

        IERC721(nftAddress).safeTransferFrom(listing.seller, msg.sender, tokenId);
    }
}
```

**How It Works**:  
1. Owners list their NFTs with a price.  
2. Buyers pay the exact price to purchase the NFT.  
3. Ownership is transferred programmatically.  

---

### **Code Example 2: Liquidity Pool (Simplified AMM)**
A basic implementation of a liquidity pool with **token swapping** using Uniswap’s \( x \cdot y = k \) formula.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLiquidityPool {
    uint256 public tokenXBalance;
    uint256 public tokenYBalance;
    uint256 public constant FEE_PERCENT = 3; // 0.3% fee

    function addLiquidity(uint256 tokenXAmount, uint256 tokenYAmount) external {
        tokenXBalance += tokenXAmount;
        tokenYBalance += tokenYAmount;
    }

    function swapXForY(uint256 tokenXAmount) external returns (uint256) {
        uint256 tokenYOut = getAmountOut(tokenXAmount, tokenXBalance, tokenYBalance);
        tokenXBalance += tokenXAmount;
        tokenYBalance -= tokenYOut;
        return tokenYOut;
    }

    function getAmountOut(uint256 inputAmount, uint256 inputReserve, uint256 outputReserve) public pure returns (uint256) {
        uint256 inputAmountWithFee = inputAmount * (1000 - FEE_PERCENT);
        return (inputAmountWithFee * outputReserve) / (inputReserve * 1000 + inputAmountWithFee);
    }
}
```

**How It Works**:  
1. **Liquidity Providers** add equal amounts of Token X and Token Y to the pool.  
2. **Swapping** allows users to trade Token X for Token Y, adjusting the reserves while preserving \( x \cdot y = k \).  
3. A **fee** incentivizes liquidity providers.  

---

### **Code Example 3: Automated Market Maker (AMM)**
A more comprehensive AMM that supports token deposits, swaps, and LP tokens.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AMM {
    IERC20 public tokenX;
    IERC20 public tokenY;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    constructor(address _tokenX, address _tokenY) {
        tokenX = IERC20(_tokenX);
        tokenY = IERC20(_tokenY);
    }

    function addLiquidity(uint256 tokenXAmount, uint256 tokenYAmount) external {
        tokenX.transferFrom(msg.sender, address(this), tokenXAmount);
        tokenY.transferFrom(msg.sender, address(this), tokenYAmount);

        uint256 liquidityMinted = tokenXAmount; // Simplified
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;
    }

    function swapXForY(uint256 tokenXAmount) external {
        uint256 tokenYOut = getAmountOut(tokenXAmount, tokenX.balanceOf(address(this)), tokenY.balanceOf(address(this)));

        tokenX.transferFrom(msg.sender, address(this), tokenXAmount);
        tokenY.transfer(msg.sender, tokenYOut);
    }

    function getAmountOut(uint256 inputAmount, uint256 inputReserve, uint256 outputReserve) internal pure returns (uint256) {
        uint256 inputAmountWithFee = inputAmount * 997; // 0.3% fee
        return (inputAmountWithFee * outputReserve) / (inputReserve * 1000 + inputAmountWithFee);
    }
}
```

**How It Works**:  
- Liquidity providers deposit tokens to earn LP tokens representing their share.  
- Swaps use the **Uniswap-like formula** and adjust token reserves.  
- LP tokens can be burned to withdraw liquidity later.  

---

### **Key Concepts Recap**
- **NFTs**: Unique assets traded by transferring ownership. Selling doesn’t interchange but transfers the token.  
- **Liquidity Pools**: Allow token swaps by balancing reserves using \( x \cdot y = k \). LPs earn fees as incentives.  
- **AMMs**: Smart contracts enabling decentralized token swaps without order books.  
