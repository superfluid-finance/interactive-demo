// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {
    ISuperfluid,
    ISuperToken
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {
    IConstantFlowAgreementV1
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";


contract StreamSender {

    event NewClaim(address recipient, uint96 flowRate);

    ISuperfluid public immutable host;
    IConstantFlowAgreementV1 public immutable cfa;
    ISuperToken public immutable token;

    mapping(address => bool) private _recipients;
    uint256 private _counter;

    constructor(
        ISuperfluid _host,
        IConstantFlowAgreementV1 _cfa,
        ISuperToken _token
    )
    {
        require(address(_host) != address(0), "SSender: host is empty");
        require(address(_cfa) != address(0), "SSender: cfa is empty");
        require(
            address(_token) != address(0),
            "SSender: superToken is empty"
        );

        host = _host;
        ca = _cfa;
        token = _token;
    }

    function claim(address recipient) external {
        require(!_recipients[recipient], "SSender: Already claim");

        _recipients[recipient] = true;
        _counter++;

        int96 flowRate = _getAmount();
        host.callAgreement(
            cfa,
            abi.encodeWithSelector(
                cfa.createFlow.selector,
                token,
                recipient,
                flowRate,
                new bytes(0)
            ),
            "0x"
        );

        emit NewClaim(recipient, flowRate);
    }

    function _getAmount() internal view returns(int96 flowRate) {
        //TOOD: Define distribuion scheme
        return 1;
    }
}
