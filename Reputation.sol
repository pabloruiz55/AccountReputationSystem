pragma solidity 0.4.19;

contract Reputation {
    
    struct Feedback {
        uint score;
        bool isPositiveFeedback;
        bool isNeutralFeedback;
        bool isNegativeFeedback;
        uint date;
        string message;
        address submittedBy;
    }
    
    // Feedback for an account => provided by another account
    mapping (address => mapping (address => Feedback)) public feedbacks;
    
    // Every Feedback for an account
    mapping (address => Feedback[]) public feedbackReceived;
    
    // Every Feedback given by an account
    mapping (address => Feedback[]) public feedbackGiven;
    
    mapping (address => uint) public negativeCount;
    mapping (address => uint) public neutralCount;
    mapping (address => uint) public positiveCount;
    
    mapping (address => uint) public totalCount;
    mapping (address => uint) public scoreSum;
    
    event SubmitFeedback(address indexed _from, address indexed _to, uint indexed date, uint _score,string _message);
    
    function submitFeedback(address _account, uint _score, string _message) public {
        require(_score >=0 && _score <= 10);
        require(_account != address(0));
        require(_account != msg.sender);
        require(feedbacks[_account][msg.sender].date == 0); // Only allow one feedback per account
        
        feedbacks[_account][msg.sender].score = _score;
        feedbacks[_account][msg.sender].date = now;
        feedbacks[_account][msg.sender].message = _message;
        feedbacks[_account][msg.sender].submittedBy = msg.sender;
        
        // Scoring ranges based on Net Promoter Score
        if(_score >= 0 && _score<=6){
            feedbacks[_account][msg.sender].isNegativeFeedback = true;
            negativeCount[_account]++;
        }
        else if(_score >= 7 && _score<=8){
            feedbacks[_account][msg.sender].isNeutralFeedback = true; 
            neutralCount[_account]++;
        }
        else if(_score >= 9 && _score<=10){
            feedbacks[_account][msg.sender].isPositiveFeedback = true;
            positiveCount[_account]++;
        }
            
        totalCount[_account]++;  
        scoreSum[_account] += _score;
        
        feedbackReceived[_account].push(feedbacks[_account][msg.sender]);
        feedbackGiven[msg.sender].push(feedbacks[_account][msg.sender]);
        
        SubmitFeedback(msg.sender, _account,now, _score, _message);
    }
    
    function getNegativeRatio(address _account) view public returns (uint) {
        return (negativeCount[_account] * 100 / totalCount[_account]);
    }
    
    function getNeutralRatio(address _account) view public returns (uint) {
        return (neutralCount[_account] * 100 / totalCount[_account]);
    }
    
    function getPositiveRatio(address _account) view public returns (uint) {
        return (positiveCount[_account] * 100 / totalCount[_account]);
    }
    
    function getScoreAverage(address _account) view public returns (uint) {
        return (scoreSum[_account] / totalCount[_account]);
    }
}
