pragma solidity ^0.4.20;

import "./SpitballToken.sol";
    
contract QAndA {
   
  struct QuestionData {
    uint256 price;
    address qOwner;
    uint256 answerCounter;
    uint256 totalUpVotes;
    mapping (string => AnswersData) answers;
    mapping (uint => string) answersIndex; 
  }
  
  struct AnswersData {
    string aid;
    address Address;
    address[] upVoteAddr;
  }

  
  mapping (address => uint256) public balanceOf;
  mapping (uint256 => QuestionData) id;
 

  SpitballToken public tokenReward;
  
   
  event AnswerAccepted(address indexed from, address indexed to, uint256 value);
  event NewAnswer (string answerId);
  
  constructor 
  (
    address _addressOfTokenUsedAsReward
  ) 
    public 
  {
    tokenReward = SpitballToken(_addressOfTokenUsedAsReward);
  }


  function destroy(uint256 _qId) private {  
    for(uint i = 0; i < id[_qId].answerCounter;i++) {

      for(uint j = 0; j < id[_qId].answers[id[_qId].answersIndex[i]].upVoteAddr.length; j++) {
        delete(id[_qId].answers[id[_qId].answersIndex[i]].upVoteAddr[j]);
      }

      delete(id[_qId].answers[id[_qId].answersIndex[i]]);
    }

    delete(id[_qId]);
  }

  
  /*
   * @param userAddress address of person who is posting question
   */
  function submitNewQuestion 
  (
    uint256 _qId, 
    uint256 _price, 
    address userAddress
  )  
    public 
  {
    QuestionData memory data = QuestionData(_price, userAddress, 0, 0);
    id[_qId] = data;
    tokenReward.approve(userAddress, _price);
    tokenReward.transferFrom(userAddress, address(this), _price);
    balanceOf[userAddress] = SafeMath.add(balanceOf[userAddress], _price);
  }
  

  function submitNewAnswer 
  (
    uint256 _qId, 
    address submiterAddress, 
    string _answerId
  ) 
    public 
  {   
    require(id[_qId].price > 0);
    address[] memory tempUpVote = new address[](0);
    AnswersData memory data = AnswersData(_answerId, submiterAddress, tempUpVote);
    id[_qId].answers[_answerId] = data;
    id[_qId].answerCounter = SafeMath.add(1, id[_qId].answerCounter);
    emit NewAnswer(_answerId);
  }
  
  
  function approveAnswer
  (
    uint256 _qId, 
    string _answerId, 
    address _winner, 
    address submiterAddress
  ) 
    public 
  {
    require(submiterAddress == id[_qId].qOwner);
    require(id[_qId].answers[_answerId].Address == _winner);
    tokenReward.transfer(_winner, id[_qId].price);
    balanceOf[submiterAddress] = SafeMath.sub(balanceOf[submiterAddress], id[_qId].price);
    
    if(id[_qId].answers[_answerId].upVoteAddr.length > 0) {
      for(uint256 i  =0; i < id[_qId].answers[_answerId].upVoteAddr.length; i++) {  
        tokenReward.transfer(
            id[_qId].answers[_answerId].upVoteAddr[i], SafeMath.mul(
              SafeMath.mul(
                SafeMath.div(
                  id[_qId].totalUpVotes, id[_qId].answers[_answerId].upVoteAddr.length
                ), 
                SafeMath.div(id[_qId].price,2)
              ), 
              10**18
            )
        );
         
        balanceOf[submiterAddress] = SafeMath.sub(balanceOf[id[_qId].answers[_answerId].upVoteAddr[i]], id[_qId].price);
      }
    }
    
    destroy(_qId); 
  }
  

  function returnFoundsToUser (uint256 _qId) public {
    tokenReward.transfer(msg.sender, id[_qId].price);
    balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], id[_qId].price);
    destroy(_qId); // nedd to see if working
  }
  

  function spreadFounds (uint256 _qId) public {
    for (uint i = 0; i < id[_qId].answerCounter;i++) {
      for (uint j = 0; j < id[_qId].answers[id[_qId].answersIndex[i]].upVoteAddr.length; j++) {
        if(id[_qId].answers[id[_qId].answersIndex[i]].upVoteAddr.length > 0) {
          uint256 amount = SafeMath.mul(SafeMath.div(id[_qId].answers[id[_qId].answersIndex[i]].upVoteAddr.length, id[_qId].answerCounter), id[_qId].price);
          tokenReward.transfer(msg.sender, amount);
        }
      }
    }
  }
  

  function upVote (uint256 _qId, string _answerId, address userAddress) public {
    uint256 value = SafeMath.div(id[_qId].price,2);
    require(keccak256(id[_qId].answers[_answerId].aid) == keccak256(_answerId));
    require(id[_qId].answers[_answerId].Address != userAddress);
        
    id[_qId].answers[_answerId].upVoteAddr.push(userAddress);
    id[_qId].totalUpVotes = SafeMath.add(id[_qId].totalUpVotes, 1);
    tokenReward.approve(userAddress, value);
    tokenReward.transferFrom(userAddress, address(this), value);
    balanceOf[userAddress] = SafeMath.add(balanceOf[userAddress], value);
  }
  
  
  function returnUpVoteList (uint256 _qId, string _answerId) public view returns (bytes32[] memory a){
    bytes32[] memory addresses = new bytes32[](id[_qId].answers[_answerId].upVoteAddr.length);
      for(uint256 i = 0; i < id[_qId].answers[_answerId].upVoteAddr.length; i++){
        addresses[i] = bytes32(id[_qId].answers[_answerId].upVoteAddr[i]);
    }
    return addresses;
  }
}