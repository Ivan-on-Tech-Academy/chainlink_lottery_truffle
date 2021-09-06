pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is VRFConsumerBase, Ownable{
    using SafeMathChainlink for uint256;
    enum LOTTERY_STATE{OPEN, CLOSED, CALCULATING_WINNER}
    LOTTERY_STATE public lotteryState;
    AggregatorV3Interface internal ethUsdPriceFeed;
    uint256 public usdEntryFee;
    address public recentWinner;
    address payable[] public players;
    uint256 public randomness;
    uint256 public fee;
    bytes32 public KeyHash;

    event RequestedRandomness(bytes32 requestId);

    constructor(address _ethUsdPriceFeed, address _vrfCoordinator, address _link, bytes32 _keyHash) 
        VRFConsumerBase(
            _vrfCoordinator,
            _link
        )
        public{

        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed);
        usdEntryFee = 50; //$
        lotteryState = LOTTERY_STATE.CLOSED;
        fee = 100000000000000000; //0.1 LINK
        KeyHash = _keyHash;

    }

    function enter() public payable{
        require(msg.value >= getEntranceFee(), "Not Enough ETH to enter!");
        require(lotteryState == LOTTERY_STATE.OPEN, "Can't end lottery yet");
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns(uint256){
        uint256 precision = 1 * 10 ** 18;
        uint256 price = getLastestEthUsdPrice();
        uint256 costToEnter = (precision / price) * (usdEntryFee * 100000000);
        return costToEnter;
    }

    function getLastestEthUsdPrice() public view returns(uint256){
        (
            uint80 roundId,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = ethUsdPriceFeed.latestRoundData();

        return uint256(price);
    }

    function startLottery() public onlyOwner{
        require(lotteryState == LOTTERY_STATE.CLOSED, "Can't start a new lottery");
        lotteryState = LOTTERY_STATE.OPEN;
        randomness = 0;
    }

    function endLottery() public{
        require(lotteryState == LOTTERY_STATE.OPEN, "Can't end lottery yet");
        lotteryState = LOTTERY_STATE.CALCULATING_WINNER;
        pickWinner();
        
    }

    function pickWinner() private returns(bytes32){
        require(lotteryState == LOTTERY_STATE.CALCULATING_WINNER, "Needs to be calculating the winner");
        bytes32 requestId = requestRandomness(KeyHash, fee);
        emit RequestedRandomness(requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override{
        require(randomness > 0, "random number not found");
        uint256 index = randomness % players.length;
        players[index].transfer(address(this).balance);
        recentWinner = players[index];
        players = new address payable[](0);
        lotteryState = LOTTERY_STATE.CLOSED;
        randomness = randomness;
    }
}
