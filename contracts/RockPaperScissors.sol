pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RockPaperScissors {
    address player;
    address opponent;
    uint256 public entranceFee;
    address public token;

    mapping(address => Game[]) private games;
    mapping(address => uint256) public rewards;

    event RewardLog(address indexed, uint256 amount, string message);

    event Log(
        address indexed challenger,
        address indexed opponent,
        string message
    );

    enum Status {
        Playing,
        Challenger,
        Opponent,
        Tie
    }

    struct Game {
        Status status;
        uint8 move1;
        uint8 move2;
        address challenger;
        address opponent;
        uint256 jackpot;
    }

    constructor(uint256 _entranceFee, address _token) {
        entranceFee = _entranceFee;
        token = _token;
    }

    // Start a game by depositing the enrollment fee, choosing your opponent and specifying your move
    // 0 = Rock
    // 1 = Paper
    // 2 = Scissors

    function startGame(
        uint256 _amount,
        address _opponent,
        uint8 _move
    ) public {
        require(_amount >= entranceFee, "fee to low");
        (bool isChallenged, uint256 index) = isChallengedMethod(
            msg.sender,
            _opponent
        );
        require(
            isChallenged == false,
            "Already challenged this player to a game"
        );
        require(
            _move == 0 || _move == 1 || _move == 2,
            "move hast to be 0=Rock, 1=Paper, 2=Scissors"
        );
        IERC20(token).transferFrom(msg.sender, address(this), _amount);
        games[msg.sender].push(
            Game({
                move1: _move,
                move2: 5,
                status: Status.Playing,
                challenger: msg.sender,
                opponent: _opponent,
                jackpot: _amount
            })
        );
        emit Log(msg.sender, _opponent, "game created");
    }

    // Soneone Challanged you to a game, play by depositing the enrollment fee, providing the Challengers address and specifying your move
    // 0 = Rock
    // 1 = Paper
    // 2 = Scissors

    function opponentMove(
        uint256 _amount,
        address _challenger,
        uint8 _move
    ) public {
        require(_amount >= entranceFee, "fee to low");
        (bool isChallenged, uint256 index) = isChallengedMethod(
            _challenger,
            msg.sender
        );
        require(isChallenged == true, "Player did not challenge you to a game");
        require(
            games[msg.sender][index].status == Status.Playing,
            "Game already over"
        );
        require(
            _move == 0 || _move == 1 || _move == 2,
            "move hast to be 0=Rock, 1=Paper, 2=Scissors"
        );
        IERC20(token).transferFrom(msg.sender, address(this), _amount);

        games[msg.sender][index].move2 = _move;
        games[msg.sender][index].jackpot = _amount;

        Status gameStatus = logic(games[msg.sender][index].move1, _move);

        uint256 price = games[msg.sender][index].jackpot + _amount;

        if (gameStatus == Status.Tie) {
            rewards[_challenger] =
                rewards[_challenger] +
                games[_challenger][index].jackpot;
            rewards[msg.sender] = rewards[msg.sender] + _amount;
            emit Log(_challenger, msg.sender, "Its a Tie");
        } else if (gameStatus == Status.Challenger) {
            rewards[_challenger] = rewards[_challenger] + price;
            emit Log(_challenger, msg.sender, "Challenger Won the Game");
        } else {
            rewards[msg.sender] = rewards[msg.sender] + price;
            emit Log(_challenger, msg.sender, "Challenger lost the Game");
        }
        games[msg.sender][index].status = gameStatus;
    }

    function claimReward() public {
        require(rewards[msg.sender] > 0, "no rewards");
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        IERC20(token).transferFrom(address(this), msg.sender, reward);
        emit RewardLog(msg.sender, rewards[msg.sender], "Reward claimed");
    }

    function isChallengedMethod(address _challenger, address _opponent)
        internal
        view
        returns (bool, uint256)
    {
        bool isChallenged = false;
        uint256 index = 0;
        for (uint256 i = 0; i < games[_challenger].length; i++) {
            if (games[_challenger][i].opponent == _opponent) {
                isChallenged = true;
                index = i;
                return (isChallenged, index);
            }
        }
        return (isChallenged, index);
    }

    function logic(uint8 _challenger, uint8 _opponent)
        internal
        pure
        returns (Status)
    {
        Status gameStatus;
        if (_challenger == _opponent) {
            gameStatus = Status.Tie;
            return gameStatus;
        } else if (
            (_challenger == 0 && _opponent == 2) ||
            (_challenger == 1 && _opponent == 0) ||
            (_challenger == 2 && _opponent == 1)
        ) {
            gameStatus = Status.Challenger;
            return gameStatus;
        } else {
            gameStatus = Status.Opponent;
            return gameStatus;
        }
    }
    // submit their unique move
    // contract decieds who won

    // Stretch Goals
    // Include any tests using Hardhat
    // anyone 2 player can play against each other
    // reduce gas cost
    // Let players bet their previous winnings.
    // How can you entice players to play, knowing that they may have their funds stuck in the contract if they face an uncooperative player?
}
