require 'spec_helper'

describe Eth::Chain do
  describe "#CHAIN_ID" do
    it "has EIP155 chain ids for mainnets, testnets, and devnets" do
      # Chain IDs for selected mainnets
      expect(Eth::Chain::ETHEREUM).to eq 1
      expect(Eth::Chain::EXPANSE).to eq 2
      expect(Eth::Chain::OPTIMISM).to eq 10
      expect(Eth::Chain::CLASSIC).to eq 61
      expect(Eth::Chain::POA_NET).to eq 99
      expect(Eth::Chain::XDAI).to eq 100
      expect(Eth::Chain::ARBITRUM).to eq 42161

      # Chain IDs for selected testnets
      expect(Eth::Chain::MORDEN).to eq 2
      expect(Eth::Chain::ROPSTEN).to eq 3
      expect(Eth::Chain::RINKEBY).to eq 4
      expect(Eth::Chain::GOERLI).to eq 5
      expect(Eth::Chain::KOTTI).to eq 6
      expect(Eth::Chain::KOVAN).to eq 42
      expect(Eth::Chain::MORDEN_CLASSIC).to eq 62
      expect(Eth::Chain::MORDOR).to eq 63
      expect(Eth::Chain::KOVAN_OPTIMISM).to eq 69
      expect(Eth::Chain::XDAI_ARBITRUM).to eq 200
      expect(Eth::Chain::GOERLI_OPTIMISM).to eq 420
      expect(Eth::Chain::RINKEBY_ARBITRUM).to eq 421611

      # Chain IDs for selected private networks
      expect(Eth::Chain::PRIVATE_GETH).to eq 1337
    end
  end

  describe ".is_legacy" do
    it "can detect legacy values for v" do
      expect(Eth::Chain.is_legacy? 0).not_to be_truthy
      expect(Eth::Chain.is_legacy? 1).not_to be_truthy
      expect(Eth::Chain.is_legacy? 27).to be_truthy
      expect(Eth::Chain.is_legacy? 28).to be_truthy
      expect(Eth::Chain.is_legacy? 37).not_to be_truthy
      expect(Eth::Chain.is_legacy? 38).not_to be_truthy
    end
  end

  describe ".to_v .to_recovery_id" do
    it "can convert ethereum recovery ids to v" do
      expect(Eth::Chain.to_v 0).to be 37
      expect(Eth::Chain.to_v 1).to be 38
    end
    it "can convert other chain's recovery ids to v" do
      expect(Eth::Chain.to_v 0, Eth::Chain::CLASSIC).to be 157
      expect(Eth::Chain.to_v 1, Eth::Chain::XDAI).to be 236
      expect(Eth::Chain.to_v 0, Eth::Chain::ARBITRUM).to be 84357
      expect(Eth::Chain.to_v 1, Eth::Chain::MORDEN_CLASSIC).to be 160
      expect(Eth::Chain.to_v 0, Eth::Chain::GOERLI_OPTIMISM).to be 875
      expect(Eth::Chain.to_v 1, Eth::Chain::RINKEBY_ARBITRUM).to be 843258
      expect(Eth::Chain.to_v 0, Eth::Chain::PRIVATE_GETH).to be 2709
    end
    it "can recover v from ethereum recovery id" do
      expect(Eth::Chain.to_recovery_id 37).to be 0
      expect(Eth::Chain.to_recovery_id 38).to be 1

      # legacy v
      expect(Eth::Chain.to_recovery_id 0).to be 0
      expect(Eth::Chain.to_recovery_id 1).to be 1
      expect(Eth::Chain.to_recovery_id 27).to be 0
      expect(Eth::Chain.to_recovery_id 28).to be 1
    end
    it "can recover v from other chain's recovery id" do
      expect(Eth::Chain.to_recovery_id 157, Eth::Chain::CLASSIC).to be 0
      expect(Eth::Chain.to_recovery_id 236, Eth::Chain::XDAI).to be 1
      expect(Eth::Chain.to_recovery_id 84357, Eth::Chain::ARBITRUM).to be 0
      expect(Eth::Chain.to_recovery_id 160, Eth::Chain::MORDEN_CLASSIC).to be 1
      expect(Eth::Chain.to_recovery_id 875, Eth::Chain::GOERLI_OPTIMISM).to be 0
      expect(Eth::Chain.to_recovery_id 843258, Eth::Chain::RINKEBY_ARBITRUM).to be 1
      expect(Eth::Chain.to_recovery_id 2709, Eth::Chain::PRIVATE_GETH).to be 0
    end
    it "raises an error for invalid v on chain ids" do
      expect {Eth::Chain.to_recovery_id -1}.to raise_error ArgumentError
      expect {Eth::Chain.to_recovery_id 36}.to raise_error ArgumentError
      expect {Eth::Chain.to_recovery_id 843258, Eth::Chain::PRIVATE_GETH}.to raise_error ArgumentError
    end
  end
end
