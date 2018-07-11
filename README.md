# Audit of Spitball Project smart-contracts

## Install
- Create a directory for project
```mkdir spitball```
- Clone the repository to your local file system 
```git clone https://github.com/el3ktron/SBAudit.git spitball```
- Move to the directory
```cd spitball```
- Resolve all NPM dependencies
```npm install```

## Description

### Contracts

1. SafeMath - library for safe and low-cost math operations
2. IData - interface for ERC865 data management
3. ERC865Database - contract for managing token access and signatures
4. ERC865 - wrapper for ERC865 standard
5. ERC865Token - full implementation of mintable and pausable ERC865
6. Crowdsale - contract for token distribution (sale)
7. SpitballToken - token supply for Crowdsale based on ERC865Token

### Tested smart-contracts

1. ERC865
2. IData
3. ERC865Database
4. ERC865Token
5. SpitballToken
6. Crowdsale

### How to run test

To run test you'll need a "ganache-cli" or "Ganache Electron App"

- To install ```ganache-cli``` you simply need to run ```npm install -g ganache-cli```
- To install ```Ganache Electron App``` you need to install and customize app from the link
Source: ```https://github.com/trufflesuite/ganache/releases```

Ganache Electron App customizing: 
1. Open settings
2. Select 'Server' button
3. Do the following changes:
  - hostname ```127.0.0.1 - lo0```
  - port number ```7545```
  - network id ```5777```
4. Select 'Accounts & Keys' button
5. Do the following changes:
  - account default balance ```1000000000000000```
  - total accounts to generate ```10```
6. Click 'Restart' button

To start test you need to change the accounts private keys in ```test/Token.test.js::29:1``` and ```test/Token.test.js::30:1``` to yours. If you're using ganache-cli all that you need:
 - ```npm run rpc```
 - copy (0) and (3) account private keys for 'alicePrivateKey' and 'damiensPrivateKey' relatively
 - ```npm run test```
 
 
To start test with use of Ganache Electron App you need to copy private key of 1 and 4 account from default app page listing, changing the values of the same variables and start ```npm run test``` command.










