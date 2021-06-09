// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {
    ISuperfluid,
    ISuperToken
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {
    IConstantFlowAgreementV1
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";


/**
 * A simple stream sender contract for live Superfluid demo
 */
contract StreamSender {

    event NewClaim(address recipient, int96 flowRate);

    // Superfluid framework addresses: https://docs.superfluid.finance/superfluid/networks/networks
    ISuperfluid public immutable host;
    IConstantFlowAgreementV1 public immutable cfa;
    // Pick a super token to be used
    ISuperToken public immutable token;
    // Fixed flow rate for the participant
    int96 internal immutable flowRate;

    mapping(address => bool) private _recipients;

    constructor(
        ISuperfluid _host,
        IConstantFlowAgreementV1 _cfa,
        ISuperToken _token,
        int96 _flowRate
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
        flowRate = _flowRate;
    }

    function claim(address recipient) external {
        require(!_recipients[recipient], "StreamSender: Already claimed");
        _recipients[recipient] = true;
        // send some gas token
        this.send(recipient, 1e17 /* 0.1 */);
        // send a flow
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
}
