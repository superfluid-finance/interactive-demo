const ethers = require("ethers");

exports.handler = async function(event, context) {
  const { ADMIN_PRIVATE_KEY, XDAI_PROVIDER_URL } = process.env;
  const provider = new ethers.providers.JsonRpcProvider(XDAI_PROVIDER_URL);
  const wallet = new ethers.Wallet(ADMIN_PRIVATE_KEY);
  return {
    statusCode: 200,
    body: JSON.stringify({
      balance: (await provider.getBalance(wallet.address)).toString(),
    }),
  };
};
