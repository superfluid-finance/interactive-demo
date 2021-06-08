import React, { useState } from "react";

import styled from "styled-components";

import "./App.css";

function App() {
  const [address, setAddress] = useState();

  function claim() {
    if (address) {
      console.log("claiming stream for address", address);
      fetch("/.netlify/functions/claim", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          address,
        }),
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            console.log(data);
          } else {
            alert(data.reason);
          }
        });
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <img src="gifs/start_streaming.gif" className="App-logo" alt="logo" />
        <h1>Claim a Superfluid Stream of Money on xDAI</h1>
        <InstructionList>
          <li>
            Visit{" "}
            <a
              className="App-link"
              href="https://app.superfluid.finance/"
              target="_blank"
              rel="noopener noreferrer"
            >
              Superfluid App
            </a>
          </li>
          <li>Select Portis -> xDAI Mainnet</li>
          <li>Follow Portis onboarding process to register an account</li>
          <li>
            Your account address:{" "}
            <AddressInput
              onChange={e => setAddress(e.target.value)}
              type="text"
              size="42"
            />
            <Button onClick={claim}>Claim</Button>
          </li>
        </InstructionList>
      </header>
    </div>
  );
}

export default App;

const InstructionList = styled.ol`
  text-align: left;
  padding: 10px 60px;
  margin: 0px 10px 0px !important;
`;

const AddressInput = styled.input`
  font-size: 24px;
  margin: 0px 10px 0px;
`;

const Button = styled.button`
  background-color: black;
  color: white;
  font-size: 24px;
  border-radius: 5px;
  margin: 0px 10px 0px;
  cursor: pointer;
`;
