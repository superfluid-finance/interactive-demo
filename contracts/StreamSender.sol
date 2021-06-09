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

    event NewClaim(address recipient, int96 flowRate);

    ISuperfluid public immutable host;
    IConstantFlowAgreementV1 public immutable cfa;
    ISuperToken public immutable token;
    int96 public immutable maxFlow;
    int96 internal _lastFlow;

    mapping(address => bool) private _recipients;

    constructor(
        ISuperfluid _host,
        IConstantFlowAgreementV1 _cfa,
        ISuperToken _token,
        int96 _maxFlow
    )
    {
        require(address(_host) != address(0), "SSender: host is empty");
        require(address(_cfa) != address(0), "SSender: cfa is empty");
        require(
            address(_token) != address(0),
            "SSender: superToken is empty"
        );
        require(_maxFlow > 0, "SSender: maxFlow");

        host = _host;
        cfa = _cfa;
        token = _token;
        maxFlow = _maxFlow;
    }

    function claim(address recipient) external {
        require(!_recipients[recipient], "SSender: Already claim");
        _recipients[recipient] = true;
        if(_lastFlow == 0) {
            _lastFlow = maxFlow;
        } else {
            _lastFlow /= 2;
            require(_lastFlow > 0, "SSender: no more money to send");
        }
        host.callAgreement(
            cfa,
            abi.encodeWithSelector(
                cfa.createFlow.selector,
                token,
                recipient,
                _lastFlow,
                new bytes(0)
            ),
            "0x"
        );

        emit NewClaim(recipient, _lastFlow);
    }
}
