require "spec_helper"

describe Contract do
  subject(:solc) { Eth::Solidity.new }
  subject(:contract) { solc.compile(file) }
  subject(:dummy_contract) { Contract.new(name, bin, abi) }

  let(:file) { "spec/fixtures/contracts/dummy.sol" }
  let(:name) { contract.keys[0] }
  let(:bin) { contract[name]["bin"] }
  let(:abi) { contract[name]["abi"] }
  let(:addr) { "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed" }

  describe ".initialize" do
    it "Dummy contract initialized" do
      expect(dummy_contract).to be_instance_of(Contract)
    end
  end

  describe "address=" do
    it "set valid address" do
      dummy_contract.address = Eth::Address.new addr
      expect(dummy_contract.address).to eq addr
    end

    it "invalid address cannot be set" do
      expect { dummy_contract.address = "0x1" }.to raise_error Address::CheckSumError
    end
  end

  describe ".from_file .from_bin .from_abi" do
    it "create contract from file" do
      contract = Contract.from_file(file: file)
      expect(contract.address).to be nil
      expect(contract).to be_instance_of(Eth::Contract::Dummy)
    end

    it "create contract from binary" do
      contract = Contract.from_bin(name: name, abi: abi, bin: bin)
      expect(contract).to be_instance_of(Eth::Contract::Dummy)
    end

    it "create contract from abi" do
      contract = Contract.from_abi(name: name, abi: abi, address: addr)
      expect(contract).to be_instance_of(Eth::Contract::Dummy)
      expect(contract.address).to eq addr
    end

    it "arguments are missing" do
      expect { Contract.from_file() }.to raise_error ArgumentError, "missing keyword: :file"
      expect { Contract.from_abi(name: name, address: addr) }.to raise_error ArgumentError, "missing keyword: :abi"
      expect { Contract.from_bin(name: name, abi: abi) }.to raise_error ArgumentError, "missing keyword: :bin"
    end

    it "invalid abi json parsing fails" do
      abi = abi.to_json + '"'
      expect { Contract.from_abi(name: name, abi: abi, address: addr) }.to raise_error JSON::ParserError
      expect { Contract.from_bin(name: name, abi: abi, bin: bin) }.to raise_error JSON::ParserError
    end

    it "contract index can be specified" do
      file = "spec/fixtures/contracts/greeter.sol"
      greeter = Contract.from_file(file: file, contract_index: 0)
      expect(greeter).to be_instance_of(Eth::Contract::Greeter)
      mortal = Contract.from_file(file: file, contract_index: 1)
      expect(mortal).to be_instance_of(Eth::Contract::Mortal)
    end

    it "supports contract with tuples" do
      file = "spec/fixtures/abi/Tuple.json"
      abi = JSON.parse(File.read(file))
      tuples = Contract.from_abi(name: "Tuple", address: "0x0000000000000000000000000000000000000000", abi: abi)
      expect(tuples.functions[0].inputs[0].type).to eq("tuple")
      expect(tuples.functions[0].inputs[0].parsed_type.components.size).to eq(7)
      expect(tuples.functions[0].inputs[0].parsed_type.components[0].base_type).to eq("string")
      expect(tuples.functions[0].inputs[0].parsed_type.components[0].dimensions).to eq([])

      expect(tuples.functions[0].inputs[0].parsed_type.components[1].base_type).to eq("string")
      expect(tuples.functions[0].inputs[0].parsed_type.components[1].dimensions).to eq([])

      expect(tuples.functions[0].inputs[0].parsed_type.components[2].base_type).to eq("tuple")
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].dimensions).to eq([0])
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components.size).to eq(3)
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components[0].base_type).to eq("uint")
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components[1].base_type).to eq("string")
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components[2].base_type).to eq("tuple")
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components[2].components.size).to eq(2)
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components[2].components[0].base_type).to eq("string")
      expect(tuples.functions[0].inputs[0].parsed_type.components[2].components[2].components[1].base_type).to eq("bytes")

      expect(tuples.functions[0].inputs[0].parsed_type.components[3].base_type).to eq("uint")
      expect(tuples.functions[0].inputs[0].parsed_type.components[3].sub_type).to eq("256")

      expect(tuples.functions[0].inputs[0].parsed_type.components[4].base_type).to eq("string")
      expect(tuples.functions[0].inputs[0].parsed_type.components[4].dimensions).to eq([0])

      expect(tuples.functions[0].inputs[0].parsed_type.components[5].base_type).to eq("bytes")
      expect(tuples.functions[0].inputs[0].parsed_type.components[5].dimensions).to eq([10])

      expect(tuples.functions[0].inputs[0].parsed_type.components[6].base_type).to eq("tuple")
      expect(tuples.functions[0].inputs[0].parsed_type.components[6].dimensions).to eq([])
      expect(tuples.functions[0].inputs[0].parsed_type.components[6].components.size).to eq(2)
      expect(tuples.functions[0].inputs[0].parsed_type.components[6].components[0].base_type).to eq("string")
      expect(tuples.functions[0].inputs[0].parsed_type.components[6].components[1].base_type).to eq("bytes")
    end

    it "supports arrays of addresses" do
      geth = Client.create("/tmp/geth.ipc")
      cont = Contract.from_file(file: "spec/fixtures/contracts/address_storage.sol")
      depl = geth.deploy_and_wait(cont)
      expect(geth.call(cont, "retrieveMyAddress")).to eq "0x0000000000000000000000000000000000000000"
      hash = geth.transact_and_wait(cont, "storeMyAddress", "0xbdc4d90b1d46353eb65eca3d0aeb968039f8aa9d")
      expect(geth.call(cont, "retrieveMyAddress")).to eq "0xbdc4d90b1d46353eb65eca3d0aeb968039f8aa9d"
      hash = geth.transact_and_wait(cont, "storeMyArray", ["0x5b02dE1c1774FA4bFEaa69AE57696F11fc92fA26", "0x35504b098187011f3d89232e0ea8990aBa8cB36B", "0x852b8A5b155C3aaB8EafE1BAd2c0E2D3D643F69d"])
      expect(geth.call(cont, "retrieveMyArray", 0)).to eq "0x5b02dE1c1774FA4bFEaa69AE57696F11fc92fA26".downcase
      expect(geth.call(cont, "retrieveMyArray", 1)).to eq "0x35504b098187011f3d89232e0ea8990aBa8cB36B".downcase
      expect(geth.call(cont, "retrieveMyArray", 2)).to eq "0x852b8A5b155C3aaB8EafE1BAd2c0E2D3D643F69d".downcase
    end
  end

  describe "#decode_log" do
    let(:erc20_abi) { JSON.parse(File.read("spec/fixtures/abi/ERC20.json")) }
    subject(:erc20) { Contract.from_abi(name: "ERC20", abi: erc20_abi, address: addr) }

    let(:topics) do
      [
        # Transfer event signature
        "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
        # from
        "0x00000000000000000000000071660c4005ba85c37ccec55d0c4493e66fe775d3",
        # to
        "0x000000000000000000000000639671019ddd8ec28d35113d8d1c5f1bbfd7e0be",
      ]
    end
    let(:data) { "0x00000000000000000000000000000000000000000000000000000002540be400" }

    it "decodes event logs by signature" do
      decoded = erc20.decode_log(topics, data)
      expect(decoded["from"]).to eq "0x71660c4005ba85c37ccec55d0c4493e66fe775d3"
      expect(decoded["to"]).to eq "0x639671019ddd8ec28d35113d8d1c5f1bbfd7e0be"
      expect(decoded["value"]).to eq 10000000000
    end

    it "accepts topics without hex prefix" do
      decoded = erc20.decode_log(topics.map { |t| Eth::Util.remove_hex_prefix(t) }, data)
      expect(decoded["from"]).to eq "0x71660c4005ba85c37ccec55d0c4493e66fe775d3"
    end

    it "raises for unknown event signatures" do
      expect { erc20.decode_log(["0x#{"00" * 32}"], "0x") }.to raise_error ArgumentError, "this event does not exist!"
    end
  end

  describe "#function" do
    it "finds function by name" do
      expect(dummy_contract.function("set").name).to eq("set")
      expect(dummy_contract.function("set", args: 1).name).to eq("set")
    end

    it "raises in args size mismatch" do
      expect do
        dummy_contract.function("set", args: 0)
      end.to raise_error("this function does not exist!")
      expect do
        dummy_contract.function("get", args: 1)
      end.to raise_error("this function does not exist!")
    end
  end
end
