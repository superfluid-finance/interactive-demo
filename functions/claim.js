const ABI = require("../contracts/abi/StreamSender.json");
const ethers = require("ethers");

exports.handler = async function(event, context) {
  try {
    const { ADMIN_PRIVATE_KEY, PROVIDER_URL, SS_ADDRESS } = process.env;
    const body = JSON.parse(event.body);
    const provider = new ethers.providers.JsonRpcProvider(PROVIDER_URL);
    const wallet = new ethers.Wallet(ADMIN_PRIVATE_KEY);
    const ss = new ethers.Contract(SS_ADDRESS, ABI, wallet.connect(provider));
    const tx = await ss.claim(body.address, {
      gasPrice: 1000e6,
    });
    console.log(tx);
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        body: JSON.stringify({
          status: 202,
          tx,
        }),
      }),
    };
  } catch (e) {
    console.log(e);
    return {
      statusCode: 400,
      body: JSON.stringify({
        status: 400,
        error: e.toString(),
      }),
    };
  }
};
