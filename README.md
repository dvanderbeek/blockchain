# Project Summary
This proof-of-concept blockchain app demonstrates a streamlined approach to blockchain transaction tracking and API design. The core objectives are:

## Simplified API Design:
The application exposes a minimal set of well-structured endpoints, ensuring a consistent and intuitive experience for API consumers and UI developers.

## Minimal Code for Multi-Protocol Support:
By abstracting common transaction tracking logic, the codebase reduces duplication and complexity, making it easy to add support for new blockchains with minimal effort.

## Raw Data as Source of Truth:
All raw blockchain transaction data is stored and preserved, allowing the system to reference the original data for validation, auditing, and future-proofing against changes in blockchain protocols.

## Normalized Transaction Format:
Transaction details from various blockchains are normalized into a unified schema, enabling consistent display and processing across the API and user interfaces, regardless of the underlying blockchain.

## Solana Example: Separation of Fetching and Parsing
The Solana integration illustrates a clear separation of concerns:

- Fetching raw blockchain data is handled by the TransactionInfo and TransactionStatus classes, which are responsible solely for retrieving data from the Solana blockchain.

- Parsing, identifying, and normalizing that data is handled by the Solana::Transaction class, which takes the raw data and exposes a standardized interface for the rest of the app.

### Benefits:
This separation makes the logic easy to test in isolation—parsing and normalization can be unit tested with static data, without requiring live API calls to the blockchain. This leads to more reliable, faster, and deterministic tests.

flowchart TD
  A["API Request: Create/Track Transaction"] --> B["Blockchain::Transaction Model"]
  B --> C["fetch_onchain_data"]
  C --> D1["Solana::TransactionInfo (fetch raw data)"]
  C --> D2["Solana::TransactionStatus (fetch status)"]
  D1 --> E1["Store raw onchain_info"]
  D2 --> E2["Store raw onchain_status"]
  B --> F["onchain_tx (Solana::Transaction)"]
  F --> G["Parse & Normalize Data"]
  G --> H["Expose Standardized Info to API/UI"]
  B --> I["TransactionTrackingJob (background)"]
  I -->|"retries until confirmed"| B
