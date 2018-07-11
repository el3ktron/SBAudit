const helpers = require('./helpers');
const ethUtil = require('ethereumjs-util')
const should =  helpers.should;
const duration = helpers.duration;
const latestTime = helpers.latestTime;
const BigNumber = helpers.BigNumber;
const timeTravelTo = helpers.timeTravelTo;
const EVMThrow = helpers.EVMThrow;
const ether = helpers.ether;
const buyTokens = helpers.buyTokens;
const advanceBlock = helpers.advanceBlock;


const QandA = artifacts.require('./../contracts/QandA.sol');
const SpitballToken = artifacts.require("./../contracts/SpitballToken.sol");
const Database = artifacts.require("./../contracts/ERC865Database.sol");


const formattedAddress = (address) => {
  return  Buffer.from(ethUtil.stripHexPrefix(address), 'hex');
};
const formattedInt = (int) => {
  return ethUtil.setLengthLeft(int, 32);
};
const formattedBytes32 = (bytes) => {
  return ethUtil.addHexPrefix(bytes.toString('hex'));
};
const hashedTightPacked = (args) => {
  return ethUtil.sha3(Buffer.concat(args));
};


contract('QandA', ([alice, bob, charlie, damiens, owner]) => {
	let database, token, qa, tokenToMint;

  before(async () => {
    await advanceBlock()
  })


  beforeEach(async () => {
    database = await Database.new({from: owner});
    token = await SpitballToken.new(database.address, {from: owner});
    qa = await QandA.new(token.address, {from: owner});

    tokenToMint = (await database.amountOfTokenToMint()).toNumber() / 2;
    await token.mint(qa.address, tokenToMint, {from: owner});
  });


  // describe('When considering QandA should accept questions and answers', () => {

  // 	beforeEach(async () => {
  // 		await token.mint(alice, 200, {from: owner});
  // 		await token.mint(bob, 200, {from: owner});
  // 		await token.mint(charlie, 200, {from: owner});
  // 	});

		// it('should submit new question and add it data to mapping' , async () => {
		// 	const questionId = 1;
  // 		const price = 100;
  // 		const submiterAddress = alice;
  // 		const bobAnswerId = 1;
  // 		const charlieAnswerId = 2;
  // 		const winner = bob;


		// 	await qa.submitNewQuestion(questionId, price, alice, {from: bob});
		// 	// const alicePrevBalance = (await token.balanceOf(alice)).toNumber();
		// 	// const question = await qa.id.call(questionId);
		// 	// const allowance = (await token.allowance(qa.address, alice)).toNumber();
		// 	// const aliceCurrentBalance = (await token.balanceOf(alice)).toNumber();
			
		// 	// aliceCurrentBalance.should.be.equal(alicePrevBalance + price);

		// });
  // });
});