const ethers = require("ethers");

exports.handler = async function(event, context) {
  const {
    ADMIN_PRIVATE_KEY,
    GOERLI_PROVIDER_URL,
    XDAI_PROVIDER_URL,
  } = process.env;
  const body = JSON.parse(event.body);
  const provider = new ethers.providers.JsonRpcProvider(XDAI_PROVIDER_URL);
  const wallet = new ethers.Wallet(ADMIN_PRIVATE_KEY);
  return {
    statusCode: 200,
    body: JSON.stringify({
      success: true,
      balance: (await provider.getBalance(body.address)).toString(),
    }),
  };
};
