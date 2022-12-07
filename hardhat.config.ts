import "dotenv/config"
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    mumbai:{
      url:process.env.MUMBAI_RPC,
      accounts:[process.env.PRIVATE_KEY || ""]
    }
  }
};

export default config;
